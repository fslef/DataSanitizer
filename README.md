# DataSanitizer

[![codecov](https://codecov.io/gh/fslef/DataSanitizer/graph/badge.svg?token=GeMGD62rz5)](https://codecov.io/gh/fslef/DataSanitizer)

**DataSanitizer** is a PowerShell module for automated processing of personal and sensitive data in structured and unstructured sources. It is designed for use in secure data workflows to support privacy compliance and operational security requirements.

This tool is intended for security analysts, compliance teams, and DevSecOps pipelines requiring reliable data handling in alignment with data protection regulations such as GDPR, HIPAA, and ISO/IEC 27001.

## Installation

```powershell
Import-Module ./DataSanitizer.psm1
```

## Basic Usage

```powershell
Invoke-DataSanitizer -Path ".\input\data.txt" -OutputPath ".\output\data_sanitized.txt"
```

## Requirements

- PowerShell 5.1 or later (PowerShell Core supported)
- ExecutionPolicy allowing local script execution

## License

This project is licensed under the MIT License.

## Contributing

For issues or contributions, please use the GitHub issue tracker.
