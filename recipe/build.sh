#!/bin/bash

set -ex

# See https://github.com/conda-forge/rust-feedstock/blob/master/recipe/build.sh for cc env explanation

if [ "$c_compiler" = gcc ] ; then
    case "$BUILD" in
        x86_64-*) rust_env_arch=X86_64_UNKNOWN_LINUX_GNU ;;
        aarch64-*) rust_env_arch=AARCH64_UNKNOWN_LINUX_GNU ;;
        powerpc64le-*) rust_env_arch=POWERPC64LE_UNKNOWN_LINUX_GNU ;;
        *) echo "unknown BUILD $BUILD" ; exit 1 ;;
    esac

    export CARGO_TARGET_${rust_env_arch}_LINKER=$CC
fi

cd ${SRC_DIR}/rust-nightly
./install.sh --verbose --prefix=${SRC_DIR}/rust-nightly-install --disable-ldconfig --components=rustc,cargo,rust-std*
cd -

export PATH=${SRC_DIR}/rust-nightly-install/bin:$PATH

maturin build --no-sdist --release --strip --manylinux off --cargo-extra-args=-Zfeatures=itarget --interpreter="${PYTHON}"

"${PYTHON}" -m pip install $SRC_DIR/target/wheels/orjson*.whl --no-deps -vv
