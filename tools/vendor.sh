#!/bin/sh -e

cd src/rust
cargo vendor

# c.f. https://reproducible-builds.org/docs/archives/
tar \
  --xz \
  --create \
  --file=vendor.tar.xz \
  vendor

echo
echo
echo "#############################################"
echo "#                                           #"
echo "#  UPDATE src/cargo_vendor_config.toml !!!  #"
echo "#                                           #"
echo "#############################################"