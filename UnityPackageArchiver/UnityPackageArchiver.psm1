<#
.Synopsis
    import Unity packages.
.PARAMETER UnityPackagePath
    path to .unitypackage file
.PARAMETER OutputDir
    output directory path(default: same directory as .unitypackage file)
.EXAMPLE
    Import-UnityPackage -UnityPackagePath "C:\path\to\package.unitypackage" -OutputDir "C:\output\directory"
#>
function Import-UnityPackage {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$UnityPackagePath,

        [Parameter(Mandatory = $false)]
        [string]$OutputDir = ""
    )

    # Validate
    if (-not (Get-Command tar -ErrorAction SilentlyContinue)) {
        throw "The 'tar' command is not available. Please ensure that 'tar' is installed and accessible in your PATH."
    }

    if (-not (Test-Path -Path $UnityPackagePath)) {
        throw "The input file does not exist: $UnityPackagePath"
    }

    $unityPackageExtension = [System.IO.Path]::GetExtension($UnityPackagePath)
    if ($unityPackageExtension -ne ".unitypackage") {
        throw "The input file must be a .unitypackage file."
    }

    # Setup
    if (-not $OutputDir) {
        $OutputDir = [System.IO.Path]::GetDirectoryName($UnityPackagePath)
    }
    $tempDirPath = Join-Path -Path $OutputDir -ChildPath "temp"
    if (Test-Path -Path $tempDirPath) {
        Remove-Item -Path $tempDirPath -Recurse -Force
    }
    New-Item -ItemType Directory -Path $tempDirPath
    if (-not (Test-Path -Path $OutputDir)) {
        New-Item -ItemType Directory -Path $OutputDir
    }

    # .tar.gz
    tar -xzf $UnityPackagePath -C $tempDirPath

    # Mapping
    $mapping = @{}
    Get-ChildItem -Path $tempDirPath | ForEach-Object {
        $dirPath = $_.FullName
        $guid = $_.Name

        if (Test-Path -Path $dirPath -PathType Container) {
            $path = ''

            Get-ChildItem -Path $dirPath | ForEach-Object {
                if ($_.Name -eq "pathname") {
                    $path = Get-Content -Path $_.FullName -Encoding utf8 | Select-Object -First 1
                }
            }

            $mapping[$guid] = $path
        }
    }

    # File Move
    foreach ($guid in $mapping.Keys) {
        $path = Split-Path -Path $mapping[$guid] -Parent
        $fileName = Split-Path -Path $mapping[$guid] -Leaf
        $metaFileName = "${fileName}.meta"

        $destDir = Join-Path $OutputDir -ChildPath $path

        $assetFile = Join-Path $destDir -ChildPath $fileName
        $metaFile = Join-Path $destDir -ChildPath $metaFileName

        $source = Join-Path -Path $tempDirPath -ChildPath "${guid}/asset"
        $metaSource = Join-Path -Path $tempDirPath -ChildPath "${guid}/asset.meta"

        if (-not (Test-Path -Path $destDir)) {
            New-Item -ItemType Directory -Path $destDir
        }

        if (Test-Path -Path $source) {
            Move-Item -Path $source -Destination $assetFile -Force
        }
        if (Test-Path -Path $metaSource) {
            Move-Item -Path $metaSource -Destination $metaFile -Force
        }

        Write-Output "$guid => $mapping[$guid]"
    }

    Remove-Item -Path $tempDirPath -Recurse -Force
}

<#
.Synopsis
    Export .unitypackage file.
.PARAMETER OutputFilePath
    The path where the .unitypackage file will be saved.
.PARAMETER TargetFiles
    The files to be included in the .unitypackage file. (Do not include .meta)
.EXAMPLE
    Export-UnityPackage -OutputFilePath "C:\path\to\output.unitypackage" -TargetFiles "C:\path\to\Assets\MyAsset.prefab", "C:\path\to\Assets\MyScript.cs"
