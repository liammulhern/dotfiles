##################
# VSCode install
##################

# Get the current directory
$currentLocation = Get-Location
$currentDirectory = Join-Path $currentLocation "vscode"
$userHome = $env:USERPROFILE

# Define the symlink file paths
$vsvimSource = Join-Path $currentDirectory ".vscodevimrc"
$vsSettingsSource = Join-Path $currentDirectory "settings.json"
$vsKeybindingsSource = Join-Path $currentDirectory "keybindings.json"

# Define file paths in the current directory
$extensionsFile = Join-Path $currentDirectory ".vscode_ext.txt"

# Function to install VS Code using winget
function Install-VSCode {
    Write-Host "Visual Studio Code is not installed. Installing it now using winget..." -ForegroundColor Yellow
    try {
        winget install --id Microsoft.VisualStudioCode --source winget --silent --accept-package-agreements --accept-source-agreements
        Write-Host "Visual Studio Code has been successfully installed." -ForegroundColor Green
    } catch {
        Write-Host "An error occurred while installing Visual Studio Code: $_" -ForegroundColor Red
    }
}

# Check if VS Code is installed
if (-not (Get-Command "code" -ErrorAction SilentlyContinue)) {
    Install-VSCode
}

# Recheck if VS Code is installed after installation attempt
if (Get-Command "code" -ErrorAction SilentlyContinue) {
    Write-Host "Visual Studio Code is installed." -ForegroundColor Green

    # Check if the extensions file exists
    if (Test-Path $extensionsFile) {
        Write-Host "Found extensions file: $extensionsFile" -ForegroundColor Green

        # Read the extensions from the file
        $extensions = Get-Content $extensionsFile | Where-Object { $_ -notmatch "^\s*$" -and $_ -notmatch "^\s*#" }

        # Install each extension
        foreach ($extension in $extensions) {
            Write-Host "Installing extension: $extension..." -ForegroundColor Yellow
            try {
                code --install-extension $extension --force
                Write-Host "Successfully installed: $extension" -ForegroundColor Green
            } catch {
                Write-Host "Failed to install: $extension" -ForegroundColor Red
            }
        }
    } else {
        Write-Host "Extensions file '.vscode_ext.txt' not found in the current directory." -ForegroundColor Red
    }
} else {
    Write-Host "Visual Studio Code could not be installed. Please check your setup and try again." -ForegroundColor Red
}

# Create symbolic links
try {
    # Symlink for vsvimrc
    $vsvimTarget = Join-Path $userHome ".vscodevimrc"
    New-Item -ItemType SymbolicLink -Path $vsvimTarget -Target $vsvimSource -Force
    Write-Host "Created symlink for vscodevimrc at $vsvimTarget" -ForegroundColor Green

    # Symlink for vscode settings
    $vsSettingsTarget = Join-Path $userHome "AppData\Roaming\Code\User"
    New-Item -ItemType SymbolicLink -Path $vsSettingsTarget -Target $vsSettingsSource -Force
    Write-Host "Created symlink for vscode settings at $vsSettingsTarget" -ForegroundColor Green
    #
    # Symlink for vscode keybinds
    $vsKeybindsTarget = Join-Path $userHome "AppData\Roaming\Code\User"
    New-Item -ItemType SymbolicLink -Path $vsKeybindsTarget -Target $vsKeybindsSource -Force
    Write-Host "Created symlink for vscode keybinds at $vsKeybindsTarget" -ForegroundColor Green
} catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
}
