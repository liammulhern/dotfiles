##################
# VSCode install
##################

# Get the current directory
$currentDirectory = Get-Location
$userHome = $env:USERPROFILE

# Define the symlink file paths
$terminalSource = Join-Path $currentDirectory "settings.json"

# Create symbolic links
try {
    # Symlink for terminal settings
    $terminalTarget = Join-Path $userHome "AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    New-Item -ItemType SymbolicLink -Path $terminalTarget -Target $terminalSource -Force
    Write-Host "Created symlink for terminal settings at $terminalTarget" -ForegroundColor Green
} catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
}
