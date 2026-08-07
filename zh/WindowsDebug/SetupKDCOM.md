# 配置Windbg KdCom
::: tip 提示
如果你正在调试的设备引出了**UART引脚**，那么你可以使用这种方法在不占用一个USB口的情况下进行调试，但其速度较慢且**不支持远程桌面**。
:::

## 准备工具
 - 一块高通的开发板，或者一台工程机
 - 调试串口可以使用
 - 已经在待测设备上正确安装了Windows
 - 安装了[Windbg Preview](https://apps.microsoft.com/detail/9pgjgd53tn86)

## 设置BCD
  - 找到手机里面ESP分区内的/EFI/Microsoft/Boot/BCD （路径不区分大小写）
    + 你可以采用大容量模式挂载ESP分区获取[BCD](https://learn.microsoft.com/zh-cn/windows-hardware/manufacture/desktop/bcd-system-store-settings-for-uefi)文件，也可以采用安卓/REC挂载的方式获取BCD
    + 以下举例安卓/REC挂载获取的方法，假定你的ESP分区的label是esp:
    ```bash
    # 在手机上以root权限执行:
    mkdir /dev/esp_mnt
    mount /dev/block/by-name/esp /dev/esp_mnt
    cp /dev/esp_mnt/EFI/Microsoft/Boot/BCD /sdcard
    ```
    ```powershell
    # 在电脑的终端中执行，请确保你已经安装adb并配置了环境变量
    adb pull /sdcard/BCD D:\
    ```
  - 在电脑上打开一个**具有管理员权限**的终端，并设置调试模式：
    ```powershell
    cd D:\
    bcdedit /store BCD /set "{default}" testsigning on
    bcdedit /store BCD /set "{default}" nointegritychecks on
    bcdedit /store BCD /set "{default}" debug on 
    bcdedit /store BCD /dbgsettings serial baudrate:115200 debugport:1
    ```
  - 将BCD复制到手机上的ESP分区中
    ```powershell
    # 在电脑的终端中执行，请确保你已经安装adb并配置了环境变量
    adb push BCD /sdcard
    # 在确认已经推到手机以后，删除D:\BCD
    del D:\BCD
    ```
    ```bash
    # 在手机上以root权限执行:
    cp /dev/esp_mnt/EFI/Microsoft/Boot/BCD /dev/esp_mnt/EFI/Microsoft/Boot/NMBCD
    cp /sdcard/BCD /dev/esp_mnt/EFI/Microsoft/Boot/DBGBCD
    cp /sdcard/BCD /dev/esp_mnt/EFI/Microsoft/Boot/BCD
    ```

## Windbg KdCom配置
  - 将USB转TTL设备连接到电脑上，此时在设备管理器中的**端口**中可以看到端口号为`COMXX`.
  - 打开Windbg(新版)，点击左上角**文件**
  - 点击`Start Debugging`下面的`Attach to kernel`
  - 点击右方窗口中的`COM`选项，
    - `Baud Rate`一栏中填入`115200`
    - `Port`一栏中填入你在设备管理器中看到的`COMXX`, `XX`是几就写几。
    - 其余默认即可
  - 点击下方的`OK`按钮, 此时Windbg应该会进入等待连接状态

## 待测机启动
  - 确保待测机器的DBG2表配置正确（一般本项目支持的平台都会正确配置，故无需担心）
  - 在待测机器上启动Windows, Windows 会等待大约几秒时间连接Windbg
  - 若Windbg的`command`窗口中打印出待测机的Windows内核版本信息，则Windbg kdcom此时成功连接。

::: tip 后记
  - 如果在Windows启动的时候直接使用串口工具（例如PuTTY、SecureCRT之类）查看文字输出，那么会在控制台看见一些与kdcom相关的乱码字符。
  - 故如若Windbg无法连接内核且串口在Win启动时无输出乱码字符，应考虑kdcom配置是否有误。
:::
