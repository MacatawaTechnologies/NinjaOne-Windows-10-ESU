# Checks which Windows 10 Extended Security Update (ESU) license is active on the device.
# The script lists the active ESU product IDs, maps them to the highest paid year, and reports the result.

# Set Ninja Variable Names
$ninjaEsuCustomField = "windows10EsuSupport"

# Determine the method to retrieve the operating system information based on PowerShell version.
try {
  $OS = if ($PSVersionTable.PSVersion.Major -lt 3) {
    Get-WmiObject -Class Win32_OperatingSystem -ErrorAction Stop
  }
  else {
    Get-CimInstance -ClassName Win32_OperatingSystem -ErrorAction Stop
  }
}
catch {
  # If the above retrieval fails, display an error message and exit.
  Write-Host -Object "[Error] Unable to retrieve information about the current operating system."
  Write-Host -Object "[Error] $($_.Exception.Message)"
  exit 1
}

# Check if the system is running Windows 10. If not, display an error message and exit.
if ($OS.Caption -notmatch "Windows 10") {
  Write-Host -Object "[Error] This device is not currently running Windows 10. It is currently running '$($OS.Caption)'."
  exit 1
}

$esuIds = @(
  Get-CimInstance -ClassName SoftwareLicensingProduct -Property ID, LicenseStatus -Filter "ID='f520e45e-7413-4a34-a497-d2765967d094' OR ID='1043add5-23b1-4afb-9a0f-64343c8f3f8d' OR ID='83d49986-add3-41d7-ba33-87c7bfb5c0fb'" |
  Where-Object { $_.LicenseStatus -eq 1 } |
  Select-Object -ExpandProperty ID
)

# Map known ESU product IDs to their corresponding coverage year. Later years imply earlier years are also licensed.
# Use `Ninja-Property-Options $ninjaEsuCustomField to determine what your drop down options are.
$esuCustomValue = [ordered]@{
  "83d49986-add3-41d7-ba33-87c7bfb5c0fb" = "<Your Year 3 GUID>" # Year 3 (2027-2028)
  "1043add5-23b1-4afb-9a0f-64343c8f3f8d" = "<Your Year 2 GUID>" # Year 2 (2026-2027)
  "f520e45e-7413-4a34-a497-d2765967d094" = "<Your Year 1 GUID>" # Year 1 (2025-2026)
}

$esuSupportVersion = $null
$esuActivationId = $null

foreach ($licenseId in $esuCustomValue.Keys) {
  if ($esuIds -contains $licenseId) {
    $esuSupportVersion = $esuCustomValue[$licenseId]
    $esuActivationId = $licenseId
    break
  }
}

if ($null -ne $esuSupportVersion) {
  Write-Host "ESU Support licensed with activation ID $esuActivationId."
  Ninja-Property-Set $ninjaEsuCustomField $esuSupportVersion
}
else {
  Write-Host "No ESU license detected."
}
