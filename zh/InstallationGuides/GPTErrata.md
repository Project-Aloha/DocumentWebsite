# Windows 24H2 及更高版本的 GPT "修复"
自 24H2 以来，有一个奇怪的 bug，会在 OOBE 或更新后将您的设备变成砖头。
本指南提供一种需要在安装24H2之前、修改分区表执行的方法以帮助您防止这种情况发生。

:::danger
请在每次安装/重新安装 Windows之前，或者重新分区之后进行GPT修复。
:::

## 要求
- 一部运行 Android 的手机
- Termux、gdisk 和 Android 上的 root 访问权限。

## Android/Linux 中的步骤
- 安装 [Termux](https://github.com/termux/termux-app/releases)
- gptfdisk 的一般设置和安装
```bash
# 替换镜像
#  *使用空格选择并回车确认*
termux-change-repo 
# 更新
apt update
# 安装 root repo
apt install root-repo
# 安装 gptfdisk
apt install tsu gptfdisk
```
- 打开 gdisk 并运行
```bash
tsu # 当 termux 请求 root 权限时，请同意。
gdisk /dev/block/sda # sda 可以是 sda、sdb 或其他字母
# 在 gdisk CLI 中
x
j
# 直接回车，不输入任何内容
k
# 直接回车，不输入任何内容
w
y
```
- **对 sdb、sdc、sdd、sde、sdf... 重复** 最后一步，直到 gdisk 给出错误。

## 为什么 Windows 会损坏您的 GPT？
Windows 增加了除 lun0 之外所有 lun 的 `Starting LBA of entries`，但没有移动 LBA 条目并更新 CRC。
导致起始 LBA 不被识别和 GPT 损坏。然后您的设备无法再启动。

## 参考
- [知乎 - 为什么 WOA 会破坏 GPT 并将您的设备发送到 9008](https://zhuanlan.zhihu.com/p/1984041980913807755)
- [TG - 聊天消息](https://t.me/project_aloha_issues/1/93859)