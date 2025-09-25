# DataSanitizer Development Instructions

**ALWAYS follow these instructions first.** Only use additional search and context gathering if the information here is incomplete or found to be in error.

DataSanitizer is a PowerShell module for automated processing of personal and sensitive data in structured and unstructured sources. It is built using the Sampler PowerShell module framework with InvokeBuild automation.

## Quick Development Workflow Example

**For making and validating a simple change (works offline):**

```powershell
# 1. Edit a function file (e.g., source/Public/Get-Something.ps1)

# 2. Test the change immediately
. ./source/Public/Get-Something.ps1
. ./source/Private/Get-PrivateFunction.ps1
Get-Something -Data 'my test change' -Verbose

# 3. Run complete offline validation (takes <10 seconds)
# Basic functionality
Get-Something -Data 'validation test' -Verbose
# Pipeline
'test1', 'test2' | Get-Something
# WhatIf
Get-Something -Data 'test' -WhatIf
# Static analysis
Invoke-ScriptAnalyzer -Path source/Public/Get-Something.ps1

# 4. If network available, run full tests
./build.ps1 -Tasks test  # NEVER CANCEL - 3-5 minutes
```

**VALIDATION REQUIREMENT**: Always test at least basic functionality, pipeline support, and WhatIf behavior for any public function changes.

## Working Effectively

### Quick Start (Validated Commands)
**CRITICAL: Network connectivity to PowerShell Gallery is required for full builds but basic development can proceed without it.**

```powershell
# Basic module testing (works offline - fast: <1 second)
Import-Module ./source/DataSanitizer.psd1 -Force

# Test module functions manually (works offline)
. ./source/Public/Get-Something.ps1
. ./source/Private/Get-PrivateFunction.ps1
Get-Something -Data 'test' -Verbose

# Documentation development (works offline after npm install)
npm install                    # Takes ~30 seconds
npm run docs:dev              # Starts dev server on localhost
npm run docs:build            # **FAILS** due to dead link - takes ~9 seconds
npm run docs:preview          # Preview built docs
```

### Full Build Process (Requires Network)
**NEVER CANCEL: Full build with dependencies can take 15+ minutes. Set timeout to 30+ minutes.**

```powershell
# Bootstrap dependencies (NEVER CANCEL - takes 10-15 minutes on first run)
./build.ps1 -ResolveDependency

# Full build (NEVER CANCEL - takes 5-10 minutes)
./build.ps1 -Tasks build

# Run all tests (NEVER CANCEL - takes 3-5 minutes)
./build.ps1 -Tasks test

# Default build and test (NEVER CANCEL - takes 15-20 minutes total)
./build.ps1
```

**WARNING**: Build commands will fail without network access to PowerShell Gallery. For offline development, use the module import method above.

## Testing and Validation

### Manual Testing (Always Works - No Network Required)
**Use this for offline development and quick validation:**

```powershell
# Source functions directly (works offline)
. ./source/Public/Get-Something.ps1
. ./source/Private/Get-PrivateFunction.ps1

# Complete validation workflow (takes <10 seconds)
# 1. Basic functionality
Get-Something -Data 'validation test' -Verbose

# 2. Pipeline support
'test1', 'test2' | Get-Something

# 3. WhatIf parameter support
Get-Something -Data 'test' -WhatIf

# 4. Property-based pipeline input
[PSCustomObject]@{Data='property-test'} | Get-Something

# 5. Static analysis (requires PSScriptAnalyzer)
Invoke-ScriptAnalyzer -Path source/Public/Get-Something.ps1
```

### Automated Testing (Requires Network)
- **Pester Location**: `tests/Unit/` and `tests/QA/`
- **Coverage Target**: 85% (configured in build.yaml)
- **Dependencies**: Requires built module from full build process

```powershell
# Unit tests (requires built module)
Invoke-Pester -Path tests/Unit/Public/Get-Something.tests.ps1 -Output Detailed

# All tests with coverage (NEVER CANCEL - 3-5 minutes)
./build.ps1 -Tasks test
```

### Quality Assurance
- **PSScriptAnalyzer**: Included in QA tests for code quality
- **Help Documentation**: All public functions must have complete help
- **Changelog**: Must be updated for all changes

### Always Run Before Committing
```powershell
# If network available - NEVER CANCEL (takes 15-20 minutes)
./build.ps1 -Tasks test

# If network not available - complete manual validation workflow
. ./source/Public/Get-Something.ps1
. ./source/Private/Get-PrivateFunction.ps1

# Test basic functionality
Get-Something -Data 'validation test' -Verbose

# Test pipeline functionality
'test1', 'test2' | Get-Something

# Test WhatIf support
Get-Something -Data 'test' -WhatIf

# Run static analysis
Invoke-ScriptAnalyzer -Path source/Public/Get-Something.ps1
```

## Documentation

### VitePress Documentation
- **Development**: `npm run docs:dev` (starts local server)
- **Build Issues**: `npm run docs:build` currently fails due to dead link in `developer/contributing.md`
- **Workaround**: Use development server for previewing changes

```bash
# Documentation workflow (after npm install)
npm run docs:dev    # Development server with hot reload
# Note: docs:build fails due to dead link - use dev server instead
```

### PowerShell Help
- All public functions require complete comment-based help
- Must include: Synopsis, Description, Examples, Parameters
- Validated by QA tests in `tests/QA/module.tests.ps1`

## Repository Structure

