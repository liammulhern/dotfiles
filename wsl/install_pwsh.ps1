# Function to install WSL and Ubuntu
function Install-WSLWithUbuntu {
    Write-Host "Checking if WSL is installed..." -ForegroundColor Yellow
    try {
        # Check if WSL is installed
        $wslVersion = wsl --version 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "WSL is already installed." -ForegroundColor Green
        } else {
            Write-Host "WSL is not installed. Installing WSL..." -ForegroundColor Yellow
            # Enable the WSL feature
            wsl --install

            # Install the WSL kernel update
            wsl --update

            Write-Host "WSL has been installed." -ForegroundColor Green
        }

        # Check if Ubuntu is installed
        Write-Host "Checking if Ubuntu is installed in WSL..." -ForegroundColor Yellow
        $distroList = wsl --list --online
        if ($distroList -match "Ubuntu") {
            Write-Host "Ubuntu is available for installation." -ForegroundColor Green
        }

        # Install Ubuntu if not already installed
        $installedDistros = wsl --list --quiet
        if ($installedDistros -notmatch "Ubuntu") {
            Write-Host "Ubuntu is not installed. Installing Ubuntu..." -ForegroundColor Yellow
            winget install --id Canonical.Ubuntu --source winget --silent --accept-package-agreements --accept-source-agreements
            Write-Host "Ubuntu has been successfully installed." -ForegroundColor Green
        } else {
            Write-Host "Ubuntu is already installed." -ForegroundColor Green
        }
    } catch {
        Write-Host "An error occurred: $_" -ForegroundColor Red
    }
}

# Ensure the script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "This script must be run as Administrator. Exiting..." -ForegroundColor Red
    return
}

# Call the function to install WSL and Ubuntu
Install-WSLWithUbuntu

