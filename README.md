# UnityPackageArchiver

[日本語](README.jp.md)

UnityPackageArchiver is a PowerShell module that allows you to compress and expand .unitypackage format without using Unity.

It works on ubuntu, windows and macos. Also useful for CI/CD.

![20250212110228](https://github.com/user-attachments/assets/17b461ff-f43b-48a0-8f91-53378516840d)

# Table of Contents

- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
  - [Basic Usage](#basic-usage)
    - [Expand](#Expand)
    - [Compress](#compress)
  - [CI/CD](#cicd)

# Requirements

- Ubuntu or Windows or MacOS
- PowerShell
- tar command

# Installation

Run the following command in PowerShell.

```shell
$ Install-Module -Name UnityPackageArchiver
```

# Usage

## Basic Usage

Sample code is available [here](.github/workflows/sample.yml).

### Extract

You can extract a .unitypackage by running the following command.

```powershell
$ Expand-UnityPackage -UnityPackagePath "./path/to/package.unitypackage" -OutputDir "./output/directory"
```

### Compress

You can compress files into a .unitypackage by running the following command.

```powershell
$ Compress-UnityPackage -OutputFilePath "./path/to/output.unitypackage" -TargetFiles "./path/to/Assets/MyAsset.prefab", "./path/to/Assets/MyScript.cs"
```

List the files you want to include in -TargetFiles. Note that .meta files will be ignored even if specified.

## CI/CD

```yml
name: Sample
on: workflow_dispatch

jobs:
  sample:
    name: Sample
    runs-on: ubuntu-latest
    steps:
      # for checkout SampleData
      - name: check out
        uses: actions/checkout@v4
        with:
          ref: main

      - name: Use Expand-UnityPackage
        uses: hanachiru/UnityPackageArchiver/Expand-UnityPackage@main
        with:
          unity-package-path: "./Tests/Data/Expand/Input/sample.unitypackage"
          output-dir: "./Tests/Data/Expand/Output"

      - name: Use Compress-UnityPackage
        uses: hanachiru/UnityPackageArchiver/Compress-UnityPackage@main
        with:
          output-file-path: "./Tests/Data/Compress/Output/Sample.unitypackage"
          target-files: "./Tests/Data/Compress/Input/Assets/Prefabs/GameObject.prefab, ./Tests/Data/Compress/Input/Assets/Scenes/SampleScene.unity, ./Tests/Data/Compress/Input/Assets/Scripts/Sample.cs, ./Tests/Data/Compress/Input/Assets/Scripts/Editor/SampleEditor.cs, ./Tests/Data/Compress/Input/Assets/Sprites/logo.png, ./Tests/Data/Compress/Input/Assets/Sprites/note.pdf"
```

Sample code is available [here](.github/workflows/sample2.yml).
