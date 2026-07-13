#!/usr/bin/env bash

# AGC #

# Usage:  ./SbCertGen.sh
#         Edit the variables in the CONFIG section below before first use.

set -euo pipefail

###############################################################################
# CONFIG  — replace with your own values
###############################################################################
OutDir="./Certs"
OemName="Your Name"
OemCN="Your CN"
OemEmail="YourEmail@youremail.com"

# Key sizes (match the PowerShell script)
KEYLEN_CA=4096      # Root, CA, PCA, RootPK, KEK
KEYLEN_END=2048     # KMCI, UMCI, DRA

# Validity periods (days) — makecert defaults: authority ~ indefinite-ish, end ~ 1 yr
DAYS_CA=3650
DAYS_END=1095

###############################################################################
# Helpers
###############################################################################
RED='\033[0;31m'; GRN='\033[0;32m'; YLW='\033[0;33m'; RST='\033[0m'
status()  { printf "%b\n" "${RST}$*${RST}"; }
success() { printf "%b\n" "${GRN}$*${GRN}"; }
warn()    { printf "%b\n" "${YLW}Warning: $*${YLW}"; }

# Try to find openssl
if ! command -v openssl >/dev/null 2>&1; then
    printf "%b\n" "${RED}ERROR: openssl not found. Please install openssl and try again.${RST}"
    exit 1
fi

mkdir -p "$OutDir/private"

# --- Per-certificate PFX export password (mirrors pvk2pfx.exe prompt) --------
# Each certificate has its OWN PFX password, prompted independently when the
# PFX is about to be written (consistent with pvk2pfx.exe under Windows).
# Pressing Enter without typing anything -> empty password (no protection).
# Otherwise the password must be entered twice for confirmation.
#
# Usage:   ask_pfx_password "<cert name>"   ; local pass="$CUR_PFX_PASS"
# Returns: 0 always. Sets the global CUR_PFX_PASS to the user's input.
ask_pfx_password() {
    local base="$1"
    local pass pass_confirm

    printf "Set PFX export password for '%s' (leave empty for no password): " "$base"
    if [[ -t 0 ]]; then
        read -rs pass
    else
        read -r pass
    fi
    printf "\n"

    if [[ -z "$pass" ]]; then
        printf "(no password)\n"
        export CUR_PFX_PASS=""
        return
    fi

    printf "Confirm PFX export password for '%s': " "$base"
    if [[ -t 0 ]]; then
        read -rs pass_confirm
    else
        read -r pass_confirm
    fi
    printf "\n"

    if [[ "$pass" != "$pass_confirm" ]]; then
        printf "%b\n" "${RED}ERROR: passwords do not match. Aborting.${RST}"
        exit 1
    fi
    export CUR_PFX_PASS="$pass"
}

# OpenSSL CA database files (not strictly required since we use -CAcreateserial,
# but kept for parity with a CA-style setup).
: > "$OutDir/private/index.txt" 2>/dev/null || true
[ -f "$OutDir/private/serial" ]    || printf "01\n" > "$OutDir/private/serial"
[ -f "$OutDir/private/crlnumber" ] || printf "01\n" > "$OutDir/private/crlnumber"

# --- OpenSSL config snippets -----------------------------------------------
# A single config file with all the extension sections we need.
cat > "$OutDir/private/openssl.cnf" <<EOF
[ ca ]
default_ca = CA_default

[ CA_default ]
dir           = $OutDir/private
database      = \$dir/index.txt
serial        = \$dir/serial
crlnumber     = \$dir/crlnumber
new_certs_dir = \$dir
default_md    = sha256
policy        = policy_any
preserve      = yes

[ policy_any ]
commonName             = supplied
organizationName       = optional
organizationalUnitName = optional
emailAddress           = optional

[ req ]
distinguished_name  = req_dn
default_md          = sha256
prompt              = no

[ req_dn ]
EOF

# Extension sections appended to the config file.
cat >> "$OutDir/private/openssl.cnf" <<'EOF'

# ====== Extension sections ======

[v3_ca]
basicConstraints = critical, CA:TRUE
keyUsage = critical, keyCertSign, cRLSign
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always

[v3_end_codesign]
basicConstraints = CA:FALSE
keyUsage = critical, digitalSignature
extendedKeyUsage = codeSigning
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid

