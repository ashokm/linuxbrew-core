class Fcl < Formula
  desc "Flexible Collision Library"
  homepage "https://flexible-collision-library.github.io/"
  url "https://github.com/flexible-collision-library/fcl/archive/0.7.0.tar.gz"
  sha256 "90409e940b24045987506a6b239424a4222e2daf648c86dd146cbcb692ebdcbc"
  license "BSD-3-Clause"
  head "https://github.com/flexible-collision-library/fcl.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "d2054fa4adf473a736ee945e0a1817772a77b423c1fbd314f7ced016ad616760"
    sha256 cellar: :any,                 big_sur:       "211e57fdf880e25e2441be78170dd1433d746aee1bb9a98990479abc2037a546"
    sha256 cellar: :any,                 catalina:      "2bac88b84304ad8de56bbf604f7466ee147c31e04484df02ff45ef4aa9c966cc"
    sha256 cellar: :any,                 mojave:        "095c6887a9007ec034751d8326fa7f5052180b78605d5df92223e081a17cad3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b22e0587c205f53be958cc43c4e2aa1597b61408bfeaf016197ffae8759816f4" # linuxbrew-core
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "libccd"
  depends_on "octomap"

  def install
    ENV.cxx11
    system "cmake", ".", "-DBUILD_TESTING=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <fcl/geometry/shape/box.h>
      #include <cassert>

      int main() {
        assert(fcl::Boxd(1, 1, 1).computeVolume() == 1);
      }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}",
                    "-I#{Formula["eigen"].include}/eigen3",
                    "-L#{lib}", "-lfcl", "-o", "test"
    system "./test"
  end
end
