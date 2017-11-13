class Libomp < Formula
  desc "Adds OpenMP libraries to use with the system Clang on macOS"
  homepage "https://openmp.llvm.org"
  url "https://releases.llvm.org/4.0.1/openmp-4.0.1.src.tar.xz"
  sha256 "ec693b170e0600daa7b372240a06e66341ace790d89eaf4a843e8d56d5f4ada4"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  def caveats; <<~EOS
    On Apple Clang, you need to add several options to use OpenMP's front end
    instead of the standard driver option. This usually looks like:
      -Xpreprocessor -fopenmp -lomp
    You might need to make sure the lib and include directories are discoverable if #{HOMEBREW_PREFIX} is not searched:
      -L#{lib} -I#{include}
    For CMake, the following will flags will cause the OpenMP::OpenMP_CXX target to be set up correctly:
      -DOpenMP_CXX_FLAGS="-Xpreprocessor -fopenmp -I#{include}" -DOpenMP_CXX_LIB_NAMES="omp" -DOpenMP_omp_LIBRARY=#{lib}/libomp.dylib
    EOS
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <omp.h>
      int main (int argc, char** argv) {
        int nthreads, tid;
        #pragma omp parallel private(nthreads, tid)
        {
            tid = omp_get_thread_num();
        }
        return 0;
      }
      EOS
    system ENV.cc, "-Xpreprocessor", "-fopenmp", "test.c", "-L#{lib}", "-lomp", "-o", "test"
    system "./test"
  end
end
