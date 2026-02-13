# Find Protocol Addresses
:::warning WARNING
This page is deprecated now, new uefi supports find address at runtime.
You only need to read this page when the online locator in uefi does not work.
:::

On Sm8550 and newer platforms, many uefi drivers need ***scheduler*** protocol and ***xbldt*** protocol.  
Our solution is to reserve the original *UEFI FD* region in XBL's memory map, find the addresses in decompile tool, then provide these protocols again.
___

## Tools Needed
  - *IDA/Ghidra*
  - *[UefiReader](https://github.com/WOA-Project/UEFIReader)*

## Steps
  1. Get **uefi** partition from your phone:
      - In *termux* or adb shell:
        ```bash
        cp /dev/block/by-name/uefi_a /sdcard
        ```
  
  2. Use UefiReader to extract uefi_a image:
      - Windows:
        ```powershell
        UefiReader.exe <absolute-path-to-uefi_a> <absolute-path-to-output-dir>
        ```
      - Linux:
        ```bash
        sudo apt install dotnet-sdk-6.0
        git clone https://github.com/WOA-Project/UEFIReader
        cd UEFIReader/UEFIReader
        dotnet run <absolute-path-to-uefi_a> <absolute-path-to-output-dir>
        ```
  
  3. Find XBLCore.te and put it into IDA.
        - After extracting you can find the XBLCore.te under BOOT.MXF.XXXXX\QcomPkg\XBLCore\XBLCore.te
        - Drag XBLCore.te into IDA.
        - Waiting Decompile finish.
        - Press `Alt+B`.
        - Type `E8 E1 06 3A F6 61 EB 11 BB ED 4B 47 6E 2F F6 A7`, Click **OK**.
            <img src="/PortingGuides/Resources/FindProtocolAddresses/IDABinarySearch.png" width=80%/>
        - Double Click the only result, the tool will jump to IDA `View-A`.
        - Click the label (e.g. *unk_A703B290*), then press `x`, Click **OK**.
            <img src="/PortingGuides/Resources/FindProtocolAddresses/IDAXrefs.png" width=80%/>
        - Select the instruction that 2 instractions before *ADRL X0,unk_A703B290*(it is *ADRL X8, unk_A703B0C8* here.).
            <img src="/PortingGuides/Resources/FindProtocolAddresses/IDAViewASecDTB.png" width=80%/>
        - Copy *A703B0C8* to your note book. This is XBL DTB Protocol Address.
        - Press `Alt+B`.
        - Type `8D BD C2 8E D7 56 EF 49 87 96 63 17 78 F8 EB F8` and Click **OK**.
        - Use the same way you just done, then you'll find the address for Schedule Protocol.

  4. Fill address in your device's PcdsFixedAtBuild.dsc.inc.
      - Here gives an example.  
        <img src="/PortingGuides/Resources/FindProtocolAddresses/PcdsFixedAtBuildSample.png" width=80%/>

## Notice & Issues
  - Fix address here may cause some issues.
    1. Each Big Update or Even a Rebuild can make the addresses changed.
    2. The addresses are different between devices. They are not generic. So you must find them for your device yourself.

  :::danger
  **NEVER TRY TO BOOT UEFI on SAMSUNG/SONY devices, unless you know WHAT ARE YOU DOING and the RISK of WIPING UFS.**
  :::
