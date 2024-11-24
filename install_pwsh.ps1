# Ensure the script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "This script must be run as Administrator. Exiting..." -ForegroundColor Red
    return
}

# Get the current directory
$currentDirectory = Get-Location
$currentScript = $MyInvocation.MyCommand.Path

# Find all "install_pwsh.ps1" scripts in direct subdirectories
$scripts = Get-ChildItem -Path $currentDirectory -Filter "install_pwsh.ps1" -Recurse |
    Where-Object {
        $_.DirectoryName -ne $currentDirectory.FullName -and
        $_.DirectoryName.StartsWith($currentDirectory.FullName) -and
        $_.FullName -ne $currentScript
    }

# Check if any scripts were found
if ($scripts.Count -eq 0) {
    Write-Host "No 'install_pwsh.ps1' scripts found in direct subdirectories." -ForegroundColor Yellow
} else {
    Write-Host "Found the following 'install_pwsh.ps1' scripts:" -ForegroundColor Green
    $scripts | ForEach-Object { Write-Host $_.FullName }

    # Invoke each script
    foreach ($script in $scripts) {
        Write-Host "Invoking script: $($script.FullName)" -ForegroundColor Cyan
        try {
            & $script.FullName
            Write-Host "Successfully invoked: $($script.FullName)" -ForegroundColor Green
        } catch {
            Write-Host "Failed to invoke: $($script.FullName). Error: $_" -ForegroundColor Red
        }
    }
}
