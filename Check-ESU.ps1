# Checks which Windows 10 Extended Security Update (ESU) license is active on the device.
# The script lists the active ESU product IDs, maps them to the highest paid year, and reports the result.
# Designed to populate the NinjaOne custom field `windows10EsuSupport`.

$esuIds = @(
  Get-CimInstance -ClassName SoftwareLicensingProduct -Property ID,LicenseStatus -Filter "ID='f520e45e-7413-4a34-a497-d2765967d094' OR ID='1043add5-23b1-4afb-9a0f-64343c8f3f8d' OR ID='83d49986-add3-41d7-ba33-87c7bfb5c0fb'" |
    Where-Object { $_.LicenseStatus -eq 1 } |
    Select-Object -ExpandProperty ID
)

# Map known ESU product IDs to their corresponding coverage year. Later years imply earlier years are also licensed.
$esuActivationYear = [ordered]@{
  "83d49986-add3-41d7-ba33-87c7bfb5c0fb" = "Year 3 (2027-2028)"
  "1043add5-23b1-4afb-9a0f-64343c8f3f8d" = "Year 2 (2026-2027)"
  "f520e45e-7413-4a34-a497-d2765967d094" = "Year 1 (2025-2026)"
}

$esuSupportVersion = $null

foreach ($licenseId in $esuActivationYear.Keys) {
  if ($esuIds -contains $licenseId) {
    $esuSupportVersion = $esuActivationYear[$licenseId]
    break
  }
}

if ($null -ne $esuSupportVersion) {
  Write-Host "ESU Support licensed through $esuSupportVersion."
  Ninja-Property-Set windows10EsuSupport $esuSupportVersion
} else {
  Write-Host "No ESU license detected."
}
