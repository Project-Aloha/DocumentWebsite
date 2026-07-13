function New-DirIfNotExist ([string] $path, [switch]$force) {
    if (Test-Path $path) {
        if ($force) { 
            Remove-Item $path -Recurse -Force | Out-Null 
        }
        else { return }
    }
    New-Item $path -ItemType Directory | Out-Null
}

function Publish-Success() {
    Write-Host $args  -ForegroundColor Green
}
function Publish-Status () {
    Write-Host $args
}
function Publish-Warning ([string] $message) {
    if (($null -ne $host) -and ($null -ne $host.ui)){
        Write-Host "Warning: $message" -ForegroundColor Yellow
    }
    else {
        Write-Warning $message
    } 
}

###################### Global Var ################################
# Replace with your own sdk path!
$MakeCert = "E:\Windows Kits\10\bin\10.0.26100.0\x64\makecert.exe"
$pvkpfx = "E:\Windows Kits\10\bin\10.0.26100.0\x64\pvk2pfx.exe"

# Replace with your own info!
$outputDir = ".\Certs"
New-DirIfNotExist "$outputDir\private"
$OemName = "Your Name"
$OemCN = "Your CN"
$OemEmail="YourEmail@youremail.com"
###############################################################

$Root = "$outputDir\$OemName-Root"
$RootPri = "$outputDir\private\$OemName-Root"
$CA = "$outputDir\$OemName-CA"
$CAPri = "$outputDir\private\$OemName-CA"
$PCA = "$outputDir\$OemName-PCA"
$PCAPri = "$outputDir\private\$OemName-PCA"
$PK = "$outputDir\$OemName-RootPK"
$PKPri = "$outputDir\private\$OemName-RootPK"
$KEK = "$outputDir\$OemName-KEK"
$KEKPri = "$outputDir\private\$OemName-KEK"
$KMCI = "$outputDir\$OemName-KMCI"
$KMCIPri = "$outputDir\private\$OemName-KMCI"
$UMCI = "$outputDir\$OemName-UMCI"
$UMCIPri = "$outputDir\private\$OemName-UMCI"
$BitlockerDRA = "$outputDir\$OemName-DRA"
$BitlockerDRAPri = "$outputDir\private\$OemName-DRA"

$ReApply = Test-Path "$RootPri.pfx"
if ($ReApply -eq $False) {
    Publish-Status "Creating $RootPri.pfx"
    & $MakeCert -r -pe -n "CN=$OemCN Root" -ss CA -sr CurrentUser -a sha256 -len 4096 -cy authority -sky signature -sv "$RootPri.pvk" "$Root.cer"
    & $pvkpfx -pvk "$RootPri.pvk" -spc "$Root.cer" -pfx "$RootPri.pfx"
}

$ReApply = Test-Path "$CAPri.pfx"
if ($ReApply -eq $False) {
    Publish-Status "Creating $CAPri.pfx"
    & $MakeCert -pe -n "CN=$OemCN CA" -ss CA -sr CurrentUser -a sha256 -len 4096 -cy authority -sky signature -iv "$RootPri.pvk" -ic "$Root.cer" -sv "$CAPri.pvk" "$CA.cer"
    & $pvkpfx -pvk "$CAPri.pvk" -spc "$CA.cer" -pfx "$CAPri.pfx"
}

$ReApply = Test-Path "$PCAPri.pfx"
if ($ReApply -eq $False) {
    $year = Get-Date -Format "yyyy"
    Publish-Status "Creating $PCAPri.pfx"
    & $MakeCert -pe -n "CN=$OemCN Production PCA $year" -ss CA -sr CurrentUser -a sha256 -len 4096 -cy authority -sky signature -iv "$CAPri.pvk" -ic "$CA.cer" -sv "$PCAPri.pvk" "$PCA.cer"
    & $pvkpfx -pvk "$PCAPri.pvk" -spc "$PCA.cer" -pfx "$PCAPri.pfx"
}

$ReApply = Test-Path "$KMCIPri.pfx"
if ($ReApply -eq $False) {
    Publish-Status "Creating $KMCIPri.pfx"
    & $MakeCert -pe -n "CN=$OemCN KMCI Codesigning, E=$OemEmail" -sr CurrentUser -a sha256 -len 2048 -cy end -eku 1.3.6.1.5.5.7.3.3 -sky signature -iv "$PCAPri.pvk" -ic "$PCA.cer" -sv "$KMCIPri.pvk" "$KMCI.cer"
    & $pvkpfx -pvk "$KMCIPri.pvk" -spc "$KMCI.cer" -pfx "$KMCIPri.pfx"
}

$ReApply = Test-Path "$UMCIPri.pfx"
if ($ReApply -eq $False) {
    Publish-Status "Creating $UMCIPri.pfx"
    & $MakeCert -pe -n "CN=$OemCN UMCI Codesigning, E=$OemEmail" -sr CurrentUser -a sha256 -len 2048 -cy end -eku 1.3.6.1.5.5.7.3.3 -sky signature -iv "$PCAPri.pvk" -ic "$PCA.cer" -sv "$UMCIPri.pvk" "$UMCI.cer"
    & $pvkpfx -pvk "$UMCIPri.pvk" -spc "$UMCI.cer" -pfx "$UMCIPri.pfx"
}

#Making PK a root cert
$ReApply = Test-Path "$PKPri.pfx"
if ($ReApply -eq $False) {
    Publish-Status "Creating $PKPri.pfx"
    & $MakeCert -r -pe -n "CN=$OemCN Root Platform Key" -ss CA -sr CurrentUser -a sha256 -len 4096 -cy authority -sky signature -sv "$PKPri.pvk"  "$PK.cer"
    & $pvkpfx -pvk "$PKPri.pvk" -spc "$PK.cer" -pfx "$PKPri.pfx"
}

#KEK is derived out of PK instead of PCA
$ReApply = Test-Path "$KEKPri.pfx"
if ($ReApply -eq $False) {
    Publish-Status "Creating $KEKPri.pfx"
    & $MakeCert -pe -n "CN=$OemCN KEK Secure Boot" -sr CurrentUser -a sha256 -len 4096 -cy end -sky signature -iv "$PKPri.pvk" -ic "$PK.cer" -sv "$KEKPri.pvk"  "$KEK.cer"
    & $pvkpfx -pvk "$KEKPri.pvk" -spc "$KEK.cer" -pfx "$KEKPri.pfx"
}

$ReApply = Test-Path "$BitlockerDRAPri.pfx"
if ($ReApply -eq $False) {
    Publish-Status "Creating $BitlockerDRAPri.pfx"
    & $MakeCert -pe -n "CN=$OemCN Data Recovery Agent" -sr CurrentUser -a sha256 -len 2048 -cy end -eku 1.3.6.1.4.1.311.67.1.2 -sky exchange -iv "$PCAPri.pvk" -ic "$PCA.cer" -sv "$BitlockerDRAPri.pvk" "$BitlockerDRA.cer"
    & $pvkpfx -pvk "$BitlockerDRAPri.pvk" -spc "$BitlockerDRA.cer" -pfx "$BitlockerDRAPri.pfx"
}

Remove-Item "$outputDir\private\*.pvk" -Force
if ($ReApply) {
    Publish-Warning "Certificates already exist. See $outputDir"
}
else {
    Publish-Success "Certificates created. See $outputDir"
}