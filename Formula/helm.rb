class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.7.1",
      revision: "1d11fcb5d3f3bf00dbe6fe31b8412839a96b3dc4"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3ff5c5ebf92f73bf50637c24d5579b7608aa3dc8618244b7389f061bfe4875f1"
    sha256 cellar: :any_skip_relocation, big_sur:       "f62c4a77bdf5f912129ed649222eb947fe4abe549163b44fe0d330ef736b6e33"
    sha256 cellar: :any_skip_relocation, catalina:      "9335a6f8906210e2b832e07e6702df4726ae67c42fc017ebebdaab386ba8de2d"
    sha256 cellar: :any_skip_relocation, mojave:        "85f1ddd0cfb9a20a927b1296a1df7a09081665d278893df62cb2ad7c4672a3f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecd1d24432ca3d27cb96d465980e83b0e0b1c299713f6954e32dfc55bce84dd2" # linuxbrew-core
  end

  depends_on "go" => :build

  def install
    # Don't dirty the git tree
    rm_rf ".brew_home"

    system "make", "build"
    bin.install "bin/helm"

    mkdir "man1" do
      system bin/"helm", "docs", "--type", "man"
      man1.install Dir["*"]
    end

    output = Utils.safe_popen_read(bin/"helm", "completion", "bash")
    (bash_completion/"helm").write output

    output = Utils.safe_popen_read(bin/"helm", "completion", "zsh")
    (zsh_completion/"_helm").write output

    output = Utils.safe_popen_read(bin/"helm", "completion", "fish")
    (fish_completion/"helm.fish").write output
  end

  test do
    system bin/"helm", "create", "foo"
    assert File.directory? testpath/"foo/charts"

    version_output = shell_output(bin/"helm version 2>&1")
    assert_match "GitTreeState:\"clean\"", version_output
    if build.stable?
      revision = stable.instance_variable_get(:@resource).instance_variable_get(:@specs)[:revision]
      assert_match "GitCommit:\"#{revision}\"", version_output
      assert_match "Version:\"v#{version}\"", version_output
    end
  end
end
