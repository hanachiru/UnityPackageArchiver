BeforeAll {
    Import-Module "${PSScriptRoot}/../../UnityPackageArchiver" -Force

    if (Test-Path -Path "${PSScriptRoot}/../Data/Export/Output") {
        Remove-Item -Path "${PSScriptRoot}/../Data/Export/Output" -Recurse -Force
    }
    New-Item -ItemType Directory -Path "${PSScriptRoot}/../Data/Export/Output" -Force
}

Describe 'Export-UnityPackage' {
    Context 'Normal Scenario' {
        It 'Export UnityPackage' {
            Export-UnityPackage `
                -OutputFilePath "${PSScriptRoot}/../Data/Export/Output/sample.unitypackage" `
                -TargetFiles "${PSScriptRoot}/../Data/Export/Input/Assets/Prefabs/GameObject.prefab", `
                "${PSScriptRoot}/../Data/Export/Input/Assets/Scenes/SampleScene.unity", `
                "${PSScriptRoot}/../Data/Export/Input/Assets/Scripts/Sample.cs", `
                "${PSScriptRoot}/../Data/Export/Input/Assets/Scripts/Editor/SampleEditor.cs", `
                "${PSScriptRoot}/../Data/Export/Input/Assets/Sprites/logo.png", `
                "${PSScriptRoot}/../Data/Export/Input/Assets/Sprites/note.pdf"
            Test-Path -Path "${PSScriptRoot}/../Data/Export/Output/sample.unitypackage" | Should -Be $true    
        }
    }

    Context 'Exception Scenario' {
        It 'invalid extension' {
            { Export-UnityPackage -OutputFilePath "${PSScriptRoot}/../Data/Export/Output/sample.zip" -TargetFiles "${PSScriptRoot}/../Data/Export/Input/Assets/Prefabs/GameObject.prefab" } | Should -Throw
        }

        It 'TargetFiles does not exist' {
            { Export-UnityPackage -OutputFilePath "${PSScriptRoot}/../Data/Export/Output/sample.unitypackage" -TargetFiles "${PSScriptRoot}/../Data/Export/Input/Assets/Invalid.cs" } | Should -Throw
        }

        It 'TargetFiles is empty' {
            { Export-UnityPackage -OutputFilePath "${PSScriptRoot}/../Data/Export/Output/sample.unitypackage" -TargetFiles @() } | Should -Throw
        }

        It 'TargetFiles includes .meta' {
            { Export-UnityPackage -OutputFilePath "${PSScriptRoot}/../Data/Export/Output/sample.unitypackage" -TargetFiles "${PSScriptRoot}/../Data/Export/Input/Assets/Prefabs/GameObject.prefab.meta" } | Should -Throw
        }
    }
}