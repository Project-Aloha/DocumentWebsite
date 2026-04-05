# Download and install drivers

:::tip
  Considering to SecureBoot and StableRelease, some devices' DriverPacks(e.g. XiaomiPad5, Xiaomi9) are released by their
  maintainer, Please read their official installation guide.
  Here explains a generic way to install drivers from GIT repository.
:::


## Preparation
- Download Device Specific Driver Pack
> Just click on archive with name like drivers.
  <img src="/InstallationGuides/Resources/InstallDrivers/HowToDownload2.png" width=40%/>
  
| Vendor | Device     | CodeName | Drivers                                                                                     |
|--------|------------|----------|---------------------------------------------------------------------------------------------|
| XiaoMi |Mi 9        |cepheus   | [Driver Pack](https://github.com/qaz6750/XiaoMi9-Drivers/releases)                          |
| XiaoMi |K20 Pro     |raphael   | [Driver Pack](https://github.com/rexnox/windows_xiaomi_platforms/releases)                  |
| XiaoMi |Pad 5       |nabu      | [Driver Pack](https://github.com/remtrik-stuff/MiPad5-Windows-Releases/releases/latest)     |
| XiaoMi |POCO X3 PRO |vayu      | [Driver Pack](https://github.com/WaLoVayu/POCOX3Pro-Windows-Releases/releases/latest)       |
| XiaoMi |Note 9S     |miatoll   | [Driver Pack](https://github.com/woa-miatoll/Miatoll-Releases/releases/latest)              |
| LG     |G8          |alphaplus | [Driver Pack](https://github.com/n00b69/woa-alphaplus/releases/tag/Drivers)                 |
| LG     |G8s         |betalm    | [Driver Pack](https://github.com/n00b69/woa-betalm/releases/tag/Drivers)                    |
| LG     |G8x         |mh2lm     | [Driver Pack](https://github.com/n00b69/woa-mh2lm/releases/tag/Drivers)                     |
| LG     |V50         |flashlmdd | [Driver Pack](https://github.com/n00b69/woa-flashlmdd/releases/tag/Drivers)                 |
| LG     |V50s        |mh2lm5g   | [Driver Pack](https://github.com/n00b69/woa-mh2lm5g/releases/tag/Drivers)                   |
| OnePlus|7 Pro 4G    |guacamole | [Driver Pack](https://github.com/n00b69/woa-op7/releases/tag/Drivers)                       |
| OnePlus|7T Pro 4G   |hotdog    | [Driver Pack](https://github.com/n00b69/woa-op7/releases/tag/Drivers)                       |
| Samsung|Galaxy Fold |winner    | [Driver Pack](https://github.com/n00b69/woa-winner/releases/tag/Drivers)                    |
--------------------------------------------------------------------------------------------------------------------------------



## Installation
### 1. Download and Extract the Package

- Download the provided archive and extract its contents into any convenient folder on your PC whose path does not contain Cyrillic characters.
- Make sure the folder structure remains intact after extraction.

### 2. Run offlineupdater.cmd (Administrator Required)

- Open the extracted folder and locate the script:
```
offlineupdater.cmd
```
- Right‑click it and choose:
```
Run as administrator
```
> If an error shows up, run OfflineUpdaterFix.cmd instead

> If it asks you to enter a letter, enter the drive letter of WIN(DEVICE-NAME) (which should be F), then press enter

### 3. Wait for the Process to Complete
#### When everything is finished, you will see a confirmation message indicating that all drivers were successfully installed.

## Done!

Your device now has all required drivers installed and ready for use.

