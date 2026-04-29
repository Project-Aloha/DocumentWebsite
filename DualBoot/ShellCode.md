# Shell Code
> Assembly codes  
> Inject into kernel after compiling.

Shell Code is the key place why we patch kernel or what do we patch kernel for.  

## DualBoot ShellCodes
- For DualBoot feature, here provided several sources:
  + [DummyHead.S](https://github.com/Project-Aloha/DualBootKernelPatcher/blob/main/ShellCode/DummyHead.S)
    - PlaceHolders of Linux Kernel hdr.(refer `kernel64_hdr` struct in [Qualcomm ABL](https://git.codelinaro.org/clo/la/abl/tianocore/edk2/-/blob/KERNEL.PLATFORM.2.1.r1-04700-kernel.0/QcomModulePkg/Include/Library/BootImage.h?ref_type=tags#L477-489))
    - This part will not be injected into Linux kernel.

  + `ShellCode.xxx.S`
    - Read flags in memory or do other check.
    - Once the conditions are met, will jump to `_UEFI`, otherwise continue next instruction.

  + [CommonTail.S](https://github.com/Project-Aloha/DualBootKernelPatcher/blob/main/ShellCode/CommonTail.S)
    - First instruction is jumping to linux, that happen when condition in `ShellCode.xxx.S` not meet.
    - Provide `_UEFI`label, `ShellCode.xxx.S` will jump here after conditions.
    - Handles unexceptional behavior in the end.

## DTB Wrapper
  - Coming soon.
