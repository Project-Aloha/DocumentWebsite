# Windows Installation Guide


:::warning
This process can permanently brick your device if done incorrectly.
Read every step carefully and DO NOT modify partitions unless explicitly instructed.
:::

---

## Diskpart

:::danger
DO NOT ERASE, CREATE OR MODIFY ANY PARTITION IN DISKPART.
THIS CAN ERASE YOUR ENTIRE UFS OR BREAK FASTBOOT.
YOUR DEVICE MAY BECOME PERMANENTLY BRICKED.
:::

1. Open Command Prompt as Administrator.

2. Start diskpart:

```
diskpart
```

3. Find the Windows partition:

```
list volume
```

- Replace $ with the actual volume number of WIN(DEVICE-NAME):

```
select volume $
assign letter F
```

4. Find the ESP partition:

```
list volume
```

> Replace $ with the actual volume number of ESP(DEVICE-NAME):

```
select volume $
assign letter Y
```

5. Exit diskpart:

```
exit
```

---

## Installing Windows

You can download ISO of Windows from [uupdump](https://uupdump.net/). But you may need to run a script to generate ISO files. 
> Alternatively there is a [site](https://github.com/ArKT-7/woawin) where you can download premade ESD images. We do not guarantee its safety. Please decide which method by yourself.



> Replace path\to\install.esd with your actual image path:

```
dism /apply-image /ImageFile:path\to\install.esd /index:6 /ApplyDir:F:\
```

> If you get Error 87, check the correct index:

```
dism /get-imageinfo /ImageFile:path\to\install.esd
```

> Then replace index:6 with the correct index of Windows

---


## Create Windows Bootloader

>If an error appears like:
"Failure when attempting to copy boot files"

- Reopen diskpart and assign a new letter to the ESP partition (ESP(DEVICE-NAME)), then use that letter instead of Y.

- Create boot files:

```
bcdboot F:\Windows /s Y: /f UEFI
```

- Remove ESP drive letter:

```
mountvol Y: /d
```

> If this fails, ignore it. The phantom drive will disappear after reboot.

---

