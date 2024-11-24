##################
# Komorebi install
##################

# Get the current directory
$currentLocation = Get-Location
$currentDirectory = Join-Path $currentLocation "komorebi"
$userHome = $env:USERPROFILE

# Define file paths in the current directory
$komorebiJsonSource = Join-Path $currentDirectory "komorebi.json"
$komorebiBarJsonSource = Join-Path $currentDirectory "komorebi.bar.json"

# Function to check and install a package using winget
function Install-WithWinget {
    param (
        [string]$CommandName,
        [string]$WingetId
    )

    if (-not (Get-Command $CommandName -ErrorAction SilentlyContinue)) {
        Write-Host "'$CommandName' is not installed. Installing now using winget..." -ForegroundColor Yellow
        try {
            # Run winget to install the package
            winget install --id $WingetId --source winget --silent --accept-package-agreements --accept-source-agreements
            Write-Host "'$CommandName' has been successfully installed." -ForegroundColor Green
        } catch {
            Write-Host "An error occurred during the installation of '$CommandName': $_" -ForegroundColor Red
        }
    } else {
        Write-Host "'$CommandName' is already installed." -ForegroundColor Green
    }
}

# Check and install komorebi
Install-WithWinget -CommandName "komorebic" -WingetId "LGUG2Z.komorebi"

# Check and install whkd
Install-WithWinget -CommandName "whkd" -WingetId "LGUG2Z.whkd"

# Create symbolic links
try {
    # Symlink for komorebi.json
    $komorebiJsonTarget = Join-Path $userHome "komorebi.json"
    New-Item -ItemType SymbolicLink -Path $komorebiJsonTarget -Target $komorebiJsonSource -Force
    Write-Host "Created symlink for komorebi.json at $komorebiJsonTarget" -ForegroundColor Green

    # Symlink for komorebi.bar.json
    $komorebiBarJsonTarget = Join-Path $userHome "komorebi.bar.json"
    New-Item -ItemType SymbolicLink -Path $komorebiBarJsonTarget -Target $komorebiBarJsonSource -Force
    Write-Host "Created symlink for komorebi.bar.json at $komorebiBarJsonTarget" -ForegroundColor Green
} catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
}
