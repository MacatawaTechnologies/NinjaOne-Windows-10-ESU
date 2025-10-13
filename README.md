# Windows 10 Extended Support Update Scripts for NinjaOne

PowerShell scripts to **install Windows 10 Extended Security Updates (ESU)** and **report update status** directly to a **NinjaOne RMM custom field**.  
Perfect for **managed service providers (MSPs)** and **IT administrators** automating Windows 10 post–end-of-support management.

---

## ✨ Features

- ✅ **Scripted installation** of Windows 10 Extended Security Updates (ESUs)  
- 🖥️ **Seamless integration** with NinjaOne RMM  
- 📊 **Custom field reporting** for ESU installation status  
- 🧰 **Compatible** with Windows 10 Pro and Enterprise editions  

---

## ⚙️ Requirements

- **Windows 10** (version 22H2)  
- **NinjaOne RMM agent** installed and online  
- Valid **Microsoft ESU license** or MAK key  

---

## 🧩 Usage Instructions

1. Create a dropdown [device custom field](https://ninjarmm.zendesk.com/hc/en-us/articles/360060920631).
  - Fieldname `windows10EsuSupport`.
  - Permissions
    - Automation: Read/Write
    - Technician: Read Only
  - Option Value
    - Year 1 (2025-2026)
    - Year 2 (2026-2027)
    - Year 3 (2027-2028)
2. Use the NinjaOne CLI to determine what values define each drop-down option.
  1. Launch a PowerShell session on a managed computer.
  2. Set execution policy.
     ```PowerShell
     Set-ExecutionPolicy -Scope Process Unrestricted
     ```
   3. Import the NinjaOne CLI PowerShell Module
      ```PowerShell
      Import-Module njclipsh
      ```
   4. Get the property options
      ```PowerShell
      NinjaProperty-Options windows10EsuSupport
      ```
3. Create the Check script in your NinjaOne Automation Library, be sure to use your drop down GUIDs.
2. Create the Activation script in your NinjaOne Automation Library.
   - Create the ESU Year drop-down script variable.
     - Year 1 (2025-2026)
     - Year 2 (2026-2027)
     - Year 3 (2027-2028)
   - Create the ESU Activation Key string/text script variable.
3. **Deploy** the check script to target endpoints or policies at an interval.
4. **View results** in your designated NinjaOne **custom field**.
