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
