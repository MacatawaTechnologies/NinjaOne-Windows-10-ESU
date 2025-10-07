$esuID = Get-CimInstance -ClassName SoftwareLicensingProduct -Property ID,LicenseStatus -Filter "ID='f520e45e-7413-4a34-a497-d2765967d094' OR ID='1043add5-23b1-4afb-9a0f-64343c8f3f8d' OR ID='83d49986-add3-41d7-ba33-87c7bfb5c0fb'" |
  Where-Object { $_.LicenseStatus -eq 1 } |
  Select-Object ID

# Return the year that the ID is licensing. Each year needs the previous years.
$esuActivationYear = @{
  "f520e45e-7413-4a34-a497-d2765967d094" = "Year 1 (2025-2026)"
  "1043add5-23b1-4afb-9a0f-64343c8f3f8d" = "Year 2 (2026-2027)"
  "83d49986-add3-41d7-ba33-87c7bfb5c0fb" = "Year 3 (2027-2028)"
}
