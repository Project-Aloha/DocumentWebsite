# GPT "Fix" for Windows 24H2 and later
Since 24H2, there is a weird bug which will turn your device into a brick after OOBE or updates.
This guide provides a method that must be performed before installing 24H2 by modifying the partition table, helping you prevent this issue from occurring.

:::danger
Please always do GPT fix before installing/reinstalling Windows.
:::

## Requirements
- A phone running Android
- Termux, gdisk, and root access on Android.

## Steps in Android/Linux
- Install [Termux](https://github.com/termux/termux-app/releases)
- General setup and installation of gptfdisk
```bash
# Replace mirror
#  *Use space to select and enter to confirm*
termux-change-repo 
# Update
apt update
# Install root repo
apt install root-repo
# Install gptfdisk
apt install tsu gptfdisk
```
- Open gdisk and run
```bash
tsu # when termux requests root permission, please agree.
gdisk /dev/block/sda # sda can be sda, sdb, or other letters
# In gdisk CLI
x
j
# Enter without typing anything
k
# Enter without typing anything
w
y
```
- **Redo** the last step for sdb, sdc, sdd, sde, sdf... until gdisk gives an error.

## Why Windows corrupts your GPT?
Windows increases `Starting LBA of entries` of all luns except lun0 but did not move LBA entries and update CRC.
Causes the beginning LBA to not be recognized and GPT corruption. Then your device cannot boot anymore.

## Reference
- [Zhihu - Why WOA breaks GPT and sends your device to 9008](https://zhuanlan.zhihu.com/p/1984041980913807755)
- [TG - Chat message](https://t.me/project_aloha_issues/1/93859)