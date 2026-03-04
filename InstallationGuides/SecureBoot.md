## Disable SecureBoot Guide

:::warning
This process can permanently brick your device if done incorrectly.
Read every step carefully and DO NOT modify partitions unless explicitly instructed.
:::

:::warning
DO NOT ERASE, CREATE OR MODIFY ANY PARTITION IN DISKPART.
ONLY ASSIGN A DRIVE LETTER TO ESP(DEVICE-NAME).
:::


## Start diskpart in CMD:

```
diskpart
```
- Find ESP(DEVICE-NAME) partition:
```
list volume
```
- Replace $ with the actual volume number of ESP(DEVICE-NAME):
```
select volume $
assign letter Y
```
- Exit diskpart:
```
exit
```

## Enable Test Signing
```
bcdedit /store Y:\EFI\Microsoft\BOOT\BCD /set "{default}" testsigning on
```

## Disabling recovery
```
bcdedit /store Y:\EFI\Microsoft\BOOT\BCD /set "{default}" recoveryenabled no
```

## Disabling integrity checks
```
bcdedit /store Y:\EFI\Microsoft\BOOT\BCD /set "{default}" nointegritychecks on
```

## Remove SiPolicy (Critical)

> If SecureBoot is being disabled on an already installed system, delete:
```
del Y:\EFI\Microsoft\Boot\SiPolicy.p7b
```
Failure to delete this file will result in boot failure.

- Remove ESP Drive Letter
```
mountvol Y: /d
```
> If this fails, ignore it. The phantom drive will disappear after reboot.

## Flash NoSecureBoot UEFI

- Reboot to bootloader:
```
adb reboot bootloader
```
- Replace path\to\NoSecureboot.img with your actual image path:
```
fastboot flash boot path\to\NoSecureboot.img
```
- Reboot
```
fastboot reboot
```

# SecureBoot is now disabled.
