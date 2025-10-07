# Replace with your actual ESU product key
$ESU_MAK = $env:esuActivationKey
$ESU_Year = $env:esuYear

# ESU Activation IDs
$ActivationIDs = @{
    "Year 1 (2025-2026)" = "f520e45e-7413-4a34-a497-d2765967d094"
    "Year 2 (2026-2027)" = "1043add5-23b1-4afb-9a0f-64343c8f3f8d"
    "Year 3 (2027-2028)" = "83d49986-add3-41d7-ba33-87c7bfb5c0fb"
}
$ActivationID = $ActivationIDs[$ESU_Year]

Write-Output "Installing client-specific ESU MAK key $ESU_MAK"
cscript.exe /b %windir%\system32\slmgr.vbs /ipk $ESU_MAK

Write-Output "Activating generic ESU MAK key for Year $ESU_Year ($ActivationID)..."
cscript.exe /b %windir%\system32\slmgr.vbs /ato $ActivationID
