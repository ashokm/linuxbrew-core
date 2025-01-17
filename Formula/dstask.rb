class Dstask < Formula
  desc "Git-powered personal task tracker"
  homepage "https://github.com/naggie/dstask"
  url "https://github.com/naggie/dstask/archive/v0.25.tar.gz"
  sha256 "7a8b4e9d2d3ce6a59551fa181201148a008c35505d43593f80b1fe80493fdb8c"
  license "MIT"
  head "https://github.com/naggie/dstask.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c4b84546f5c35f4bf4bed658a73ad1dd562cd4fa2340e9bf48cb6af55f2d8b55"
    sha256 cellar: :any_skip_relocation, big_sur:       "b1976a39a056f8bef4d354afefcc427c4612527fb578b56734fbfa8432cc6e25"
    sha256 cellar: :any_skip_relocation, catalina:      "6db5f204f382f928f3890e5983f4c8531172080f3a90068a0b521435c7860e0b"
    sha256 cellar: :any_skip_relocation, mojave:        "fbcb9d73ddf2619094cd64478112c73eb384a8d839a72aae3f16833087d3973c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d666d285f3ddab4b90ed5baae31eff8a7729cc3d952f8774a05071d34ccb653" # linuxbrew-core
  end

  depends_on "go" => :build

  def install
    system "go", "mod", "vendor"
    system "make", "dist/dstask"
    bin.install Dir["dist/*"]
  end

  test do
    mkdir ".dstask" do
      system "git", "init"
      system "git", "config", "user.name", "BrewTestBot"
      system "git", "config", "user.email", "BrewTestBot@test.com"
    end

    system bin/"dstask", "add", "Brew the brew"
    system bin/"dstask", "start", "1"
    output = shell_output("#{bin}/dstask show-active")
    assert_match "Brew the brew", output
    system bin/"dstask", "done", "1"
  end
end
