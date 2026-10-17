#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Silently removes any existing Click-to-Run Office and installs Office 2019
    Pro Plus (volume licensed, 64-bit) from a network share.

.DESCRIPTION
    An all-in-one deployment wrapper around the Office Deployment Tool (ODT):
      1. Validates the source share and setup.exe
      2. Generates uninstall/install XML configs in a temp working folder
      3. Removes any existing Click-to-Run Office installation
      4. Installs Office 2019 Pro Plus from the share
      5. Verifies the install via the ClickToRun registry key
      6. Cleans up on success; leaves configs behind on failure for troubleshooting

    All steps are logged to C:\Logs\OfficeDeploy.

.NOTES
    Requires: Administrator rights and read access to the software share.
    setup.exe (the ODT) and the Office source files must already be on the share.
    Exit code: 0 on success, otherwise the ODT install exit code.
#>

$SourceRoot = "\\fileserver\Software\Office2019"   # where setup.exe and the Office source files live
$SetupExe   = Join-Path $SourceRoot "setup.exe"

$LogFolder = "C:\Logs\OfficeDeploy"
$LogFile   = Join-Path $LogFolder ("Office2019-Install-{0}.log" -f (Get-Date -Format "yyyyMMdd-HHmmss"))

$WorkDir   = Join-Path $env:TEMP ("OfficeDeploy_{0}" -f (Get-Date -Format "yyyyMMdd-HHmmss"))

$InstallXml = @"
<Configuration>
  <Add SourcePath="$SourceRoot" OfficeClientEdition="64" Channel="PerpetualVL2019">
    <Product ID="ProPlus2019Volume">
      <Language ID="en-us" />
    </Product>
  </Add>
  <Updates Enabled="FALSE" />
  <Display Level="None" AcceptEULA="TRUE" />
  <Logging Level="Standard" Path="%temp%\OfficeInstallLogs" />
</Configuration>
"@

$UninstallXml = @"
<Configuration>
  <Remove All="TRUE" />
  <Display Level="None" AcceptEULA="TRUE" />
</Configuration>
"@


# Logging

function Write-Log {
    param([string]$Message)
    $line = "{0}  {1}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $Message
    Write-Host $line
    Add-Content -Path $LogFile -Value $line
}


# Prep

if (-not (Test-Path $LogFolder)) {
    New-Item -Path $LogFolder -ItemType Directory -Force | Out-Null
}

Write-Log "Starting Office 2019 deployment (all-in-one script)."

if (-not (Test-Path $SourceRoot)) {
    Write-Log "ERROR: Share not reachable: $SourceRoot"
    throw "Cannot continue - share not reachable: $SourceRoot"
}
if (-not (Test-Path $SetupExe)) {
    Write-Log "ERROR: setup.exe not found at: $SetupExe"
    throw "Cannot continue - missing ODT executable: $SetupExe"
}

New-Item -Path $WorkDir -ItemType Directory -Force | Out-Null
$UninstallConfigPath = Join-Path $WorkDir "uninstall-office.xml"
$InstallConfigPath   = Join-Path $WorkDir "install-office2019.xml"

Set-Content -Path $UninstallConfigPath -Value $UninstallXml -Encoding UTF8
Set-Content -Path $InstallConfigPath   -Value $InstallXml   -Encoding UTF8
Write-Log "Wrote temp ODT configs to $WorkDir"


# Step 1: remove any existing Click-to-Run Office

Write-Log "Removing any existing Click-to-Run Office installation..."
$uninstallProc = Start-Process -FilePath $SetupExe `
    -ArgumentList "/configure `"$UninstallConfigPath`"" `
    -Wait -PassThru -WindowStyle Hidden

Write-Log "Uninstall step exit code: $($uninstallProc.ExitCode)"
if ($uninstallProc.ExitCode -ne 0) {
    Write-Log "WARNING: uninstall step returned non-zero - continuing to install anyway."
}


# Step 2: install Office 2019

Write-Log "Installing Office 2019 from $SourceRoot ..."
$installProc = Start-Process -FilePath $SetupExe `
    -ArgumentList "/configure `"$InstallConfigPath`"" `
    -Wait -PassThru -WindowStyle Hidden

Write-Log "Install step exit code: $($installProc.ExitCode)"


# Step 3: verify

$configKey = "HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration"
if (Test-Path $configKey) {
    $installed = Get-ItemProperty -Path $configKey -ErrorAction SilentlyContinue
    Write-Log ("Verification: found ClickToRun config - Product: {0}, Version: {1}" -f $installed.ProductReleaseIds, $installed.VersionToReport)
}
else {
    Write-Log "WARNING: ClickToRun configuration registry key not found - install may not have completed successfully."
}


# Step 4: cleanup

if ($installProc.ExitCode -eq 0) {
    Remove-Item -Path $WorkDir -Recurse -Force -ErrorAction SilentlyContinue
    Write-Log "Office 2019 deployment completed successfully. Temp configs cleaned up."
    exit 0
}
else {
    Write-Log "Office 2019 deployment FAILED. Temp configs left at $WorkDir for troubleshooting. See $LogFile and %temp%\OfficeInstallLogs."
    exit $installProc.ExitCode
}
