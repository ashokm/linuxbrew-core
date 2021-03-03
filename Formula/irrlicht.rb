class Irrlicht < Formula
  desc "Realtime 3D engine"
  homepage "https://irrlicht.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/irrlicht/Irrlicht%20SDK/1.8/1.8.4/irrlicht-1.8.4.zip"
  sha256 "f42b280bc608e545b820206fe2a999c55f290de5c7509a02bdbeeccc1bf9e433"
  head "https://svn.code.sf.net/p/irrlicht/code/trunk"

  livecheck do
    url :stable
    regex(%r{url=.*?/irrlicht[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, big_sur:     "611abae20f145f6026ddb16b24564fd11599f7ca7e4f59b0971b3b2304fad466"
    sha256 cellar: :any_skip_relocation, catalina:    "665031602d338528055bfb7dba5c1a4c94c0deaea6c3db8d4d4cddb061a54e7d"
    sha256 cellar: :any_skip_relocation, mojave:      "e5b9b3d8b58f26c138b9dcd421fad9769e6ab7833bbf668cdeac909fd204a601"
    sha256 cellar: :any_skip_relocation, high_sierra: "508d300a52f1f1d5b1d5193f07559ca3da5aa3286181ae88b415bf5468c521bc"
    sha256 cellar: :any_skip_relocation, sierra:      "d2236f351b11847d960909fa0e96d83ab0448228de30cd21014fea47a2c636a5"
  end

  depends_on xcode: :build

  on_linux do
    depends_on "libx11"
    depends_on "libxxf86vm"
    depends_on "mesa"
  end

  def install
    on_macos do
      # Fix "error: cannot initialize a parameter of type
      # 'id<NSApplicationDelegate> _Nullable' with an rvalue of type
      # 'id<NSFileManagerDelegate>'"
      # Reported 5 Oct 2016 https://irrlicht.sourceforge.io/forum/viewtopic.php?f=7&t=51562
      inreplace "source/Irrlicht/MacOSX/CIrrDeviceMacOSX.mm",
        "[NSApp setDelegate:(id<NSFileManagerDelegate>)",
        "[NSApp setDelegate:(id<NSApplicationDelegate>)"

      # Fix "error: ZLIB_VERNUM != PNG_ZLIB_VERNUM" on Mojave (picking up system zlib)
      # Reported 21 Oct 2018 https://sourceforge.net/p/irrlicht/bugs/442/
      inreplace "source/Irrlicht/libpng/pngpriv.h",
        "#  error ZLIB_VERNUM != PNG_ZLIB_VERNUM \\",
        "#  warning ZLIB_VERNUM != PNG_ZLIB_VERNUM \\"

      xcodebuild "-project", "source/Irrlicht/MacOSX/MacOSX.xcodeproj",
                 "-configuration", "Release",
                 "-target", "libIrrlicht.a",
                 "SYMROOT=build"
      lib.install "source/Irrlicht/MacOSX/build/Release/libIrrlicht.a"
      include.install "include" => "irrlicht"
    end

    on_linux do
      cd "source/Irrlicht" do
        inreplace "Makefile" do |s|
          s.gsub! "/usr/X11R6/lib$(LIBSELECT)", Formula["libx11"].opt_lib
          s.gsub! "/usr/X11R6/include", Formula["libx11"].opt_include
        end
        ENV.append "LDFLAGS", "-L#{Formula["mesa"].opt_lib}"
        ENV.append "LDFLAGS", "-L#{Formula["libxxf86vm"].opt_lib}"
        ENV.append "CXXFLAGS", "-I#{Formula["libxxf86vm"].opt_include}"
        system "make", "sharedlib", "NDEBUG=1"
        system "make", "install", "INSTALL_DIR=#{lib}"
        system "make", "clean"
        system "make", "staticlib", "NDEBUG=1"
      end
      lib.install "lib/Linux/libIrrlicht.a"
    end

    (pkgshare/"examples").install "examples/01.HelloWorld"
  end

  test do
    on_macos do
      assert_match "x86_64", shell_output("lipo -info #{lib}/libIrrlicht.a")
    end

    cp_r Dir["#{pkgshare}/examples/01.HelloWorld/*"], testpath
    system ENV.cxx, "-I#{include}/irrlicht", "-L#{lib}", "-lIrrlicht", "main.cpp", "-o", "hello"
  end
end
