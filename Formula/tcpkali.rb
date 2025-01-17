class Tcpkali < Formula
  desc "High performance TCP and WebSocket load generator and sink"
  homepage "https://github.com/machinezone/tcpkali"
  url "https://github.com/machinezone/tcpkali/releases/download/v1.1.1/tcpkali-1.1.1.tar.gz"
  sha256 "a9a15a1703fc4960360a414ee282d821a7b42d4bbba89f9e72a796164ff69598"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7e7b45ed05cf7d7ad1dde75394b670e192c217cdfe98012e8da514cf6717d64a"
    sha256 cellar: :any_skip_relocation, big_sur:       "6496fe2ab336a75fecc905017ea8886c67dff3e13139b37474e6f500eb98e0fa"
    sha256 cellar: :any_skip_relocation, catalina:      "01bd403a6b94827f4670877d1e36ee4c439f708d84d364584e5b1538837e72d0"
    sha256 cellar: :any_skip_relocation, mojave:        "3e9bbcb12b289d1dff3c2355664208ee0a65cea032ebe1dc0d6d1346f67c1a2f"
    sha256 cellar: :any_skip_relocation, high_sierra:   "b82b2ea3a3d17d3fd464a5e887c9cce14dce8a82bbcb350df5f7bd321893bfdb"
    sha256 cellar: :any_skip_relocation, sierra:        "f73513ed96b6436085e0941865f0cc4fd2ce1009a1d8770c740e8e97d5173cf1"
    sha256 cellar: :any_skip_relocation, el_capitan:    "2d0075b2fca885fb694660a3914362030be255c8e3dfed407bb8ca96c996bbf7"
    sha256 cellar: :any_skip_relocation, yosemite:      "71573c4926d086721c028e73d9812475fe3a58bd8313a43ef9c6a54918334760"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "ncurses"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "#{bin}/tcpkali", "-l1237", "-T0.5", "127.1:1237"
  end
end
