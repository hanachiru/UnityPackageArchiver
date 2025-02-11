# UnityPackageArchiver

[日本語](README.jp.md)

UnityPackageArchiver is a PowerShell module that can compress and extract the .unitypackage format.

# Table of Contents

- [Requirements](#requirements)
- [Installation](#installation)
  - [PowerShell Gallery](#powershell-gallery)
  - [CI/CD](#cicd)
- [Usage](#usage)
  - [Basic Usage](#basic-usage)
  - [Usage in CI/CD](#usage-in-cicd)

# Requirements

-

# Installation

## PowerShell Gallery

## CI/CD

# Usage

## Basic Usage

```powershell
Import-UnityPackage -UnityPackagePath "C:\path\to\package.unitypackage" -OutputDir "C:\output\directory"
Export-UnityPackage -OutputFilePath "C:\path\to\output.unitypackage" -TargetFiles "C:\path\to\Assets\MyAsset.prefab", "C:\path\to\Assets\MyScript.cs"
```

## Usage in CI/CD
