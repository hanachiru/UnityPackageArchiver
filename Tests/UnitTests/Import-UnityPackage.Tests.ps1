BeforeAll {
    Import-Module "${PSScriptRoot}/../../UnityPackageArchiver" -Force
    
    if (Test-Path -Path "${PSScriptRoot}/../Data/Import/Output") {
        Remove-Item -Path "${PSScriptRoot}/../Data/Import/Output" -Recurse -Force
    }
    New-Item -ItemType Directory -Path "${PSScriptRoot}/../Data/Import/Output" -Force
}

Describe 'Import-UnityPackage' {
    Context 'Nomal Scenario' {
        It 'Import UnityPackage' {
            Import-UnityPackage -UnityPackagePath "${PSScriptRoot}/../Data/Import/Input/sample.unitypackage" -OutputDir "${PSScriptRoot}/../Data/Import/Output"

            Test-Path -Path "${PSScriptRoot}/../Data/Import/Output/Assets/Prefabs/GameObject.prefab" | Should -Be $true
            Test-Path -Path "${PSScriptRoot}/../Data/Import/Output/Assets/Prefabs/GameObject.prefab.meta" | Should -Be $true
            Test-Path -Path "${PSScriptRoot}/../Data/Import/Output/Assets/Scenes/SampleScene.unity" | Should -Be $true
            Test-Path -Path "${PSScriptRoot}/../Data/Import/Output/Assets/Scenes/SampleScene.unity.meta" | Should -Be $true
            Test-Path -Path "${PSScriptRoot}/../Data/Import/Output/Assets/Scripts/Editor/SampleEditor.cs" | Should -Be $true
            Test-Path -Path "${PSScriptRoot}/../Data/Import/Output/Assets/Scripts/Editor/SampleEditor.cs.meta" | Should -Be $true
            Test-Path -Path "${PSScriptRoot}/../Data/Import/Output/Assets/Scripts/Sample.cs" | Should -Be $true
            Test-Path -Path "${PSScriptRoot}/../Data/Import/Output/Assets/Scripts/Sample.cs.meta" | Should -Be $true
            Test-Path -Path "${PSScriptRoot}/../Data/Import/Output/Assets/Sprites/logo.png" | Should -Be $true
            Test-Path -Path "${PSScriptRoot}/../Data/Import/Output/Assets/Sprites/logo.png.meta" | Should -Be $true
            Test-Path -Path "${PSScriptRoot}/../Data/Import/Output/Assets/Sprites/note.pdf" | Should -Be $true
            Test-Path -Path "${PSScriptRoot}/../Data/Import/Output/Assets/Sprites/note.pdf.meta" | Should -Be $true
        }
    }

    Context 'Exception Scenario' {
        It 'Import UnityPackage with invalid path' {
            { Import-UnityPackage -UnityPackagePath "${PSScriptRoot}/../Data/Import/Input/invalid.unitypackage" -OutputDir "${PSScriptRoot}/../Data/Import/Output" } | Should -Throw
        }
        It 'Import UnityPackage with invalid extension' {
            { Import-UnityPackage -UnityPackagePath "${PSScriptRoot}/../Data/Import/Input/sample.zip" -OutputDir "${PSScriptRoot}/../Data/Import/Output" } | Should -Throw
        }
    }
}