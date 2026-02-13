# 定义
> 本文档将介绍 `Defines.dsc.inc` 中所有可用的定义

## **HAS_MLVM**  
  * 类型
    - 布尔值
  * 为什么要定义它？
    - 某些设备有 MLVM 区域，有些没有。
    - 如果设备启用了 MLVM，MLVM 区域将被保护，并且不可读写。
  * 当为 **1** 时会发生什么？
    - 如果 `HAS_MLVM = TRUE`，MLVM 区域将被保留，因此 HLOS 不会使用此区域。
    - 总 RAM 大小将减少约 400MB。
  * 在哪里使用？
    - `HAS_MLVM` 在 `Platforms/AndromedaPkg/Driver/RamPartitionDxe/ExtendedMemoryMap.h` 中使用。

## **CUST_LOGO**  
  * 类型
    - 布尔值
  * 为什么要定义它？
    - 某些设备可能想要自己的标志。（即品牌的标志）
  * 当为 **1** 时会发生什么？
    - 启动标志将被替换为 `Device/$(brand-codename)/Include/Resources/CustBootLogo.bmp` 下的标志
  * 在哪里使用？
    - `CUST_LOGO` 在 `Platforms/AndromedaPkg/Frontpage.fdf.inc` 中使用