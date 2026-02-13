# Definitions
> This Doc will introduce all definitions available in `Defines.dsc.inc`

## **HAS_MLVM**  
  * Type
    - Boolean
  * Why define it ?
    - Some devices have MLVM region, some do not.
    - If the device has MLVM enabled, MLVM regions will be protected, and they'll be un-readable and un-writeable.
  * What happened when **1**?
    - If `HAS_MLVM = TRUE`, the MLVM regions will be reserved, so HLOS will not use this region.
    - Total RAM size will decrease about 400MB.
  * Where used it ?
    - `HAS_MLVM` is used in `Platforms/AndromedaPkg/Driver/RamPartitionDxe/ExtendedMemoryMap.h`.

## **CUST_LOGO**  
  * Type
    - Boolean
  * Why define it ?
    - Some Device may want it's own logo. (i.e. Brand's Logo)
  * What happened when **1**?
    - The Boot Logo will be replaced with the one under `Device/$(brand-codename)/Include/Resources/CustBootLogo.bmp`
  * Where used it ?
    - `CUST_LOGO` is used in `Platforms/AndromedaPkg/Frontpage.fdf.inc`