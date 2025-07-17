# Setting Up the Development Environment

## Prerequisites
- Node.js (LTS recommended)
- PowerShell (7+ recommended)
- Git
- Windows, macOS, or Linux (dev container supported)

## Getting Started

1. Clone the repository:
   ```sh
   git clone https://github.com/fslef/DataSanitizer.git
   cd DataSanitizer
   ```
2. Install dependencies:
   ```sh
   npm install
   ```
3. (Optional) Open in a dev container for a pre-configured environment.

## Running the Documentation Site
```sh
npm run docs:dev
```

## Running Tests
```sh
# PowerShell
./build.ps1 -Tasks test
```

## Useful Scripts
- `npm run docs:build` – Build the documentation for production
- `npm run docs:preview` – Preview the built documentation
