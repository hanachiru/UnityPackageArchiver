# UnityPackageArchiver

[English](README.md)

UnityPackageArchiver は Unity を利用せずに.unitypackage のフォーマットに圧縮・展開ができる PowerShell のモジュールです。

ubuntu・windows・macos で動作することができ、CI/CD でも利用できます。

![20250212110228](https://github.com/user-attachments/assets/17b461ff-f43b-48a0-8f91-53378516840d)

# 目次

- [要件](#要件)
- [インストール](#インストール)
- [使い方](#使い方)
  - [基本的な使い方](#基本的な使い方)
    - [展開](#展開)
    - [圧縮](#圧縮)
  - [CI/CD](#CI/CD)

# 要件

- Ubuntu or Windows or MacOS
- PowerShell
- tar コマンド

# インストール

PowerShell で以下のコマンドを実行します。

```shell
$ Install-Module -Name UnityPackageArchiver
```

**PowerShell Gallery : [UnityPackageArchiver](https://www.powershellgallery.com/packages/UnityPackageArchiver)**

# 使い方

## 基本的な使い方

サンプルコードは[こちら](.github/workflows/sample.yml)にあります。

### 展開

以下のコマンドを実行することで.unitypackage を展開することができます。

```powershell
$ Expand-UnityPackage -UnityPackagePath "./path/to/package.unitypackage" -OutputDir "./output/directory"
```

### 圧縮

以下のコマンドを実行することで.unitypackage に圧縮することができます。

```powershell
$ Compress-UnityPackage -OutputFilePath "./path/to/output.unitypackage" -TargetFiles "./path/to/Assets/MyAsset.prefab", "./path/to/Assets/MyScript.cs"
```

-TargetFiles には含めたいファイルの一覧を記述します。また.meta ファイルを指定しても無視されるので注意してください。

## CI/CD

```yaml
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

サンプルコードは[こちら](.github/workflows/sample2.yml)にあります。