### Key Directories
```
source/
├── DataSanitizer.psd1        # Module manifest
├── DataSanitizer.psm1        # Main module file (empty, built dynamically)
├── Public/                   # Exported functions
│   └── Get-Something.ps1     # Sample public function
└── Private/                  # Internal functions
    └── Get-PrivateFunction.ps1

tests/
├── Unit/                     # Unit tests
│   └── Public/               # Tests for public functions
└── QA/                       # Quality assurance tests
    └── module.tests.ps1      # Module-level QA tests

docs/                         # VitePress documentation
├── .vitepress/              # VitePress configuration
├── developer/               # Developer documentation
└── user/                    # User documentation
```

### Configuration Files
- **build.yaml**: Build configuration and coverage targets
- **build.ps1**: Main build script with InvokeBuild
- **RequiredModules.psd1**: PowerShell module dependencies
- **package.json**: npm dependencies for documentation

## Common Development Tasks

### Adding New Functions
1. Each function MUST be placed in its own `.ps1` file within `source/Public/` or `source/Private/`. This ensures maintainability, clarity, and supports best practices for PowerShell module development.
2. Each function MUST include a comment-based help block with at least:
   - .SYNOPSIS
   - .DESCRIPTION (Greater Than 40 Characters)
   - At least one .EXAMPLE
   - All parameters described with .PARAMETER
3. Create corresponding unit test in `tests/Unit/`
4. Test manually before running full build:
   ```powershell
   . ./source/Public/YourNewFunction.ps1
   YourNewFunction -Parameter 'test'
   ```

### Updating Documentation
1. Edit markdown files in `docs/` directory
2. Test with development server: `npm run docs:dev`
3. **Do not** rely on `npm run docs:build` until dead link is fixed

### Troubleshooting Build Issues
- **Network Failures**: Use manual module import for offline development
- **Dependency Issues**: Try `-ResolveDependency` flag with extended timeout
- **Test Failures**: Run individual test files with `Invoke-Pester -Path [test-file]`

## Time Expectations and Timeouts

| Command | Time | Notes |
|---------|------|-------|
| `Import-Module` | <1 second | Works offline |
| `npm install` | ~30 seconds | One-time setup |
| `npm run docs:dev` | ~5 seconds | Development server |
| `npm run docs:build` | ~9 seconds | **FAILS** due to dead link |
| `./build.ps1 -ResolveDependency` | 10-15 minutes | **NEVER CANCEL** - first run |
| `./build.ps1 -Tasks build` | 5-10 minutes | **NEVER CANCEL** |
| `./build.ps1 -Tasks test` | 3-5 minutes | **NEVER CANCEL** |
| `./build.ps1` (full) | 15-20 minutes | **NEVER CANCEL** |

## Validation Success Criteria

When validating changes, expect these specific outputs:

### Manual Function Testing
```powershell
# Expected: Function returns input unchanged with verbose output
PS> Get-Something -Data 'test' -Verbose
VERBOSE: Performing the operation "Get-Something" on target "test".
VERBOSE: Returning the data: test
test

# Expected: Pipeline returns array with correct values
PS> 'test1', 'test2' | Get-Something
test1
test2

# Expected: WhatIf shows operation but returns nothing
PS> Get-Something -Data 'test' -WhatIf
What if: Performing the operation "Get-Something" on target "test".

# Expected: No output means no static analysis issues found
PS> Invoke-ScriptAnalyzer -Path source/Public/Get-Something.ps1
(no output = success)
```

### Documentation Server
```bash
# Expected: Server starts and responds
npm run docs:dev
# Should show: "Local: http://localhost:5173/"
# curl http://localhost:5173 should return HTML
```

### Build Results
```powershell
# Expected: Build completes with module in output/
./build.ps1 -Tasks build
# Should show: "Build succeeded" and create output/module/ directory

# Expected: Tests pass with coverage report
./build.ps1 -Tasks test
# Should show: "Tests Passed: X, Failed: 0" and coverage percentage
```

## Known Issues and Workarounds

1. **Documentation Build Failure**: `npm run docs:build` fails due to a dead link in `CONTRIBUTING.md` (repository root). The dead link is to `[Sampler Framework Documentation](https://github.com/nightroman/Sampler/blob/master/docs/index.md)`, which no longer exists or is unreachable.
   - **How to identify**: Open `CONTRIBUTING.md` (in the repository root) and search for links. The dead link is the one pointing to the Sampler documentation above. You can verify by clicking the link or running a link checker.
   - **How to fix**: Update the link in `CONTRIBUTING.md` to a working URL, remove it, or replace it with an archived version if available.

2. **Network Dependency**: Full builds require PowerShell Gallery access
   - **Workaround**: Use manual module import for offline development

3. **Module Import in Tests**: Unit tests expect built module
   - **Workaround**: Use manual function testing with dot-sourcing

## CI/CD Integration

- **PSScriptAnalyzer**: Automated code analysis workflow
- **Coverage**: Target 85% code coverage (build.yaml)
- **Changelog**: Must be updated for all PRs
- **Workflow Files**: Located in `.github/workflows/` (PowerShell analysis only)

## Development Environment

- **PowerShell**: 5.1+ required (PowerShell 7+ recommended)
- **Node.js**: Required for documentation (see package.json)
- **Dev Container**: Available with Node.js 18 image
- **VSCode**: Configured with recommended extensions in `.vscode/`

Always test your changes with both manual validation and automated tests before committing.
