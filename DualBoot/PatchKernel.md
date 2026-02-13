# Apply DualBoot with DualBoot Kernel Patcher
> This guide will help you build a boot image with uefi/android dualboot feature.

## Prepare
- An android device.
- Download `UEFI FD` file from [Github Action](https://github.com/Project-Aloha/mu_aloha_platforms/actions)(You may need to login to download artifacts) or [Release Page](https://github.com/Project-Aloha/mu_aloha_platforms/releases) of uefi repository.
- `Magiskboot` for your environment, there are prebuilt binaries on github.
- DualBoot kernel patcher binary and shellcode binaries for your devices from [release page](https://github.com/Project-Aloha/DualBootKernelPatcher/releases) or [action page](https://github.com/Project-Aloha/DualBootKernelPatcher/actions).

:::Notice
  All these steps can be done on your android device.
:::

## Steps
> Assume you have done the following steps on your android device.
>  1. Root your device with magisk.
>  2. Downloaded and installed termux.
>  3. Installed root-repo and tsu in termux with apt.

- Get Android Boot Image.
  + The boot image usually can be found at `/dev/block/by-name/boot` or `/dev/block/by-name/boot_a` (or _b).
  + Open your termux, and copy the boot image out for future use.
  ```bash
  tsu                             # get root shell
  mkdir /sdcard/dualboot/         # create a folder to put files.
  cp /dev/block/by-name/boot /sdcard/dualboot/boot.img  # copy to our folder and rename to boot.img. If your device has ab slot, please add _a or _b suffix.
  ```

- Unpack it with magiskboot.
  + If your device was rooted by magisk, there should be an magiskboot binary at `/data/adb/magisk/magiskboot`
  + By the way you can press the `tab` button in termux to automatically fill path, instead of typing the characters one by one.
  + Do Unpack
  ```bash
  cd /sdcard/dualboot/            # change working directory to our folder.
  /data/adb/magisk/magiskboot unpack boot.img # unpack
  ```
  + You will get something like this:
  ```bash
  /sdcard/dualboot# /data/adb/magisk/magiskboot unpack boot.img
  Parsing boot image: [boot.img]
  HEADER_VER      [1]
  KERNEL_SZ       [41576325]
  RAMDISK_SZ      [927736]
  SECOND_SZ       [0]
  RECOV_DTBO_SZ   [0]
  OS_VERSION      [9.0.0]
  OS_PATCH_LEVEL  [2021-05]
  PAGESIZE        [4096]
  NAME            []
  CMDLINE         [console=ttyMSM0,115200n8 earlycon=msm_geni_serial,0xa90000 androidboot.hardware=qcom androidboot.console=ttyMSM0 androidboot.memcg=1 lpm_levels.sleep_disabled=1 video=vfb:640x400,bpp=32,memsize=3072000 msm_rtb.filter=0x237 service_locator.enable=1 swiotlb=2048 firmware_class.path=/vendor/firmware_mnt/image loop.max_part=7 androidboot.usbcontroller=a600000.dwc3 buildvariant=user]
  CHECKSUM        [e73518a6e1edf3062d9cebd3203a51069ef2f424000000000000000000000000]
  KERNEL_DTB_SZ   [3972965]
  KERNEL_FMT      [raw]
  RAMDISK_FMT     [raw]
  /sdcard/dualboot# ls
  boot  kernel  kernel_dtb  ramdisk.cpio
  ```
::: TIP
Please do not patch a patched kernel.
:::
- Apply patch with dualboot kernel patcher.
  + Assume the patcher and shellcodes and config you downloaded above was saved at `/sdcard/Download/`
  + Unpack these zips with these cmds, or extract in file manager.
  ```
  unzip /sdcard/Download/Shellcodes.zip
  unzip /sdcard/Download/DualBootKernelPatcher-Linux-arm64.zip
  unzip /sdcard/Download/Config.zip
  ```
  + Give permission to dualboot kernel patcher
  ```bash
  mv DualBootKernelPatcher ~/
  chmod +x ~/DualBootKernelPatcher
  ```
  + Patch kernel with a shellcode.
  ```bash
  ./DualBootKernelPatcher /sdcard/dualboot/patched_kernel <Path-to>/SM8150_EFI.fd /sdcard/dualboot/kernel <Path-To>/Config/DualBoot.Sm8150.cfg <Path-To>/ShellCode.XXXX.bin
  ```
  + Repack boot image with patched kernel
  ```bash
  cd /sdcard/dualboot/
  mv patched_kernel kernel
  /data/adb/magisk/magiskboot repack boot.img
  ```
  + You will get a file named `new-boot.img` if magiskboot success.

- Test with fastboot.
  + Send `new-boot.img` to your computer:
  ```pwsh
  adb pull /sdcard/dualboot/new-boot.img
  ```
  + Reboot to fastboot
  ```pwsh
  adb reboot bootloader
  ```
  + Ensure OS-switch is on the correct state before it loading. Like magnet shell or tri-state key.
  + Try load boot image once.
  ```pwsh
  fastboot boot new-boot.img
  ```
  + See if the device is entering a correct os.

- Flash boot image into disk
  + If everything goes well and boot image was backuped. You can flash boot image into disk now. Then no fastboot command is required when using dualboot.
  + Flash boot:
  ```pwsh
  fastboot flash boot new-boot.img
  ```
- Recover original boot image:
  + If you want to remove dualboot, flash your backuped boot image.
  ```pwsh
  fastboot flash boot.img
  ```

## Remove dualboot
Run `DualBootPatchRemover` on the patched kernel and rebuild the boot image. After flashing to boot parition the dualboot feature will disappear.