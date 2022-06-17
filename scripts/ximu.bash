#!/usr/bin/env bash
git clone https://github.com/mysablehats/x-IMU3-Software.git ximu3
apt update
apt install curl libudev-dev
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
export PATH=$HOME/.cargo/bin:$PATH
pushd ximu3/x-IMU3-API/Rust
cargo build --release
popd
cd ximu3
mkdir build
cd build
cmake ..
make
