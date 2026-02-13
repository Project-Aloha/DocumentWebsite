# Hide partitions in windows disk management
> In Windows, you may want to *hide* some partitions
> in Windows Disk Manager to prevent damage from Windows,
> this guide will tell you how to change gpt partition's
> attribute to mark a partition as **system** partition.  

:::warning
Please **carefully** read each step and comments.  
**Wrong actions may damage your GPT table and brick your device**.
:::

## Requirement
- A phone in Windows or Android/Linux
- Diskpart in Windows, gdisk in Linux, termux+gdisk+root in android.

## Steps in Windows
- Open a terminal with administrator permission.
- Type `diskpart` and enter .
- List all disks
```powershell
lis dis
```
- Choose the disk contains your target partition, use `1` for example here.
```powershell
sel dis 1
```
- List all partitions in this disk
```powershell
lis par
```
- Select your target partition, use `1` for example here.
```powershell
sel par 1
```
- Get partition current gpt attribute
```powershell
det par
# Partition 1
#  Type    : d32b7c28-e321-21cc-1122-12acc91ec92b
#  Hide  : No
#  Necessary: No
#  Attribute  : 0X1C00000000000000
#  Bytes Offset: 1234
```
- Set *system bit* in partition gpt attribute.
  + system bit is the lowest bit.
:::warning
Please *ONLY* set the last bit to 1.
:::
```powershell
GPT ATTRIBUTES=0x1C00000000000001
```
- Set system bit for all partitions in a lun can make the lun invisible in Windows device manager.

## Steps in Android/Linux
- Install [Termux](https://github.com/termux/termux-app/releases)
- General setup, and setup gptfdisk
```bash
# Replace mirror
#  *Use space to select and enter to confirm*
termux-change-repo 
# Update
apt update
# Install root repo
apt install root-repo
# Install gdisk
apt install tsu gptfdisk
```
- Open gdisk
```bash
tsu # when termux request root permission, please agree.
gdisk /dev/block/sdx # x can be a, b, or other letters
```
- Enter expert mode
```bash
x
# Expert command (? for help):
```
- Change partition's attribute
```bash
# Expert command (? for help): 
a # Change partition attribute
# Partition number:
1 # Enter partition number
# Known attributes are:
# 0: system partition
# 1: hide from EFI
# 2: legacy BIOS bootable
# 60: read-only
# 62: hidden
# 63: do not automount

# Attribute value is 10C0000000000000. Set fields are:
# 54 (Undefined bit #54)
# 55 (Undefined bit #55)
# 60 (read-only)

# Toggle which attribute field (0-63, 64 or <Enter> to exit): 
0 # System bit
# Have enabled the 'system partition' attribute.
# Attribute value is 10C0000000000001. Set fields are:
# 0 (system partition)
# 54 (Undefined bit #54)
# 55 (Undefined bit #55)
# 60 (read-only)
```
- Set system bit for all partitions in a lun can make the lun invisible in Windows device manager.
