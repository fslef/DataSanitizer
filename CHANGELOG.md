# Changelog or DataSanitizer

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- **Module Bootstrap**
  - Added initial implementation of the `DataSanitizer` module
- **Project Configuration and Automation**
  - Added `.gitattributes` for line endings and binary file handling
  - Added `.gitignore` for standard exclusions
  - Added `.vscode/tasks.json` with PowerShell-based build and test automation using problem matchers
  - Configured `GitVersion.yml` for semantic versioning based on Git history
  - Added `RequiredModules.psd1` specifying `Pester`, `PSScriptAnalyzer`, and `InvokeBuild`
- **Documentation and Community Guidelines**
  - Added `README.md` with project overview, installation instructions, usage examples, and system requirements
  - Added `CONTRIBUTING.md` detailing development workflow, coding conventions, and bug reporting process
  - Introduced `CODE_OF_CONDUCT.md` based on the Contributor Covenant
  - Added `SECURITY.md` with vulnerability disclosure procedures
  - Added `CHANGELOG.md` conforming to Keep a Changelog guidelines
- **Issue Reporting Templates**
  - Added `.github/ISSUE_TEMPLATE/1-bug.yaml` for bug reports
  - Added `.github/ISSUE_TEMPLATE/2-feature-request.yaml` for feature requests
  - Added `.github/ISSUE_TEMPLATE/3-detection-improvement-suggestion.yaml` for detection-related suggestions
  - Added `.github/ISSUE_TEMPLATE/config.yml` to disable blank issues and redirect users to a support contact page
- **CI/CD**
  - Added PowerShell workflow for automated script analysis and SARIF upload.

### Changed

- For changes in existing functionality.

### Deprecated

- For soon-to-be removed features.

### Removed

- For now removed features.

### Fixed

- For any bug fix.

### Security

- In case of vulnerabilities.

