#!/bin/sh -e

cd src/rust
cargo vendor

# wit-bindgen uses edition 2024, which Cargo < 1.85 cannot parse.
# Since it is never compiled for our targets (only needed for WASI),
# we patch it to edition 2021 so older Cargo can read the manifest.
sed -i.bak 's/^edition = "2024"/edition = "2021"/' vendor/wit-bindgen/Cargo.toml
rm -f vendor/wit-bindgen/Cargo.toml.bak

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