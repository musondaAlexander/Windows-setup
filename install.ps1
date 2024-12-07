# Run as Administrator

# Step 0: Define paths
$projectRoot = $PSScriptRoot
$dependenciesFolder = "$projectRoot\dependencies"
$appListPath = "$projectRoot\apps-list.csv"
$registryZipPath = "$dependenciesFolder\registry.zip"
$installedProgramsZipPath = "$dependenciesFolder\installed-programs.zip"
$systemSettingsZipPath = "$dependenciesFolder\system-settings.zip"
$taskbarPath = "$dependenciesFolder\taskbar.xml"

# Step 1: Install Applications from CSV (apps-list.csv)
if (Test-Path $appListPath) {
    Write-Host "Installing applications from apps-list.csv..."
    $apps = Import-Csv -Path $appListPath
    foreach ($app in $apps) {
        Write-Host "Installing $($app.Name)..."
        winget install --id $app.ID --source winget -e --silent
    }
} else {
    Write-Host "apps-list.csv not found in the project root."
}

# Step 2: Restore Registry Settings
if (Test-Path $registryZipPath) {
    Write-Host "Extracting registry.zip..."
    Expand-Archive -Path $registryZipPath -DestinationPath $dependenciesFolder -Force
    $registryPath = "$dependenciesFolder\registry.reg"
    if (Test-Path $registryPath) {
        Write-Host "Restoring registry settings from registry.reg..."
        reg import $registryPath
    } else {
        Write-Host "registry.reg not found after extraction."
    }
} else {
    Write-Host "registry.zip not found in dependencies folder."
}

# Step 3: Restore Installed Programs Registry Settings
if (Test-Path $installedProgramsZipPath) {
    Write-Host "Extracting installed-programs.zip..."
    Expand-Archive -Path $installedProgramsZipPath -DestinationPath $dependenciesFolder -Force
    $installedProgramsRegPath = "$dependenciesFolder\installed-programs.reg"
    if (Test-Path $installedProgramsRegPath) {
        Write-Host "Restoring installed programs registry settings from installed-programs.reg..."
        reg import $installedProgramsRegPath
    } else {
        Write-Host "installed-programs.reg not found after extraction."
    }
} else {
    Write-Host "installed-programs.zip not found in dependencies folder."
}

# Step 4: Restore System Settings Registry
if (Test-Path $systemSettingsZipPath) {
    Write-Host "Extracting system-settings.zip..."
    Expand-Archive -Path $systemSettingsZipPath -DestinationPath $dependenciesFolder -Force
    $systemSettingsRegPath = "$dependenciesFolder\system-settings.reg"
    if (Test-Path $systemSettingsRegPath) {
        Write-Host "Restoring system settings registry from system-settings.reg..."
        reg import $systemSettingsRegPath
    } else {
        Write-Host "system-settings.reg not found after extraction."
    }
} else {
    Write-Host "system-settings.zip not found in dependencies folder."
}

# Step 5: Apply Taskbar Layout from taskbar.xml
if (Test-Path $taskbarPath) {
    Write-Host "Applying taskbar layout from taskbar.xml..."
    Start-Process "powershell.exe" -ArgumentList "Import-StartLayout -LayoutPath $taskbarPath -MountPath C:\" -NoNewWindow -Wait
} else {
    Write-Host "taskbar.xml not found in dependencies folder."
}

Write-Host "Setup script completed!"
