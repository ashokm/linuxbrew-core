class Avce00 < Formula
  desc "Make Arc/Info (binary) Vector Coverages appear as E00"
  homepage "http://avce00.maptools.org/avce00/index.html"
  url "http://avce00.maptools.org/dl/avce00-2.0.0.tar.gz"
  sha256 "c0851f86b4cd414d6150a04820491024fb6248b52ca5c7bd1ca3d2a0f9946a40"

  livecheck do
    url :homepage
    regex(/href=.*?avce00[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9c4e10ddc6cad4b6a7001a697b8318513a09166e70fa6831ed5fdbede1e71d47"
    sha256 cellar: :any_skip_relocation, big_sur:       "1fdd45d6a401ca88019bbd58cb3afdda23dedf706c4556e87a7cc48b1a3e952a"
    sha256 cellar: :any_skip_relocation, catalina:      "db71ee14a03d041413530c0974ce7703100dc3259fc0d2ea5a32fadcf7180133"
    sha256 cellar: :any_skip_relocation, mojave:        "285b4eb74ff189689097df36f62fa4c2a48b68ece7442156a5700b6c36feb743"
    sha256 cellar: :any_skip_relocation, high_sierra:   "40b26638adfaf290bc07ae792da49106b493ea3109a97c1fac775723a0463ac4"
    sha256 cellar: :any_skip_relocation, sierra:        "576b5ea62376b42733d56e7bd862522588c16160ac1abb5f382c1c12055248e1"
    sha256 cellar: :any_skip_relocation, el_capitan:    "45f18e289431af4de0d1e96c1fadd6a056e80907a1650654f8ee0dd1dafab401"
    sha256 cellar: :any_skip_relocation, yosemite:      "56e15b29411b2947d9a842d91ae713e16566aa59e297e06f7d4de4b301847e66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00d468662055c9c9ab55d2860e8b812505e0e5aafac1a94aec57b6e9e8f8287e" # linuxbrew-core
  end

  conflicts_with "gdal", because: "both install a cpl_conv.h header"

  def install
    system "make", "CC=#{ENV.cc}"
    bin.install "avcimport", "avcexport", "avcdelete", "avctest"
    lib.install "avc.a"
    include.install Dir["*.h"]
  end

  test do
    touch testpath/"test"
    system "#{bin}/avctest", "-b", "test"
  end
end
