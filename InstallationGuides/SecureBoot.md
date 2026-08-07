## Disable SecureBoot Guide

:::warning
This process can permanently brick your device if done incorrectly.
Read every step carefully and DO NOT modify partitions unless explicitly instructed.
:::

:::danger
DO NOT ERASE, CREATE OR MODIFY ANY PARTITION IN DISKPART.
ONLY ASSIGN A DRIVE LETTER TO ESP(DEVICE-NAME).
:::

## Start diskpart in CMD:

```bash
diskpart
```
- Find ESP(DEVICE-NAME) partition:
```bash
list volume
```
- Replace $ with the actual volume number of ESP(DEVICE-NAME):
```bash
select volume $
assign letter Y
```
- Exit diskpart:
```bash
exit
```

## Enable Test Signing
```bash
bcdedit /store Y:\EFI\Microsoft\BOOT\BCD /set "{default}" testsigning on
```

## Disabling recovery
```bash
bcdedit /store Y:\EFI\Microsoft\BOOT\BCD /set "{default}" recoveryenabled no
```

## Disabling integrity checks
```bash
bcdedit /store Y:\EFI\Microsoft\BOOT\BCD /set "{default}" nointegritychecks on
```

## Remove SiPolicy (Critical)

> If SecureBoot is being disabled on an already installed system, delete:
```bash
del Y:\EFI\Microsoft\Boot\SiPolicy.p7b
```
Failure to delete this file will result in boot failure.

- Remove ESP Drive Letter
```bash
mountvol Y: /d
```
> If this fails, ignore it. The phantom drive will disappear after reboot.

## Flash NoSecureBoot UEFI

- Reboot to bootloader:
```bash
adb reboot bootloader
```
- Replace path\to\NoSecureboot.img with your actual image path:
```bash
fastboot flash boot path\to\NoSecureboot.img
```
- Reboot
```bash
fastboot reboot
```

# SecureBoot is now disabled.
