# Get the current directory
$currentDirectory = Get-Location

# Define file paths in the current directory
$profileSource = Join-Path $currentDirectory "Microsoft.PowerShell_profile.ps1"
$komorebiJsonSource = Join-Path $currentDirectory "komorebi.json"
$komorebiBarJsonSource = Join-Path $currentDirectory "komorebi.bar.json"

# Get target directories
$profileTarget = $PROFILE                                    # PowerShell profile path
$userHome = $env:USERPROFILE

# Create symbolic links
try {
    # Symlink for PowerShell profile
    if (-Not (Test-Path $profileTarget)) {
        New-Item -ItemType SymbolicLink -Path $profileTarget -Target $profileSource
        Write-Host "Created symlink for PowerShell profile at $profileTarget" -ForegroundColor Green
    } else {
        Write-Host "PowerShell profile symlink already exists." -ForegroundColor Yellow
    }

    # Symlink for komorebi.json
    $komorebiJsonTarget = Join-Path $userHome "komorebi.json"
    if (-Not (Test-Path $komorebiJsonTarget)) {
        New-Item -ItemType SymbolicLink -Path $komorebiJsonTarget -Target $komorebiJsonSource
        Write-Host "Created symlink for komorebi.json at $komorebiJsonTarget" -ForegroundColor Green
    } else {
        Write-Host "komorebi.json symlink already exists." -ForegroundColor Yellow
    }

    # Symlink for komorebi.bar.json
    $komorebiBarJsonTarget = Join-Path $userHome "komorebi.bar.json"
    if (-Not (Test-Path $komorebiBarJsonTarget)) {
        New-Item -ItemType SymbolicLink -Path $komorebiBarJsonTarget -Target $komorebiBarJsonSource
        Write-Host "Created symlink for komorebi.bar.json at $komorebiBarJsonTarget" -ForegroundColor Green
    } else {
        Write-Host "komorebi.bar.json symlink already exists." -ForegroundColor Yellow
    }
} catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
}

# Check if the 'posh-git' module is installed
if (-not (Get-Module -ListAvailable -Name posh-git)) {
    Write-Host "'posh-git' is not installed. Installing now..." -ForegroundColor Yellow
    try {
        # Ensure PowerShellGet is available
        if (-not (Get-Command -Name Install-Module -ErrorAction SilentlyContinue)) {
            Write-Host "PowerShellGet is not available. Please install it to proceed." -ForegroundColor Red
            return
        }

        # Install the 'posh-git' module
        PowerShellGet\Install-Module -Name posh-git -Scope CurrentUser -Force
        Write-Host "'posh-git' has been successfully installed." -ForegroundColor Green
    } catch {
        Write-Host "An error occurred during the installation of 'posh-git': $_" -ForegroundColor Red
    }
} else {
    Write-Host "'posh-git' is already installed." -ForegroundColor Green
}

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
            winget install --id $WingetId --silent --accept-package-agreements --accept-source-agreements
            Write-Host "'$CommandName' has been successfully installed." -ForegroundColor Green
        } catch {
            Write-Host "An error occurred during the installation of '$CommandName': $_" -ForegroundColor Red
        }
    } else {
        Write-Host "'$CommandName' is already installed." -ForegroundColor Green
    }
}

# Check and install zoxide
Install-WithWinget -CommandName "zoxide" -WingetId "ajeetdsouza.zoxide"

# Check and install fzf
Install-WithWinget -CommandName "fzf" -WingetId "fzf"

# Check and install komorebi
Install-WithWinget -CommandName "komorebic" -WingetId "LGUG2Z.komorebi"

# Check and install whkd
Install-WithWinget -CommandName "whkd" -WingetId "LGUG2Z.whkd"

