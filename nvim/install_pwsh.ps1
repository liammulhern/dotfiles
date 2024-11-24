##################
# NVIM install
##################

# Get the current directory
$currentDirectory = Get-Location
$userHome = $env:USERPROFILE

# Define file paths in the current directory
$nvimSource = $currentDirectory

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

# Check and install Neovim
Install-WithWinget -CommandName "nvim" -WingetId "Neovim.Neovim"

# Define the path to add nvim
$newPath = "C:\Program Files\nvim\bin"

# Get the current system PATH
$currentPath = [Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)

# Check if the new path is already in the PATH
if ($currentPath -notlike "*$newPath*") {
    Write-Host "'$newPath' is not in the system PATH. Adding it now..." -ForegroundColor Yellow
    try {
        # Add the new path
        $updatedPath = "$currentPath;$newPath"
        [Environment]::SetEnvironmentVariable("Path", $updatedPath, [System.EnvironmentVariableTarget]::Machine)
        Write-Host "'$newPath' has been successfully added to the system PATH." -ForegroundColor Green
    } catch {
        Write-Host "An error occurred while adding '$newPath' to the system PATH: $_" -ForegroundColor Red
    }
} else {
    Write-Host "'$newPath' is already in the system PATH." -ForegroundColor Green
}

# Create symbolic links
try {
    # Symlink for nvim
    $nvimTarget = Join-Path $userHome "AppData\Local\nvim"
    New-Item -ItemType SymbolicLink -Path $nvimTarget -Target $nvimSource -Force
    Write-Host "Created symlink for nvim at $nvimTarget" -ForegroundColor Green
} catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
}