[v3_end_sign]
basicConstraints = CA:FALSE
keyUsage = critical, digitalSignature
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid

[v3_end_dra]
basicConstraints = CA:FALSE
keyUsage = critical, keyEncipherment
extendedKeyUsage = 1.3.6.1.4.1.311.67.1.2
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid
EOF

# Subject prefix builders
P="/CN="
EM="/E=$OemEmail"

###############################################################################
# Helper functions
###############################################################################

# gen_self_signed  <label> <subject> <keylen> [ext_section]
# Creates a self-signed CA cert:
#   $OutDir/$OemName-<label>.cer
#   $OutDir/private/$OemName-<label>.pfx
# Plus transient .key / .csr in $OutDir/private (removed at the end).
gen_self_signed() {
    local label="$1" subject="$2" keylen="$3" ext="${4:-}"

    local base="$OemName-$label"
    local key="$OutDir/private/$base.key"
    local csr="$OutDir/private/$base.csr"
    local cer="$OutDir/$base.cer"
    local pfx="$OutDir/private/$base.pfx"

    if [[ -f "$pfx" ]]; then
        warn "$base.pfx already exists, skipping."
        return 0
    fi

    status "Creating $base (self-signed, keylen=$keylen)"
    openssl genrsa -out "$key" "$keylen" 2>/dev/null

    # Build a CSR first, then sign it with its own key as a self-signed cert.
    # This lets us attach -extfile extensions reliably across OpenSSL versions.
    openssl req -new -key "$key" -out "$csr" -sha256 \
        -subj "$subject" -config "$OutDir/private/openssl.cnf" 2>/dev/null

    local args=(-req -in "$csr" -signkey "$key" -days "$DAYS_CA" -sha256)
    if [[ -n "$ext" ]]; then
        args+=(-extfile "$OutDir/private/openssl.cnf" -extensions "$ext")
    fi
    # Emit the signed cert as a PEM file kept at private/$base.pem (so it can be
    # used as the issuer for child certs in the same run), and convert to DER (.cer).
    local pem="$OutDir/private/$base.pem"
    openssl x509 "${args[@]}" -out "$pem" 2>/dev/null
    openssl x509 -in "$pem" -outform DER -out "$cer" 2>/dev/null

    # Each PFX gets its own password (independent prompt, mirroring pvk2pfx.exe).
    ask_pfx_password "$base"
    openssl pkcs12 -export -out "$pfx" -inkey "$key" -in "$pem" \
        -name "$base" -passout env:CUR_PFX_PASS 2>/dev/null
    CUR_PFX_PASS=""   # clear as soon as possible

    rm -f "$csr"
}

# gen_signed  <label> <subject> <keylen> <issuer_label> <ext_section> [days]
# Creates a cert signed by $OemName-<issuer_label>:
#   $OutDir/$OemName-<label>.cer
#   $OutDir/private/$OemName-<label>.pfx
gen_signed() {
    local label="$1" subject="$2" keylen="$3" issuer_label="$4" ext="${5:-}"
    local days="${6:-$DAYS_END}"

    local base="$OemName-$label"
    local key="$OutDir/private/$base.key"
    local csr="$OutDir/private/$base.csr"
    local cer="$OutDir/$base.cer"
    local pfx="$OutDir/private/$base.pfx"

    local ibase="$OemName-$issuer_label"
    local ikey="$OutDir/private/$ibase.key"
    local issuer_pem="$OutDir/private/$ibase.pem"

    if [[ -f "$pfx" ]]; then
        warn "$base.pfx already exists, skipping."
        return 0
    fi

    status "Creating $base (signed by $ibase, keylen=$keylen)"

    # 1. Generate subject key + CSR
    openssl genrsa -out "$key" "$keylen" 2>/dev/null
    openssl req -new -key "$key" -out "$csr" -sha256 \
        -subj "$subject" -config "$OutDir/private/openssl.cnf" 2>/dev/null

    # 2. Sign CSR with issuer key/cert.
    # The issuer's PEM cert lives at $issuer_pem (kept by gen_self_signed /
    # a previous gen_signed for chain-of-trust signing).
    # Output to an independent temp PEM ($pem_out) for this subject.
    local pem_out="$OutDir/private/$base.pem"
    local args=(-req -CA "$issuer_pem" -CAkey "$ikey" -CAcreateserial \
                -days "$days" -sha256 -in "$csr" -out "$pem_out")
    if [[ -n "$ext" ]]; then
        args+=(-extfile "$OutDir/private/openssl.cnf" -extensions "$ext")
    fi
    openssl x509 "${args[@]}" 2>/dev/null
    openssl x509 -in "$pem_out" -outform DER -out "$cer" 2>/dev/null

    # Each PFX gets its own password (independent prompt, mirroring pvk2pfx.exe).
    ask_pfx_password "$base"
    openssl pkcs12 -export -out "$pfx" -inkey "$key" \
        -in "$pem_out" -certfile "$issuer_pem" \
        -name "$base" -passout env:CUR_PFX_PASS 2>/dev/null
    CUR_PFX_PASS=""   # clear as soon as possible

    # $pem_out is kept (private/$base.pem) so child certs can be signed by it.
    rm -f "$csr"
}

