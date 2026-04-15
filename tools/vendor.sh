#!/bin/sh -e

cd src/rust
cargo vendor

# Remove crates that are only needed for WASI targets and whose
# Cargo.toml requires features (edition2024) not available in older
# Cargo versions.  Cargo parses every vendored manifest even when the
# crate is never compiled, so keeping them breaks offline builds with
# Cargo < 1.85.
rm -rf vendor/wit-bindgen vendor/wasip2

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