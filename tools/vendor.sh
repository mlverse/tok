#!/bin/sh -e

cd src/rust
cargo vendor

# c.f. https://reproducible-builds.org/docs/archives/
# --no-xattrs and COPYFILE_DISABLE prevent macOS extended attributes
# (e.g. com.apple.provenance) from being stored in the archive, which
# would cause warnings when extracted with GNU tar on Linux.
COPYFILE_DISABLE=1 tar \
  --xz \
  --create \
  --no-xattrs \
  --file=vendor.tar.xz \
  vendor

echo
echo
echo "#############################################"
echo "#                                           #"
echo "#  UPDATE src/cargo_vendor_config.toml !!!  #"
echo "#                                           #"
echo "#############################################"