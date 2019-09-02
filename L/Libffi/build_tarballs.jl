using BinaryBuilder

name = "Libffi"
version = v"3.2.1"

# Collection of sources required to build libffi
sources = [
    "https://sourceware.org/pub/libffi/libffi-$(version).tar.gz" =>
    "d06ebb8e1d9a22d19e38d63fdb83954253f39bedc5d46232a05645685722ca37",
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir/libffi-*/
./configure --prefix=$prefix --host=$target
make -j${nproc}
make install
if [[ -d ${prefix}/lib64 ]]; then
    for f in ${prefix}/lib64/*.${dlext}; do
        fbase="$(basename "${f}")"
        ln -s "../lib64/${fbase}" "${prefix}/lib/${fbase}"
    done
fi
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = supported_platforms()

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libffi", :libffi)
]

# Dependencies that must be installed before this package can be built
dependencies = [
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)
