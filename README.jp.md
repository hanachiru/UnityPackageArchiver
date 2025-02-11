# UnityPackageArchiver

[English](README.md)

UnityPackageArchiver は.unitypackage のフォーマットに圧縮・展開ができる PowerShell のモジュールです。

# 目次

- [要件](#要件)
- [インストール](#インストール)
  - [PowerShell Gallery](#PowerShell Gallery)
  - [CI/CD](#CI/CD)
- [使い方](#使い方)
  - [基本的な使い方](#基本的な使い方)
  - [CI/CD での使い方](#CI/CD での使い方)

# 要件

-

# インストール

## PowerShell Gallery

```shell
$ dotnet add package RapidEnum
```

**PowerShell Gallery : [UnityPackageArchiver](https://www.powershellgallery.com/)**

## CI/CD

# 使い方

## 基本的な使い方

```powershell
Expand-UnityPackage -UnityPackagePath "C:\path\to\package.unitypackage" -OutputDir "C:\output\directory"
Compress-UnityPackage -OutputFilePath "C:\path\to\output.unitypackage" -TargetFiles "C:\path\to\Assets\MyAsset.prefab", "C:\path\to\Assets\MyScript.cs"
```

## CI/CD での使い方
