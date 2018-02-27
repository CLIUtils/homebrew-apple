class Libomp < Formula
  desc "Adds OpenMP libraries to use with the system Clang on macOS"
  homepage "https://openmp.llvm.org"
  url "https://releases.llvm.org/5.0.1/openmp-5.0.1.src.tar.xz"
  sha256 "adb635cdd2f9f828351b1e13d892480c657fb12500e69c70e007bddf0fca2653"

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
    (testpath/"test.cpp").write <<~EOS
      #include <omp.h>
      #include <array>
      int main (int argc, char** argv) {
        std::array<size_t,2> arr = {0,0};
        #pragma omp parallel num_threads(2)
        {
            size_t tid = omp_get_thread_num();
            arr.at(tid) = tid + 1;
        }
        if(arr.at(0) == 1 && arr.at(1) == 2)
            return 0;
        else
            return 1;
      }
      EOS
    system ENV.cxx, "-Werror", "-Xpreprocessor", "-fopenmp", "test.cpp", "-L#{lib}", "-lomp", "-o", "testout"
    system "./testout"
  end
end
