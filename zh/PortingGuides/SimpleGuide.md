# mu_aloha_platforms 移植向导。
:::danger
 **⚠ 请勿在谷歌设备、索尼设备或三星设备上尝试。**
 **⚠ 请勿使用其他设备的固件，即使是相同厂商或类似硬件**
:::

> ### 此向导分为4部分。
>> 0. 介绍一些目录和文件。
>> 1. 初步移植和测试。
>> 2. 尝试启动Windows并测试UFS和USB。
>> 3. 补丁二进制文件。
___
## **第0部分。** 介绍目录和文件。
  - 我们只需要了解 `Platform/SurfaceDuo1Pkg/` 下的几个目录和文件。
    ```bash
    ~/<repo_root>$ tree Platforms/SurfaceDuo1Pkg/ -L 2 -d
    Platforms/SurfaceDuo1Pkg/
    ├── Device
    │   ├── asus-I001DC
    |   |   ├── ACPI
    |   |   ├── Binaries
    |   |   ├── DeviceTreeBlob
    |   |   │   ├── Android
    |   |   │   └── Linux
    |   |   ├── Library
    |   |   │   ├── PlatformConfigurationMapLib
    |   |   │   └── PlatformMemoryMapLib
    |   |   └── PatchedBinaries
    │   └── xiaomi-vayu
    ├── Include
    │   ├── IndustryStandard
    │   └── Resources
    └── PythonLibs
    ```
    - **Device/**
      * 存储每个设备的特定二进制文件和配置。
      * 子文件夹名称必须是 `brand-codename`。
    - **Include/**
      * 包含C头文件和ACPI.inc
    - **PythonLibs/**
      * 存储python库，如android boot pack配置。
  - 让我们更仔细地看看 `Device/nubia-tp1803`。
    ```bash
    ~/<repo_root>/Platforms/SurfaceDuo1Pkg/Device$ tree -L 1  nubia-tp1803/
    ├── ACPI
    ├── APRIORI.inc
    ├── Binaries
    ├── Defines.dsc.inc
    ├── DeviceTreeBlob
    ├── DXE.dsc.inc
    ├── DXE.inc
    ├── Library
    ├── PatchedBinaries
    └── PcdsFixedAtBuild.dsc.inc
    ```
    - **ACPI/**
      * 存储此设备的dsdt表。
    - **Binaries/**
      * 存储此设备的固件二进制文件。
    - **PatchedBinaries/**
      * 存储此设备的补丁二进制文件。
    - **Library/**
      * 放置设备特定的库，如内存映射和配置映射。
    - **DeviceTreeBlob/**
      * 放置设备树blob
        - 子目录 `Linux` 存储主线linux dtb，文件名称必须是 `linux-codename.dtb`
        - 子目录 `Android` 存储Android dtb，文件名称必须是 `android-codename.dtb`
    - **APRIORI.inc**
      * 驱动的加载顺序。
      * 由SurfaceDuo1.fdf包含
    - **DXE.inc**
      * 在FD中声明驱动。
      * 此文件中的驱动也必须在dsc中定义。
      * 由SurfaceDuo1.fdf包含
    - **DXE.dsc.inc**
      * 声明驱动
      * 如果未在fdf中定义，驱动将不会包含在输出fd中。
      * 由SurfaceDuo1.dsc包含
    - **Defines.dsc.inc**
      * 特殊用途的宏。
      * 有关宏的详细信息，请阅读 [DefinesGuidance.md](DefinesGuidance.md)
    - **PcdsFixedAtBuild.dsc.inc**
      * 由SurfaceDuo1.dsc包含。
      * 存储设备特定的pcds。（例如屏幕分辨率）
___
## **第1部分。** 初步移植和测试。
  - 例如，为meizu 16T移植uefi。
    1. 搜索其代码名称：m928q。
    2. 复制 `oneplus-guacamole/` 文件夹到 `meizu-m928q/`。（brand-codename）。
    3. 删除 `meizu-m928q/Binaries` 和 `meizu-m928q/PatchedBinaries` 下的所有文件。
    4. 从设备的xbl提取文件并放置在Binaries下。
        + *下载并编译 [UefiReader](https://github.com/WOA-Project/UEFIReader)*
        + *将手机连接到电脑并在电脑上执行命令。*
          ```bash
          adb shell su -c "dd if=/dev/block/by-name/xbl_a of=/sdcard/xbl.img"
          adb pull /sdcard/xbl.img .
          ```
        + *执行 UefiReader.exe \<Path-to-xbl.img\> \<Path-to-output-folder\>*
        + *将输出放入 `meizu-m928q/Binaries`。*
    5. 编辑 `${brand-codename}/DXE.inc`，`${brand-codename}/APRIORI.inc`，`${brand-codename}/DXE.dsc.inc`。
        + *通过 `diff` 查看差异*
          ```bash
          $ diff meizu-m928q/Binaries/DXE.inc oneplus-guacamole/Binaries/DXE.inc 
          23d22
          < INF QcomPkg/Drivers/SimpleTextInOutSerialDxe/SimpleTextInOutSerial.inf
          97,102d95
          < FILE FREEFORM = A91D838E-A5FA-4138-825D-455E23030795 {
          <     SECTION UI = "logo2_ChargingMode.bmp"
          <     SECTION RAW = RawFiles/logo2_ChargingMode.bmp
          }
            ...
          ```
        + *所以你必须编辑 `${brand-codename}/DXE.inc` 中的 `Raw Files` 部分，并在 `${brand-codename}/DXE.inc` 和 `${brand-codename}/DXE.dsc.inc` 中添加 SimpleTextInOutSerial*
        + *如果 SimpleTextInOutSerial 也在 Binaries/APRIORI.inc 中设置，你需要将其添加到 `${brand-codename}/APRIORI.inc`*
    6. 如果需要，在 `Defines.dsc.inc` 中启用 MLVM（FALSE -> TRUE）。
    7. 在 `PcdFixedAtBuild.dsc.inc` 中编辑分辨率。
    8. 补丁设备的dxe并将其放置在 `PatchedBinaries/` 下。
    9. 用 `android-m928q.dtb` 替换 `android-guacamole.dtb`。请参阅 [Additions](#additions) 以获取设备的android DTB。
    10. 用 `linux-m928q.dtb` 替换 `linux-guacamole.dtb`。（如果没有，创建一个虚拟的 `touch linux-m928q.dtb`）
    11. 构建它。请参阅uefi readme。**记住启用DEBUG BUILD和SCREEN DEBUG**
    12. 测试它。
        + *将手机连接到电脑并在电脑上执行。*
          ```bash
          adb reboot bootloader
          fastboot boot Build/meizu-m928q/meizu-m928q.img
          ```
  - 如果移植成功，设备将进入带有QRCode的FFU Flash App。
  - 如果它卡住、重启或崩溃怎么办？
    * 请参阅第3部分并补丁设备的固件二进制文件，或联系我们。
___
## **第2部分。** 尝试启动Windows。
  *guacamole的DSDT是基本的DSDT。它只包含USB和UFS。*
  - 在设备上设置Windows PE环境。
  - 尝试启动到Windows PE。
  - 如果它卡住、重启或崩溃怎么办？
    * 检查MemoryMap *(brand-codename/Library/PlatformMemoryMapLib/PlatformMemoryMapLib.c)*。
    * 检查DeviceConfigurationMap *(brand-codename/Configuration/DeviceConfigurationMap.h)*。
    * 检查 `Defines.dsc.inc` 中的HAS_MLVM，如果Windows在启动时挂起，尝试将其设置为 `TRUE`。
  - 使用外部电源供应USB不工作？
    * 补丁固件二进制文件。
  *如果移植成功，它将启动到PE。*
___
## **第3部分。** 补丁二进制文件。
  - 哪些二进制文件需要补丁？
    * 如果手机在加载PILDxe时卡住，补丁UFSDxe。
    * 如果手机无法通过KDNET连接PC，或USB在Windows中不工作（使用外部电源），补丁UsbConfigDxe。
    * 如果手机无法在uefi阶段使用按钮，请补丁ButtonsDxe。
  - 在哪里补丁？
    * 最简单的方法知道在哪里补丁：
      + 找到另一个设备的原始xxxDxe.efi和其补丁的xxxDxe.efi。
      + 转储hex并获取在哪里和什么补丁。
        ```bash
        hexdump -C a_xxxDxe.efi > a.txt
        hexdump -C b_xxxDxe.efi > b.txt
        diff a.txt b.txt
        ```
        - 示例：
            * UFSDxe.efi (nabu)：
            ```bash
            ~/<repo_root>/Platforms/SurfaceDuo1Pkg/Device/xiaomi-nabu$ diff a.txt b.txt 
            383c383
            < 000025f0  00 00 80 52 c0 03 5f d6  fd 7b 03 a9 fd c3 00 91  |...R.._..{......|
            ---
            > 000025f0  ff 03 01 d1 f4 4f 02 a9  fd 7b 03 a9 fd c3 00 91  |.....O...{......|
            913c913
            < 00004710  20 00 80 52 c0 03 5f d6  fd 43 00 91 e8 7b 00 32  | ..R.._..C...{.2|
            ---
            > 00004710  ff 83 00 d1 fd 7b 01 a9  fd 43 00 91 e8 7b 00 32  |.....{...C...{.2|
            ```
    * 如何补丁？
      + 现在你知道差异地址是 `0x000025f0` 和 `0x00004710`。
      + 在IDA（或其他工具）中打开两个efi文件，找到 `0x000025f0` 和 `0x00004710` 附近的函数。
      + 查看哪些指令被修改了。
      + 在IDA中打开设备的xxxDxe.efi。
      + 找到相同的函数。
      + 为设备的xxxDxe.efi应用相同的补丁。
      + 将补丁二进制文件放置在 `PatchedBinaries/` 下。
      + 检查DXE.inc和DXE.dsc.inc中设备的补丁二进制文件的路径。
___
## **Additions**
  - 如何获取设备的dtb？*假设在termux环境中*
    * 下载Magiskboot。（[Prebuilt](https://github.com/TeamWin/external_magisk-prebuilt/blob/android-11/prebuilt/)）
    * 从手机获取boot镜像。
      ```bash
      sudo cp /dev/block/by-name/boot ~/split-appended-dtb/myboot.img
      ```
    * 从手机的boot中分割dtb。
      ```bash
      ./magiskboot_arm unpack myboot.img
      ```
    * 将 `kernel_dtb`（或 `dtb`）重命名为 android-`codename`.dtb 并放置在 Device/*\<brand-codename\>*/DeviceTreeBlob/Android/ 中。
  - MLVM应该总是 `TRUE` 吗？
    * 在早期测试中你可以将其设置为 `TRUE` 以避免MLVM问题。
    * 如果你可以启动Windows，将其关闭为 `FALSE` 并尝试。
    * 将MLVM设置为 `TRUE` 将占用大约300MB Ram。
___
***不要忘记将设备和维护者添加到 [README](https://github.com/Project-Aloha/mu_aloha_platforms)。***
***感谢你的辛勤工作。***


