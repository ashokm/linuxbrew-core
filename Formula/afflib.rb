class Afflib < Formula
  desc "Advanced Forensic Format"
  homepage "https://github.com/sshock/AFFLIBv3"
  url "https://github.com/sshock/AFFLIBv3/archive/v3.7.19.tar.gz"
  sha256 "d358b07153dd08df3f35376bab0202c6103808686bab5e8486c78a18b24e2665"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "aa8dd52d5800f5ac0464a37b9f456ea830c62ae8a2775373f330ab7d8253bacc"
    sha256 cellar: :any,                 big_sur:       "d5502071af61c4768c056d6ac7d3f7d1048044e9290b7a3823350b7df05a1e86"
    sha256 cellar: :any,                 catalina:      "6662001d7ea73f9ec2f36bf94937c84581254ca4637a07d6a696116314a438bb"
    sha256 cellar: :any,                 mojave:        "360c80c6323ff67028b0154508967eaa5b426675892147ca2d70bb11ce273d9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92883b6dc67597bb281feffb19f9d4ab4397ed63b5917bcb89104f097f5c49ce" # linuxbrew-core
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.10"

  uses_from_macos "curl"
  uses_from_macos "expat"

  # Fix for Python 3.9, remove in next version
  patch do
    url "https://github.com/sshock/AFFLIBv3/commit/aeb444da.patch?full_index=1"
    sha256 "90cbb0b55a6e273df986b306d20e0cfb77a263cb85e272e01f1b0d8ee8bd37a0"
  end

  def install
    ENV["PYTHON"] = Formula["python@3.10"].opt_bin/"python3"

    args = %w[
      --enable-s3
      --enable-python
      --disable-fuse
    ]

    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          *args
    system "make", "install"
  end

  test do
    system "#{bin}/affcat", "-v"
  end
end
