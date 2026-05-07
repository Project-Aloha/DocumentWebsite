# Config File
## Introduction
Config File defines the Stack info used to patch kernel.  
If you do not need it, set the two values to 0.

## Format
  - A config file should only contain the following contents.
  ```
  StackBase=0x00000000
  StackSize=0x00000000
  RestartReasonAddress=0x00000000
  ```
  - The value after `=` must be hex number.
  - Config file not in this format will cause unexceptional behavior.

## How to get these values
  - `StackBase`
    + StackBase can be found in your device's MemoryMap, which is named `UEFI FD`
  
  - `StackSize`
    + StackSize the right after the base address of `UEFI FD`.
  
  - `RestartReasonAddress`
    + Coming Soon.
    + RestartReasonAddress can be found in a Qualcomm device's device tree.
    + Enter android or recovery, run the following shell cmd with root permission.
    + Output should like this:
    ```bash
    android:/# printf "RestartReasonAddress=0x%x\n" $((0x$(realpath /sys/firmware/devicetree/base/soc/qcom\,msm-imem@*/restart_reason@* | awk -F'[@/]' '{print $(NF-2)"+0x"$(NF)}')))
    RestartReasonAddress=0x146bf65c
    ```
  
    
