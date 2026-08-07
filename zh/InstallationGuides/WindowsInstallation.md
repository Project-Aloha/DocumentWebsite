# Windows安装方法简述

## 前言
  你需要准备以下材料：
  - Windows系统镜像
  - 一台可以插USB的电脑
  - msmnile-Drivers Release中的驱动包
  - DriverUpdater.exe
  - 一个你手机可以用的Rec，例如TWRP或OrangeFox等
  - 一些时间

## 获取Windows系统镜像
### 方法一
  使用Gustave Monce 的UUP Download 下载.
  - 去这里下载适合你的系统的版本并解压
  - 打开解压后的文件夹，Shift+右键选择`在终端中打开`
    + 你可以下载任何你想要的版本，用法参考[这里](https://github.com/gus33000/UUPMediaCreator#usage)或者[这里](https://github.com/WOA-Project/SurfaceDuo-Guides/blob/main/CreateWindowsISO.md)
    + 示例：下载Win11 22h2，然后转换为iso格式
    ```powershell
    UUPDownload.exe -s Professional -v 10.0.22621.1105 -r Retail -b Retail -c vb_release -t arm64 -l zh-cn

    UUPMediaConverter.exe -u 10.0.22621.1.ni_release.220506-1250_arm64xxxxxxxxx -i Windows11_Pro_arm64_en-US.iso -l zh-cn -e Professional
    ```
  - 如果下载失败，重新运行一遍命令就是了，还有就是检查存储空间是否足够
  - 成功后你会找到一个Windows11_Pro_arm64_en-US.iso, 保留备用，其他文件可直接删除

### 方法二
  去新版MSDN I tell you上用种子下载一个. 不提供详细说明

## 获取驱动包
## 分区简述
## 安装驱动
