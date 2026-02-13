# Debugging Skills

## Enable log output
Our UEFI provides 4 ways currently for getting UEFI logs.
```
  USE_SCREEN_FOR_SERIAL_OUTPUT    = 0
  USE_UART_GENI_FOR_SERIAL_OUTPUT = 0
  USE_UART_DM_FOR_SERIAL_OUTPUT   = 0
  USE_MEMORY_FOR_SERIAL_OUTPUT    = 0
```
Only one of them can be enabled at the same time.

### USE_SCREEN_FOR_SERIAL_OUTPUT
Set to **1** to enable serial output via screen. Logs will be printed to screen
directly. This way is very **useful** for devices without a UART.

### USE_UART_GENI_FOR_SERIAL_OUTPUT
Set to **1** to enable serial output via a real serial port. Logs will be printed
to the geni uart address at `gAndromedaPkgTokenSpaceGuid.PcdUartSerialBase` which is defined in
*Silicon/QC/XXX/QcomPkg/QcomPkg.dsc.inc*.

### USE_UART_DM_FOR_SERIAL_OUTPUT
Similar to **USE_UART_GENI_FOR_SERIAL_OUTPUT**. It's used for older Qualcomm platforms like msm8996.

### USE_MEMORY_FOR_SERIAL_OUTPUT
Set to **1** to print logs to pstore memory. It's useful when you have JTAG or EUD enabled on your
device. The log output region is defined in your device's *Library/PlatformMemoryMapLib/PlatformMemoryMapLib.c*.  
The region must be named *PStore* like this:
```
{"PStore", <StartAddress>, <Size>, AddMem, MEM_RES, SYS_MEM_CAP, Reserv, WRITE_THROUGH_XN},
```