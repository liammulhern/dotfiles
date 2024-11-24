##################
# Powershell install
##################

# Get the current directory
$currentDirectory = Get-Location
$userHome = $env:USERPROFILE

# Define file paths in the current directory
$profileSource = Join-Path $currentDirectory "Microsoft.PowerShell_profile.ps1"

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

# Check and install Oh My Posh
Install-WithWinget -CommandName "oh-my-posh" -WingetId "JanDeDobbeleer.OhMyPosh"

# Check and install git
Install-WithWinget -CommandName "git" -WingetId "Git.Git"

# Check and install zoxide
Install-WithWinget -CommandName "zoxide" -WingetId "ajeetdsouza.zoxide"

# Check and install fzf
Install-WithWinget -CommandName "fzf" -WingetId "fzf"

# Check and install powertoys
Install-WithWinget -CommandName "powertoys" -WingetId "Microsoft.PowerToys"

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

# Create symbolic links
try {
    # Symlink for PowerShell profile
    $profileTarget = $PROFILE
    New-Item -ItemType SymbolicLink -Path $profileTarget -Target $profileSource -Force
    Write-Host "Created symlink for PowerShell profile at $profileTarget" -ForegroundColor Green
} catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
}
