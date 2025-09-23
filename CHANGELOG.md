# Changelog or DataSanitizer

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

- **GitHub Copilot Configuration**
  - [chatmode] Implementation plan generation chatmode
  - [chatmode] Debugging chatmode
  - [chatmode] 4.1 Beast Mode chatmode
  - [prompt] Review and refactor prompt for code review
  - [prompt] Prompt for creating a comprehensive implementation plan
  - [instruction] Self-explanatory code commenting guidelines
  - [instruction] PowerShell cmdlet development guidelines
  - [instruction] PowerShell Pester v5 testing guidelines
  - [instruction] Markdown content rules and validation instructions
  - Added Copilot development instructions
  - Added Renovate configuration for automated dependency management

## [0.2.3] - 2025-07-17

- Fix the Changelog Format

## [0.2.2] - 2025-07-17

### Added

- Fix the branching strategy doc

## [0.2.1] - 2025-07-17

### Added

- Fix Typo in Changelog

## [0.2.0] - 2025-07-17

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
- **Development Environment Enhancements**:
  - Added a new dev container configuration in `.devcontainer/devcontainer.json`
  - Updated `.vscode/extensions.json` to recommend the `redhat.vscode-yaml` extension for YAML editing.
  - Configured `.vscode/settings.json` for YAML schema validation and support for custom tags.
- **Documentation**
  - Introduced a `docs/.vitepress/config.mts` file to configure the VitePress site with navigation, sidebar, social links, and Mermaid.js integration for diagrams.
  - Added a custom VitePress theme in `docs/.vitepress/theme/`, including a `style.css` file for overriding default styles and defining custom color variables.
  - Expanded developer documentation with detailed guides on coding standards, contributing, development workflow, environment setup, testing, and releasing.
