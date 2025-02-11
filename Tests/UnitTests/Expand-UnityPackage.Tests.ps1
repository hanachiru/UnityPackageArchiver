BeforeAll {
    Expand-Module "${PSScriptRoot}/../../UnityPackageArchiver" -Force
    
    if (Test-Path -Path "${PSScriptRoot}/../Data/Expand/Output") {
        Remove-Item -Path "${PSScriptRoot}/../Data/Expand/Output" -Recurse -Force
    }
    New-Item -ItemType Directory -Path "${PSScriptRoot}/../Data/Expand/Output" -Force
}

Describe 'Expand-UnityPackage' {
    Context 'Nomal Scenario' {
        It 'Expand UnityPackage' {
            Expand-UnityPackage -UnityPackagePath "${PSScriptRoot}/../Data/Expand/Input/sample.unitypackage" -OutputDir "${PSScriptRoot}/../Data/Expand/Output"

            Test-Path -Path "${PSScriptRoot}/../Data/Expand/Output/Assets/Prefabs/GameObject.prefab" | Should -Be $true
            Test-Path -Path "${PSScriptRoot}/../Data/Expand/Output/Assets/Prefabs/GameObject.prefab.meta" | Should -Be $true
            Test-Path -Path "${PSScriptRoot}/../Data/Expand/Output/Assets/Scenes/SampleScene.unity" | Should -Be $true
            Test-Path -Path "${PSScriptRoot}/../Data/Expand/Output/Assets/Scenes/SampleScene.unity.meta" | Should -Be $true
            Test-Path -Path "${PSScriptRoot}/../Data/Expand/Output/Assets/Scripts/Editor/SampleEditor.cs" | Should -Be $true
            Test-Path -Path "${PSScriptRoot}/../Data/Expand/Output/Assets/Scripts/Editor/SampleEditor.cs.meta" | Should -Be $true
            Test-Path -Path "${PSScriptRoot}/../Data/Expand/Output/Assets/Scripts/Sample.cs" | Should -Be $true
            Test-Path -Path "${PSScriptRoot}/../Data/Expand/Output/Assets/Scripts/Sample.cs.meta" | Should -Be $true
            Test-Path -Path "${PSScriptRoot}/../Data/Expand/Output/Assets/Sprites/logo.png" | Should -Be $true
            Test-Path -Path "${PSScriptRoot}/../Data/Expand/Output/Assets/Sprites/logo.png.meta" | Should -Be $true
            Test-Path -Path "${PSScriptRoot}/../Data/Expand/Output/Assets/Sprites/note.pdf" | Should -Be $true
            Test-Path -Path "${PSScriptRoot}/../Data/Expand/Output/Assets/Sprites/note.pdf.meta" | Should -Be $true
        }
    }

    Context 'Exception Scenario' {
        It 'Expand UnityPackage with invalid path' {
            { Expand-UnityPackage -UnityPackagePath "${PSScriptRoot}/../Data/Expand/Input/invalid.unitypackage" -OutputDir "${PSScriptRoot}/../Data/Expand/Output" } | Should -Throw
        }
        It 'Expand UnityPackage with invalid extension' {
            { Expand-UnityPackage -UnityPackagePath "${PSScriptRoot}/../Data/Expand/Input/sample.zip" -OutputDir "${PSScriptRoot}/../Data/Expand/Output" } | Should -Throw
        }
    }
}