###############################################################################
# 1. Root CA (self-signed)
###############################################################################
gen_self_signed "Root"    "${P}${OemCN} Root"                   "$KEYLEN_CA" v3_ca

###############################################################################
# 2. CA (signed by Root) — makecert used CA storage type (authority)
###############################################################################
gen_signed     "CA"       "${P}${OemCN} CA"                     "$KEYLEN_CA" Root   v3_ca "$DAYS_CA"

###############################################################################
# 3. PCA (signed by CA) — production intermediate CA
###############################################################################
PCA_YEAR=$(date +%Y)
gen_signed     "PCA"      "${P}${OemCN} Production PCA $PCA_YEAR" "$KEYLEN_CA" CA   v3_ca "$DAYS_CA"

###############################################################################
# 4. KMCI (signed by PCA) — Kernel-Mode Code Signing  (EKU 1.3.6.1.5.5.7.3.3)
###############################################################################
gen_signed     "KMCI"     "${P}${OemCN} KMCI Codesigning, $EM"  "$KEYLEN_END" PCA  v3_end_codesign "$DAYS_END"

###############################################################################
# 5. UMCI (signed by PCA) — User-Mode Code Signing  (EKU 1.3.6.1.5.5.7.3.3)
###############################################################################
gen_signed     "UMCI"     "${P}${OemCN} UMCI Codesigning, $EM"  "$KEYLEN_END" PCA  v3_end_codesign "$DAYS_END"

###############################################################################
# 6. RootPK (self-signed) — Platform Key root  (separate chain from KEK)
###############################################################################
gen_self_signed "RootPK"  "${P}${OemCN} Root Platform Key"      "$KEYLEN_CA" v3_ca

###############################################################################
# 7. KEK (signed by RootPK) — Key Exchange Key  (end-entity, signature only)
###############################################################################
gen_signed     "KEK"      "${P}${OemCN} KEK Secure Boot"        "$KEYLEN_CA" RootPK v3_end_sign "$DAYS_CA"

###############################################################################
# 8. DRA (signed by PCA) — BitLocker Data Recovery Agent
# EKU 1.3.6.1.4.1.311.67.1.2 + KeyEncipherment (exchange)
###############################################################################
gen_signed     "DRA"      "${P}${OemCN} Data Recovery Agent"    "$KEYLEN_END" PCA  v3_end_dra "$DAYS_END"

###############################################################################
# Cleanup — mirror the PowerShell script: remove private key (.pvk) files.
# Here we remove standalone private keys (.key), serial files (.srl), and
# the internal .pem certs used for chaining. The .pfx bundles already contain
# the private keys, so re-generation is still possible from .pfx if needed.
###############################################################################
rm -f "$OutDir"/*.srl 2>/dev/null || true
rm -f "$OutDir/private"/*.srl "$OutDir/private"/*.csr 2>/dev/null || true
rm -f "$OutDir/private/index.txt"* "$OutDir/private/serial"* \
      "$OutDir/private/crlnumber"* 2>/dev/null || true
rm -f "$OutDir/private/openssl.cnf" 2>/dev/null || true

# Remove standalone private keys after bundling — equivalent to deleting .pvk
# in the PowerShell script. Comment out this line if you want the raw PEM keys.
rm -f "$OutDir/private"/*.key 2>/dev/null || true
# Remove internal issuer .pem files (used for chaining, not part of public output).
rm -f "$OutDir/private"/*.pem 2>/dev/null || true

success "Certificates created. See $OutDir"
