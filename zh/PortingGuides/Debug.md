# 调试技巧
## 打开日志输出
我们的UEFI目前提供4种获取UEFI日志的方式。
```
  USE_SCREEN_FOR_SERIAL_OUTPUT    = 0
  USE_UART_GENI_FOR_SERIAL_OUTPUT = 0
  USE_UART_DM_FOR_SERIAL_OUTPUT   = 0
  USE_MEMORY_FOR_SERIAL_OUTPUT    = 0
```
同时只能启用其中一种。

### USE_SCREEN_FOR_SERIAL_OUTPUT
设置为 **1** 以通过屏幕启用串行输出。日志将直接打印到屏幕上。这种方式对于没有UART的设备非常**有用**。

### USE_UART_GENI_FOR_SERIAL_OUTPUT
设置为 **1** 以通过真实串行端口启用串行输出。日志将打印到 geni uart 地址 `gAndromedaPkgTokenSpaceGuid.PcdUartSerialBase`，该地址在 *Silicon/QC/XXX/QcomPkg/QcomPkg.dsc.inc* 中定义。

### USE_UART_DM_FOR_SERIAL_OUTPUT
与 **USE_UART_GENI_FOR_SERIAL_OUTPUT** 类似。它用于较旧的Qualcomm平台，如msm8996。

### USE_MEMORY_FOR_SERIAL_OUTPUT
设置为 **1** 以将日志打印到pstore内存。当您的设备上有JTAG或启用EUD时，这很有用。输出区域在您的设备的 *Library/PlatformMemoryMapLib/PlatformMemoryMapLib.c* 中定义。该区域必须命名为 *PStore*，如下所示：
```
{"PStore", <StartAddress>, <Size>, AddMem, MEM_RES, SYS_MEM_CAP, Reserv, WRITE_THROUGH_XN},
```