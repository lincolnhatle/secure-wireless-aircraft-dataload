#!/bin/bash
set -e

# =============================================================================
# ARINC 615A Raspberry Pi 5 Dependency Setup (Stable Trixie Version)
# =============================================================================

# 1. Root Check
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root: sudo ./setup_rpi_env.sh"
  exit 1
fi

echo ">> Updating package lists..."
apt-get update

# 2. Define Dependencies
# We use standard Debian package names here to ensure compatibility.

DOCS=( doxygen graphviz asciidoc asciidoc-fop asciidoctor ruby-asciidoctor-pdf texlive-base texinfo )

TOOLS=( build-essential cmake ninja-build make git pkg-config ccache bison flex curl iproute2 net-tools less gpg )

LLVM=( clang clang-format clang-tidy libomp-dev lld lldb iwyu afl++ libc++-dev )

# 'libboost-all-dev' will grab the best version compatible with your OS automatically
# WE NEED BOOST 1.88 BUT DEBIAN MAXES AT 1.83
LIBS=( 
    bzip2 libbz2-dev 
    libxml++2.6-dev libxerces-c-dev 
    libspdlog-dev libssl-dev libmbedtls-dev libwolfssl-dev 
    libbotan-3-dev botan 
    libpugixml-dev 
    libgmp-dev libmpc-dev libmpfr-dev
    #libboost-all-dev
    libboost1.88-all-dev # apt may be unable to find it
    libfmt-dev
)

QT=( qt6-base-dev qt6-svg-dev qt6-documentation-tools )

MINGW=( binutils-mingw-w64 mingw-w64 mingw-w64-tools )

# 3. Install
echo ">> Installing dependencies..."
# We utilize standard repositories to avoid dependency conflicts (libxml2/libnl errors)
apt-get --no-install-recommends install \
    "${DOCS[@]}" "${TOOLS[@]}" "${LLVM[@]}" "${LIBS[@]}" "${QT[@]}" "${MINGW[@]}"

echo ">> Verifying critical installations..."
cmake --version | head -n 1
# Check which version of Boost was actually installed
dpkg -s libboost-dev | grep Version

echo ">> Setup Complete!"
