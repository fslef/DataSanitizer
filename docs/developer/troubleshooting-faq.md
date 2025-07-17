# Troubleshooting & FAQ

## Troubleshooting
- Check the [GitHub Issues](https://github.com/fslef/DataSanitizer/issues) for known problems and solutions.
- Review CI logs for failed builds or tests (see GitHub Actions tab).
- Use `npm ls` and `npm outdated` to diagnose dependency issues.
- For PowerShell errors, run scripts with `-Verbose` and `-Debug` flags for more output.
- For documentation build issues, run `npm run docs:dev` and check the terminal and browser console for errors.
- If using a dev container, ensure it is up to date (`Dev Containers: Rebuild Container`).

## FAQ
**Q: My Mermaid diagrams are not rendering?**
A: Ensure you use the correct code block syntax (\`\`\`mermaid), restart the VitePress dev server after config changes, and check for plugin errors in the browser console.

**Q: Tests are not running or failing unexpectedly?**
A: Run `./build.ps1 -Tasks test -Verbose` for detailed output. Check for missing dependencies or environment issues.

**Q: How do I update dependencies?**
A: Use `npm update` for JS packages and update PowerShell modules in `RequiredModules.psd1` as needed.

**Q: How do I preview documentation?**
A: Run `npm run docs:dev` and open the local server URL in your browser.

**Q: Who do I contact for help?**
A: Open an issue or discussion on GitHub with detailed steps to reproduce your problem.
