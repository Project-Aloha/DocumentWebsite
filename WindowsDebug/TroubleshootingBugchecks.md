# Troubleshooting Windows Bugchecks

Most "Windows won't boot on my device" reports come down to one rule:

::: tip The version-pairing rule
**The UEFI build, the Windows build and the driver pack (BSP) must come from the same
generation.** Mixing eras produces bugchecks that look convincingly like hardware or
firmware faults.
:::

If Windows bugchecks at boot or during first-time setup, find your stop code below before
suspecting your hardware. These four cover the vast majority of reports
(root-caused on xiaomi-nabu / sm8150; the mechanisms are platform-level, so they apply to
other targets too — data in
[mu_aloha_platforms#766](https://github.com/Project-Aloha/mu_aloha_platforms/issues/766)).

## Quick reference

| Stop code | Looks like | Actual cause | Fix |
|---|---|---|---|
| `0x7B` INACCESSIBLE_BOOT_DEVICE, instant | "storufs can't drive my UFS / bad UFS vendor" | Windows volume formatted with Linux `mkfs.ntfs` (unreliable for the boot path, especially on native-4Kn storage), or an old-era Windows image under a new-era UEFI | Format the volume from Windows tools (`Format-Volume` / diskpart); keep generations matched |
| `0x1D5` DRIVER_PNP_WATCHDOG on `qcsmmu`, ~6 min in | "SMMU driver broken" | Booting a **pre-MmuDetach** (before Jan 2026) UEFI **ephemerally** via `fastboot boot` leaves SMMU state Windows can't take over. The same image *flashed* works | Use a current UEFI (post-MmuDetach boots fine even ephemerally), or flash the boot image instead of `fastboot boot` |
| `0x3B` SYSTEM_SERVICE_EXCEPTION in `win32kbase`, every boot, during device setup | "touch driver broken" | Windows 24H2 26100.1 RTM: win32k itself faults when a touch driver registers its pointer device (`rimInUserCritCreatePointerDeviceInfo`). Microsoft code, fixed in later builds | Use the Windows build your driver pack's guide specifies (e.g. 25H2 for 2501+ packs) — it's a hard requirement, not a preference |
| `0xA` IRQL_NOT_LESS_OR_EQUAL in `ntoskrnl`, very early, no dump written | "random / kernel incompatible" | A newer-era Windows kernel (e.g. 26200) under an older-era UEFI | Update the UEFI to the generation matching the Windows build |

## Notes

- **Retrying the same boot is information-free** for the `0x3B` / `0xA` class — they replay
  deterministically, bit for bit. Change one of the three components instead of rebooting again.
- **UFS vendor variants (Samsung / Micron / SKHynix) are not a Windows failure class.** A Samsung
  KLUEG8UHDC unit runs Windows fully (WiFi/BT/audio/touch) on current builds. If your device
  boots Linux/Android, the storage is fine — check the version pairing first.
- For the install procedure itself see
  [Windows installation](/InstallationGuides/WindowsInstallation.md) and
  [Install Drivers](/InstallationGuides/InstallDrivers.md).
- If your stop code is not listed here, capture a kernel dump and see the
  [KDNET setup guide](/WindowsDebug/SetupKDNET.md) for live debugging.
