FOR /F "delims=" %%i in ('cygpath.exe -u "%SRC_DIR%\rust-nightly-install"') DO set "pfx=%%i"
bash %SRC_DIR%\rust-nightly\install.sh --verbose --prefix=%pfx% --disable-ldconfig
set PATH=%SRC_DIR%\rust-nightly-install\bin:%PATH%

echo "check cargo"
cargo --help

echo "check cargo.exe"
cargo.exe --help

maturin build --no-sdist --release --strip --manylinux off

%PYTHON% -m pip install . -vv
