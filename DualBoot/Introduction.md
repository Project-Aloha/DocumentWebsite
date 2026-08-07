## DualBoot Kernel Patcher
> Based on [SurfaceDuoDualBootKernelImagePatcher](https://github.com/WOA-Project/SurfaceDuoDualBootKernelImagePatcher).  

Kernel Patcher is a tool can inject shell codes into Linux kernel header, which can help achieve dual boot.  
Can also do some more interesting things like replace dtb provided by abl with ours, select different linux kernel etc.

## DualBoot Boot Order
```mermaid
flowchart TD
  bl[Bootloader]
  subgraph patched_kernel[Patched Kernel]
    subgraph ori_kernel[Origin Linux Kernel]
      subgraph shellcode[ShellCode]
        start_shellcode(Entry of Shell Code)
        check_memory{Check flags in memory}
        copy_fd[Copy UEFI FD to UEFI stack region]
        jump_stack_base[Jump to UEFI stack base.]
      end
      subgraph kernel_data[Kernel Data]
        kernel[Rest of Linux Kernel]
      end
    end
    subgraph uefi_fd[UEFI FD Data]
      uefi[UEFI FD]
    end
  end
  
  subgraph uefi_program[UEFI]
    direction LR
    PEI-->DXE-->BDS-->etc[...]
  end
  
  subgraph hlos[HLOS]
    direction TB
    win[Windows]
    other_os[Other Operating Systems]
    android_distribution[Linux/Android Distributions]
  end

  bl --> start_shellcode --> check_memory
  check_memory -- False --> copy_fd
  check_memory -- True --> kernel
  kernel --> android_distribution
  copy_fd --> jump_stack_base --> uefi_program --> hlos
```

## Patch Kernel Data Structure
```mermaid
block-beta
  columns 3
  patched_kernel["Patched Kernel"]:3
  origin_kernel["Origin Kernel"]:2
  payload["PayLoad"]
  shell_code["Shell Code"]
  rest_kernel["Rest of Kernel"]
  fd["UEFI FD"]
```
