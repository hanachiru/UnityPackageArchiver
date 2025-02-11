BeforeAll {
    Import-Module "${PSScriptRoot}/../../UnityPackageArchiver" -Force

    if (Test-Path -Path "${PSScriptRoot}/../Data/Compress/Output") {
        Remove-Item -Path "${PSScriptRoot}/../Data/Compress/Output" -Recurse -Force
    }
    New-Item -ItemType Directory -Path "${PSScriptRoot}/../Data/Compress/Output" -Force
}

Describe 'Compress-UnityPackage' {
    Context 'Normal Scenario' {
        It 'Compress UnityPackage' {
            Compress-UnityPackage `
                -OutputFilePath "${PSScriptRoot}/../Data/Compress/Output/sample.unitypackage" `
                -TargetFiles "${PSScriptRoot}/../Data/Compress/Input/Assets/Prefabs/GameObject.prefab", `
                "${PSScriptRoot}/../Data/Compress/Input/Assets/Scenes/SampleScene.unity", `
                "${PSScriptRoot}/../Data/Compress/Input/Assets/Scripts/Sample.cs", `
                "${PSScriptRoot}/../Data/Compress/Input/Assets/Scripts/Editor/SampleEditor.cs", `
                "${PSScriptRoot}/../Data/Compress/Input/Assets/Sprites/logo.png", `
                "${PSScriptRoot}/../Data/Compress/Input/Assets/Sprites/note.pdf"
            Test-Path -Path "${PSScriptRoot}/../Data/Compress/Output/sample.unitypackage" | Should -Be $true    
        }
    }

    Context 'Exception Scenario' {
        It 'invalid extension' {
            { Compress-UnityPackage -OutputFilePath "${PSScriptRoot}/../Data/Compress/Output/sample.zip" -TargetFiles "${PSScriptRoot}/../Data/Compress/Input/Assets/Prefabs/GameObject.prefab" } | Should -Throw
        }

        It 'TargetFiles does not exist' {
            { Compress-UnityPackage -OutputFilePath "${PSScriptRoot}/../Data/Compress/Output/sample.unitypackage" -TargetFiles "${PSScriptRoot}/../Data/Compress/Input/Assets/Invalid.cs" } | Should -Throw
        }

        It 'TargetFiles is empty' {
            { Compress-UnityPackage -OutputFilePath "${PSScriptRoot}/../Data/Compress/Output/sample.unitypackage" -TargetFiles @() } | Should -Throw
        }

        It 'TargetFiles includes .meta' {
            { Compress-UnityPackage -OutputFilePath "${PSScriptRoot}/../Data/Compress/Output/sample.unitypackage" -TargetFiles "${PSScriptRoot}/../Data/Compress/Input/Assets/Prefabs/GameObject.prefab.meta" } | Should -Throw
        }
    }
}