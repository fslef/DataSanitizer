# Testing

Testing is a core part of our workflow. All new features and bug fixes should include tests to ensure reliability and maintainability. We use [Pester](https://pester.dev/) for PowerShell tests, and our test suite is organized for clarity and coverage.

## Running Tests
To run all tests, simply use:

```powershell
./build.ps1 -Tasks test
```

This will execute all unit and QA tests, and generate a coverage report in the `testResults/` directory.

## Writing Tests
- Place unit tests in `tests/Unit/` and integration/QA tests in `tests/QA/`.
- Use descriptive test names and structure tests logically.
- Mock external dependencies where possible to keep tests fast and focused.

## Code Coverage
We track code coverage automatically. The minimum required coverage threshold is defined in the build configuration. You can always see the current value directly from the code:

[See build.yaml (CoveragePercentTarget)](https://github.com/fslef/DataSanitizer/blob/main/build.yaml)

```yaml{2}
CodeCoverage:
  CoveragePercentTarget: 10 # Set to 0 to bypass
```

The actual coverage requirement may be updated by maintainers as the project matures. For the most current threshold, always refer to the `CoveragePercentTarget` value in `build.yaml`.

Additionally, our CI/CD pipeline enforces a project-wide coverage target and patch threshold, as defined in `codecov.yml`:

```yaml{7-11}
coverage:
  status:
    project:
      default:
        target: 70
    patch:
      default:
        threshold: 5
```

## Linting & Static Analysis
All code is automatically checked for style and best practices using PSScriptAnalyzer. This is enforced both in CI and locally via the test suite. You can find the rules and integration in `tests/QA/module.tests.ps1`.

No manual setup is needed—just use the dev container and run the tests!
