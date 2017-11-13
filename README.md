Add OpenMP for Apple Clang. Apple Clang now has support for OpenMP, but
it has been disabled in the driver and is not included with High Sierra.
It can be built and used, though; this formula will build it and
provides hints on the correct usage.

To use:

```bash
brew install CLIUtils/apple/libomp
```

This, by default, makes `omp.h` and `libomp.dylib` available in `/usr/local/*`, though you can always
`brew unlink libomp` if you want to.

There have been a few other formula in the past, such as clang-omp, that provided
special compilers and other tricks to add OpenMP. This is not like those; this is for
the built-in system Clang. On at least High Sierra, this is now possible due to the fact
that it is based on a version of Clang (4.0) that has OpenMP support; it's just not built and
included by Apple.

This is the message printed by the formula:

```
On Apple Clang, you need to add several options to use OpenMP's front end
instead of the standard driver option. This usually looks like:
  -Xpreprocessor -fopenmp -lomp

You might need to make sure the lib and include directories are discoverable if /usr/local is not searched:
  -L$(brew --prefix libomp)/lib -I$(brew --prefix libomp)/include

For CMake, the following will flags will cause the OpenMP::OpenMP_CXX target to be set up correctly:
  -DOpenMP_CXX_FLAGS="-Xpreprocessor -fopenmp -I$(brew --prefix libomp)/include" -DOpenMP_CXX_LIB_NAMES="omp" -DOpenMP_omp_LIBRARY=$(brew --prefix libomp)/lib/libomp.a

```