#>
function Export-UnityPackage {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$OutputFilePath,

        [Parameter(Mandatory = $true)]
        [string[]]$TargetFiles
    )

    $outputFileExtension = [System.IO.Path]::GetExtension($OutputFilePath)
    if ($outputFileExtension -ne ".unitypackage") {
        throw "The output file must be a .unitypackage file."
    }
    if ($TargetFiles.Count -eq 0) {
        throw "The target files are empty."
    }

    $outputDirPath = [System.IO.Path]::GetDirectoryName($OutputFilePath)
    $tempDirPath = Join-Path -Path $outputDirPath -ChildPath "temp"
    if (Test-Path -Path $tempDirPath) {
        Remove-Item -Path $tempDirPath -Recurse -Force
    }
    New-Item -ItemType Directory -Path $tempDirPath

    # NOTE: "preview.png" is not supported
    #       "preview.png" is the thumbnail displayed on the Asset Store website.
    $mapping = @{}
    foreach ($targetFilePath in $TargetFiles) {
        # include file
        $targetFileMetaPath = "${targetFilePath}.meta"

        if (-not (Test-Path -Path $targetFilePath)) {
            throw "The target file does not exist: $targetFilePath"
        }
        if (-not (Test-Path -Path $targetFileMetaPath)) {
            throw "The target file's meta does not exist: $targetFileMetaPath"
        }

        $guid = ''
        Get-Content -Path $targetFileMetaPath -Encoding utf8 | ForEach-Object {
            if ($_ -match "guid: ([0-9a-fA-F]{32})") {
                $guid = $Matches[1]
            }
        }
        if (-not $guid) {
            throw "The target file's meta does not contain a guid: $targetFileMetaPath"
        }
        $mapping[$guid] = $targetFilePath

        # include directory
        $currentDirPath = Split-Path -Path $targetFilePath -Parent
        $currentDirName = Split-Path -Path $currentDirPath -Leaf
        while ($currentDirName -ne "Assets" -and $currentDirPath -ne [System.IO.Path]::GetPathRoot($currentDirPath)) {
            $parentDirPath = Split-Path -Path $currentDirPath -Parent
            $parentDirName = Split-Path -Path $parentDirPath -Leaf
            $metaPath = Join-Path -Path $parentDirPath -ChildPath "${currentDirName}.meta"
            
            if (Test-Path -Path $metaPath) {
                $dirGuid = ''
                Get-Content -Path $metaPath -Encoding utf8 | ForEach-Object {
                    if ($_ -match "guid: ([0-9a-fA-F]{32})") {
                        $dirGuid = $Matches[1]
                    }
                }
                if (-not $dirGuid) {
                    throw "The target file's meta does not contain a guid: $metaPath"
                }

                $mapping[$dirGuid] = $currentDirPath
            }
            $currentDirPath = $parentDirPath
            $currentDirName = $parentDirName
        }
    }

    foreach ($guid in $mapping.Keys) {
        $dirPath = Join-Path -Path $tempDirPath -ChildPath $guid
        New-Item -ItemType Directory -Path $dirPath

        $sourceFile = $mapping[$guid]
        $sourceMetaFile = "${sourceFile}.meta"

        $assetPath = Join-Path -Path $dirPath -ChildPath "asset"
        $metaPath = Join-Path -Path $dirPath -ChildPath "asset.meta"
        $pathnamePath = Join-Path -Path $dirPath -ChildPath "pathname"

        if (Test-Path -Path $sourceFile -PathType Leaf) {
            Copy-Item  -Path $sourceFile -Destination $assetPath -Force
        }
        Copy-Item  -Path $sourceMetaFile -Destination $metaPath -Force

        # NOTE: Extracts the first matching ‘Assets’ and subsequent parts from the Path.
        $path = $mapping[$guid] -replace '.*?(Assets)', 'Assets'
        Set-Content -Path $pathnamePath -Value $path -Encoding utf8
    }

    tar -czf $OutputFilePath -C $tempDirPath .

    Remove-Item -Path $tempDirPath -Recurse -Force
}