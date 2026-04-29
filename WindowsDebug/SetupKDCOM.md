# Setup Windbg KdCom
::: tip Tips
Suggest using KdNet for better experience if you can not access your device's uart pins easily.  
KdCom does not support rdp over it.
:::

## Preparation
  - A dev board, or any device with uart test points
  - An UART->USB bridge, or on board bridge.(Notice: Qualcomm use 1.8V as VDDIO)
  - Debugging slave installed windows
  - Debugging host installed [Windbg Preview](https://apps.microsoft.com/detail/9pgjgd53tn86)

## Setup BCD
  - Mount ESP Partition on you phone with root permission in adb shell or termux.
    + Simply jump this step if you are using USB mass storage mode.
    ```bash
    # Execute on phone
    mkdir /dev/esp_mnt
    mount /dev/block/by-name/esp /dev/esp_mnt
    ```
  - Copy BCD to your host computer.
    + If you are using UMS, find the BCD file and copy it to D: or anywhere you want in explorer.
    + Copy to /sdcard
    ```bash
    # Execute on phone
    cp /dev/esp_mnt/EFI/Microsoft/Boot/BCD /sdcard
    ```
    + Pull to computer.
    ```powershell
    # Execute on computer, assuming installed adb.
    # Assuming copy to D:, you can set any path you want.
    adb pull /sdcard/BCD D:\
    ```
  - Open an **administrator** terminal and set bcd configurations.
    ```powershell
    cd D:\
    bcdedit /store BCD /set "{default}" testsigning on
    bcdedit /store BCD /set "{default}" nointegritychecks on
    bcdedit /store BCD /set "{default}" debug on 
    bcdedit /store BCD /dbgsettings serial baudrate:115200 debugport:1
    ```
  - Push BCD back to your phone.
    + If you are using UMS, simply replace the original BCD file.
    ```powershell
    # Execute on computer
    adb push BCD /sdcard
    # Delete BCD after pushing
    del D:\BCD
    ```
    ```bash
    # Execute on phone
    # Backup normal BCD
    cp /dev/esp_mnt/EFI/Microsoft/Boot/BCD /dev/esp_mnt/EFI/Microsoft/Boot/NMBCD
    # Backup kdnet enabled BCD
    cp /sdcard/BCD /dev/esp_mnt/EFI/Microsoft/Boot/DBGBCD
    # Replace active BCD
    cp /sdcard/BCD /dev/esp_mnt/EFI/Microsoft/Boot/BCD
    ```

## Setup KdCom in Windbg
  - Open device manager on your computer.
  - Connect UART->USB bridge to computer, and check the `COMXX` Number under `Serial` section in device manager
  - Open Windbg Preview, Click **File** button on the top left corner.
  - Click `Attach to kernel` under `Start debugging`(default section).
  - Choose `COM` section
    + Fill `Baud Rate` with `115200`
    + Fill `Port` with `COMXX`, which you saw in device manager
    + Others keep default
  - Click `OK` button and windbg will start waiting for connection.


## Connect KdCom
  - Ensuing DBG2 configuration is correct(No need worry because the address in dbg2 was fixed generally here).
  - Reboot your phone, and connect it to computer with a usb cable.
  ```powershell
  # Execute on computer, boot uefi
  fastboot boot uefi.img
  ```
  - Phone booting windows and hang up for several seconds, you can see windbg print logs if successfully connected.

::: tip Notice
  - You can close Windbg and open a serial tool like PuTTY or SecureCRT to check if the phone printed some unrecognized messages while windows booting. If it isn't that means BCD configurations were wrong
:::
