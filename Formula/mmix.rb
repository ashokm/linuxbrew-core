class Mmix < Formula
  desc "64-bit RISC architecture designed by Donald Knuth"
  homepage "https://mmix.cs.hm.edu/"
  url "https://mmix.cs.hm.edu/src/mmix-20160804.tgz"
  sha256 "fad8e64fddf2d75cbcd5080616b47e11a2d292a428cdb0c12e579be680ecdee9"

  livecheck do
    url "https://mmix.cs.hm.edu/src/"
    regex(/href=.*?mmix[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "03a6468d729fc0ccddb6187c50b8f0318dedbe2bf613ef2e86e95aada83daeac"
    sha256 cellar: :any_skip_relocation, big_sur:       "fa0a9dd7f5ea9520ffd9c4682df2d754462a7b7e6d7b30bc8ea84f39903fa29e"
    sha256 cellar: :any_skip_relocation, catalina:      "ca577c8e313e25ce4b0ccdf1067a9fa1765b23a3f63b26905ad3aea044507ece"
    sha256 cellar: :any_skip_relocation, mojave:        "8b1cc6672a548ea1c3320ac4889e6b081792c3181fd4ecfc126ebe9c2fb18365"
    sha256 cellar: :any_skip_relocation, high_sierra:   "7bc054e2d244fe693b4ed5ef47c56e23ac4952b15ddc5de55d19150d4dc2bf30"
    sha256 cellar: :any_skip_relocation, sierra:        "b694920e61edf2dec094618910be78fcd4fbbcad22d4d37363555aad38ee0af0"
    sha256 cellar: :any_skip_relocation, el_capitan:    "c1e8e0d2d627b3ab2c2c68a8b358981dab07466c3c70f3a2e4df8557006deb92"
    sha256 cellar: :any_skip_relocation, yosemite:      "7675c2bc1253e4da2a126d52942449f71cabdd83c39874403d449b5a05ceb145"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5f86dd7a3adf348bd5738818a343121e697f16c28a2d161b20d47aca5e997a5" # linuxbrew-core
  end

  depends_on "cweb" => :build

  def install
    ENV.deparallelize
    system "make", "all"
    bin.install "mmix", "mmixal", "mmmix", "mmotype"
  end

  test do
    (testpath/"hello.mms").write <<~EOS
            LOC  Data_Segment
            GREG @
      txt   BYTE "Hello world!",0

            LOC #100

      Main  LDA $255,txt
            TRAP 0,Fputs,StdOut
            TRAP 0,Fputs,StdErr
            TRAP 0,Halt,0
    EOS
    system bin/"mmixal", "hello.mms"
    assert_equal "Hello world!", shell_output("#{bin}/mmix hello.mmo")
  end
end
