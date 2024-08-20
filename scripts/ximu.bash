#!/usr/bin/env bash
git clone https://github.com/mysablehats/x-IMU3-Software.git ximu3
apt update
apt install curl libudev-dev -y
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
export PATH=$HOME/.cargo/bin:$PATH
pushd ximu3/x-IMU3-API/Rust
cargo build --release
# actually from here all we care about is the library which is at
# /ximu3/x-IMU3-API/Rust/target/release
#
# libximu3.a
#
mv /ximu3/x-IMU3-API/Rust/target/release/libximu3.a /ximu3
rm -rf /ximu3/x-IMU3-API/Rust
mkdir -p /ximu3/x-IMU3-API/Rust/target/release
cp /ximu3/libximu3.a /ximu3/x-IMU3-API/Rust/target/release

# I don't know if I need this, but it is too big and it has got to go.
popd
cd ximu3
mkdir build
cd build
cmake ..
# this is all we care about.
make Cpp-Examples
rm -rf /ximu3/build/_deps
#maybe removing this will break things, I am not sure I care
