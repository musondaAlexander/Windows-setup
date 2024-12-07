Here's the full script with all the commands and instructions formatted so you can copy it directly into your README file:

````markdown
# Windows 11 Setup Automation Script

This script automates the setup of a **Windows 11** machine. It installs applications, restores system settings, and applies the taskbar layout.

---

## **Note:**

To successfully run this script, you must update the following files with your current system's settings. Otherwise, the new machine will be set up with the default settings.

---

## **Files to Update:**

1. **app-list.csv**: List of applications to install.
2. **dependencies/taskbar.xml**: Taskbar layout configuration.
3. **dependencies/registry.zip**: Compressed registry settings.
4. **dependencies/installed-programs.zip**: Compressed installed programs registry.
5. **dependencies/system-settings.zip**: Compressed system registry settings.

---

## **Generating Required Files**

To make the script work on your new machine, you need to generate the following files on your current system.

---

### **1. Generate `app-list.csv`**

This file lists the applications installed on your current machine. Use the following PowerShell command:

```powershell
$programPaths = @(
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
)

$installedApps = foreach ($path in $programPaths) {
    Get-ItemProperty $path | Where-Object { $_.DisplayName } | Select-Object `
    @{Name = "Name"; Expression = { $_.DisplayName }},
    @{Name = "Version"; Expression = { $_.DisplayVersion }},
    @{Name = "Vendor"; Expression = { $_.Publisher }},
    @{Name = "InstallDate"; Expression = { $_.InstallDate }}
}
$installedApps | Export-Csv -Path "$env:USERPROFILE\Desktop\app-list.csv" -NoTypeInformation
```
````

---

### **2. Generate `taskbar.xml`**

To export your current taskbar layout, run:

```powershell
Export-StartLayout -Path "$env:USERPROFILE\Desktop\taskbar.xml"
```

---

### **3. Export `registry.zip`**

To export and compress your registry settings, run:

```powershell
reg export HKCU\Software "$env:USERPROFILE\Desktop\registry.reg"
Compress-Archive -Path "$env:USERPROFILE\Desktop\registry.reg" -DestinationPath "$env:USERPROFILE\Desktop\registry.zip"
```

---

### **4. Export `installed-programs.zip`**

To export and compress the registry for installed programs, run:

```powershell
reg export "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" "$env:USERPROFILE\Desktop\installed-programs.reg"
Compress-Archive -Path "$env:USERPROFILE\Desktop\installed-programs.reg" -DestinationPath "$env:USERPROFILE\Desktop\installed-programs.zip"
```

---

### **5. Export `system-settings.zip`**

To export and compress your system registry settings, run:

```powershell
reg export HKLM\System "$env:USERPROFILE\Desktop\system-settings.reg"
Compress-Archive -Path "$env:USERPROFILE\Desktop\system-settings.reg" -DestinationPath "$env:USERPROFILE\Desktop\system-settings.zip"
```

---

## **Running the Script**

1. Clone this repository to the new machine:

   ```bash
   git clone <repository-url>
   cd <repository-name>
   ```

2. Extract the compressed files into the `dependencies/` folder:

   - `registry.zip` → `dependencies/registry.reg`
   - `installed-programs.zip` → `dependencies/installed-programs.reg`
   - `system-settings.zip` → `dependencies/system-settings.reg`

3. Run the setup script as Administrator:

   ```powershell
   .\setup.ps1
   ```

---

## **What the Script Does**

The script performs the following steps:

### **1. Install Applications from `app-list.csv`**

```powershell
$appsListPath = "dependencies\app-list.csv"
if (Test-Path $appsListPath) {
    $apps = Import-Csv -Path $appsListPath
    foreach ($app in $apps) {
        Write-Host "Installing $($app.Name)..."
        winget install --id $app.ID --source winget -e --silent
    }
} else {
    Write-Host "app-list.csv not found."
}
```

---

### **2. Restore Registry Settings from `registry.zip`**

```powershell
$registryPath = "dependencies\registry.reg"
if (Test-Path $registryPath) {
    Write-Host "Restoring registry settings from registry.reg..."
    reg import $registryPath
} else {
    Write-Host "registry.reg not found."
}
```

---

### **3. Restore Installed Programs Registry Settings from `installed-programs.zip`**

```powershell
$installedProgramsRegPath = "dependencies\installed-programs.reg"
if (Test-Path $installedProgramsRegPath) {
    Write-Host "Restoring installed programs registry settings from installed-programs.reg..."
    reg import $installedProgramsRegPath
} else {
    Write-Host "installed-programs.reg not found."
}
```

---

### **4. Restore System Settings Registry from `system-settings.zip`**

```powershell
$systemSettingsRegPath = "dependencies\system-settings.reg"
if (Test-Path $systemSettingsRegPath) {
    Write-Host "Restoring system settings registry from system-settings.reg..."
    reg import $systemSettingsRegPath
} else {
    Write-Host "system-settings.reg not found."
}
```

---

### **5. Apply Taskbar Layout from `taskbar.xml`**

```powershell
$taskbarPath = "dependencies\taskbar.xml"
if (Test-Path $taskbarPath) {
    Write-Host "Applying taskbar layout from taskbar.xml..."
    Start-Process "powershell.exe" -ArgumentList "Export-StartLayout -Path $taskbarPath" -NoNewWindow -Wait
} else {
    Write-Host "taskbar.xml not found."
}
```

---

## **Notes:**

- Registry files (`.reg`) are compressed to ZIP format for better management.
- Drivers are not included in this setup as they can be installed via **Windows Update**.

---

## **License**

This script is open-source and available under the MIT License.

```

```
