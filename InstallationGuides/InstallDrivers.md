# Download and install drivers

:::tip
  Considering to SecureBoot and StableRelease, some devices' DriverPacks(e.g. XiaomiPad5, Xiaomi9) are released by their
  maintainer, Please read their official installation guide.
  Here explains a generic way to install drivers from GIT repository.
:::


## Preparation
- Download [DriverUpdater](https://github.com/WOA-Project/DriverUpdater/releases) by [WOA-Project](https://github.com/WOA-Project/)
  > Generally speaking please download the x64/x86 one, if **Your Computer** has more than one x86 CPU.

- Download Device Specific Driver Pack
  > Just click on archive with name like drivers.
  <img src="/InstallationGuides/Resources/InstallDrivers/HowToDownload2.png" width=40%/>
  
| Vendor | Device     | CodeName | Drivers                                                                                   |
|--------|------------|----------|-------------------------------------------------------------------------------------------|
| XiaoMi |Mi 9        |cepheus   | [Driver Pack](https://github.com/qaz6750/XiaoMi9-Drivers/releases)                        |
| XiaoMi |K20 Pro     |raphael   | [Driver Pack](https://github.com/new-WoA-Raphael/woa-raphael/releases/tag/Drivers)        |
| XiaoMi |Pad 5       |nabu      | [Driver Pack](https://github.com/erdilS/Port-Windows-11-Xiaomi-Pad-5/releases/tag/Drivers)|
| XiaoMi |POCO X3 PRO |vayu      | [Driver Pack](https://github.com/WaLoVayu/POCOX3Pro-Windows-Releases/releases/tag/2502.28)|
| XiaoMi |Note 9S     | miatoll  | [Driver Pack](https://github.com/woa-miatoll/Miatoll-Releases/releases/latest)            |
| LG     |G8          |alphaplus | [Driver Pack](https://github.com/n00b69/woa-alphaplus/releases/tag/Drivers)               |
| LG     |G8s         |betalm    | [Driver Pack](https://github.com/n00b69/woa-betalm/releases/tag/Drivers)                  |
| LG     |G8x         |mh2lm	 | [Driver Pack](https://github.com/n00b69/woa-mh2lm/releases/tag/Drivers)                   |
| LG     |V50         |flashlmdd | [Driver Pack](https://github.com/n00b69/woa-flashlmdd/releases/tag/Drivers)               |
| LG     |V50s        |mh2lm5g   | [Driver Pack](https://github.com/n00b69/woa-mh2lm5g/releases/tag/Drivers)                 |
| OnePlus|7 Pro 4G    |guacamole | [Driver Pack](https://github.com/n00b69/woa-op7/releases/tag/Drivers)                     |
| OnePlus|7T Pro 4G   |hotdog    | [Driver Pack](https://github.com/n00b69/woa-op7/releases/tag/Drivers)                     |
| Samsung|Galaxy Fold |winner    | [Driver Pack](https://github.com/n00b69/woa-winner/releases/tag/Drivers)                  |
------------------------------------------------------------------------------------------------------------------------------

  - For others, please refer to [Devices' Codename Reference Table](../ReferenceTables/DeviceCodenameReferenceTable.md)  
    and download the one named xxx.


## Installation
  1. Unzip the .zip files you just downloading into correct folders.
      - An example:
        + Extract Driver Pack into `D:\WOA\<silicon-codename>-Drivers\`
        + Extract DriverUpdater.exe to `D:\WOA\<silicon-codename>-Drivers\DriverUpdater.exe`
        + Extract Device Specific Driver Pack to `D:\WOA\<silicon-codename>-Drivers\components\QC8150\Device\<device-codename>\`

  2. Open a terminal with admin permission, then change directory to `<silicon-codename>-Drivers\`.
      - An example in `cmd`:
        + `cd /d D:\WOA\<silicon-codename>-Drivers\`
      - An example in `powershell`:
        + `cd 'D:\WOA\<silicon-codename>-Drivers\'`

  3. Install drivers with `DriverUpdater.exe`
      - For details about how to use, please execute `DriverUpdater.exe --help`.
      - An example (assume the Windows partition on your phone assigned to `F:` on your computer):
        + `.\DriverUpdater.exe -p F: -d definitions\Desktop\ARM64\Internal\<device-codename>.txt -r .`
  
  4. Waiting for completion.
      - A screenshot after installing driver successfully on QRD778.
      <img src="/InstallationGuides/Resources/InstallDrivers/DriverUpdateSuccessfully.png"/>
  
  5. Eject disk in explorer, then you have successfully installed all the drivers!!


