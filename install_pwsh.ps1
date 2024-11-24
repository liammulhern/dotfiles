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
