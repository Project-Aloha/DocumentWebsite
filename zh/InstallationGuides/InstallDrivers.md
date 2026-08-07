# 下载与安装驱动

:::tip
出于安全启动和稳定发布需要，部分设备的驱动包在开发者的仓库中单独发布（例如小米平板5、小米9等），
本文介绍的是从GIT仓库下载安装驱动的方法。
:::

## 准备
- 下载[DriverUpdater](https://github.com/WOA-Project/DriverUpdater/releases).
  > 通常来说，请下载x64/x86的版本.

- 下载平台通用驱动包
  > 点击页面上的`Download`按钮下载即可.
  <img src="/InstallationGuides/Resources/InstallDrivers/HowToDownload1.png" alt="HowToDownload1" width=40%/>
  - 对于搭载SD855的设备, 驱动库位于 [msmnile-Drivers](https://github.com/Project-Aloha/msmnile-Drivers)
  - 对于搭载SD720的设备, 驱动库位于 [Atoll-Drivers](https://github.com/Project-Aloha/Atoll-Drivers)
  - 其他平台以此类推.

- 下载适用于单独设备的驱动包
  > 点击`Download`按钮下载即可.
  <img src="/InstallationGuides/Resources/InstallDrivers/HowToDownload2.png" alt="HowToDownload2" width=40%/>
  - 对于小米平板五, 仓库在 [Nabu](https://github.com/Project-Aloha/Raphael).
  - 对于一加7T Pro, 仓库在 [Hotdog](https://github.com/Project-Aloha/Hotdog).
  - 对于其他设备, 可以参考[设备代号参考表](/ReferenceTables/DeviceCodenameReferenceTable.md)类推.

- 手机进入大容量模式 [大容量模式](EnterUMS.md).
  > 通常来说，刚刚释放完Windows，你的手机应该仍处于大容量模式下.

## 安装
  1. 解压刚刚下载的压缩包，并确保路径正确.
      - 样例:
        + 将平台通用驱动解压在 `D:\WOA\<silicon-codename>-Drivers\`
        + 将DriverUpdater解压至 `D:\WOA\<silicon-codename>-Drivers\DriverUpdater.exe`
        + 将设备特殊驱动解压至
        `D:\WOA\<silicon-codename>-Drivers\components\QC8150\Device\<device-codename>\`

  2. 打开一个管理员终端, 切换目录至 `<silicon-codename>-Drivers\`.
      - `cmd`命令:
        + `cd /d D:\WOA\<silicon-codename>-Drivers\`
      - `powershell`命令:
        + `cd 'D:\WOA\<silicon-codename>-Drivers\'`

  3. 使用`DriverUpdater.exe`安装驱动
      - 对于详细的参数介绍，请执行 `DriverUpdater.exe --help`.
      - 样例： (假设大容量情况下手机的Windows分区在电脑上显示为`F盘`):
        + `.\DriverUpdater.exe -p F: -d definitions\Desktop\ARM64\Internal\<device-codename>.txt -r .`
        + `.\DriverUpdater.exe -p F: -d definitions\Desktop\ARM64\Internal\<device-codename>.xml -r .`
  
  4. 等待完成
      - 例如QRD778释放成功的图片:
      <img src="/InstallationGuides/Resources/InstallDrivers/DriverUpdateSuccessfully.png" alt="驱动更新成功"/>
  
  5. 在电脑上弹出磁盘, 大功告成。
