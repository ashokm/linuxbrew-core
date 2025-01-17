class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.27.0.tar.gz"
  sha256 "fb800f3355f167ac7f997f77e31e331db9d33477779fdaaf2851b3abcecc801a"
  license "MIT"
  version_scheme 1
  head "https://github.com/dlang/dub.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "20c67d16147775d49407fae421cef74e323cef53dab0a663b562e9710cde031f"
    sha256 cellar: :any_skip_relocation, big_sur:       "522469719933702ba030cce31f83a4f19638e17945efce2786eaa6ab29b38d4b"
    sha256 cellar: :any_skip_relocation, catalina:      "a708c2b342b00718471ec8427e56f7d36f91d1029939469110ca830d0a961748"
    sha256 cellar: :any_skip_relocation, mojave:        "5da8b64546f9436fcc1210c7acf63a9f95a2c300b7eec8192610e3ec25d7c124"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2db86cb8961dcd8bd71e45a2dc0f729efe48bee337df58e19002d1705a2019d" # linuxbrew-core
  end

  depends_on "ldc" => :build
  depends_on "pkg-config"

  uses_from_macos "curl"

  def install
    ENV["GITVER"] = version.to_s
    system "ldc2", "-run", "./build.d"
    system "bin/dub", "scripts/man/gen_man.d"
    bin.install "bin/dub"
    man1.install Dir["scripts/man/*.1"]
    zsh_completion.install "scripts/zsh-completion/_dub"
    fish_completion.install "scripts/fish-completion/dub.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dub --version").split(/[ ,]/)[2]
  end
end
