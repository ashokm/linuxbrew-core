class BpmTools < Formula
  desc "Detect tempo of audio files using beats-per-minute (BPM)"
  homepage "https://www.pogo.org.uk/~mark/bpm-tools/"
  url "https://www.pogo.org.uk/~mark/bpm-tools/releases/bpm-tools-0.3.tar.gz"
  sha256 "37efe81ef594e9df17763e0a6fc29617769df12dfab6358f5e910d88f4723b94"
  license "GPL-2.0"
  head "https://www.pogo.org.uk/~mark/bpm-tools.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "19d555332dffb4fbcc6a80f15c3aa7692594b5c75fb3e01a9da6f0878fc5a98b"
    sha256 cellar: :any_skip_relocation, big_sur:       "6ad965195d96e6d9f1b01732b1314af6211b101a6113aab02c9fbf799f3ded1d"
    sha256 cellar: :any_skip_relocation, catalina:      "694afec7c21549badc5c2bf55ac3f3da588370affbaa78f1087e3bb204137f61"
    sha256 cellar: :any_skip_relocation, mojave:        "56e3a889338b82d5b477c1564506e23549d9651b08260d9c9a38b5e6bd1555ab"
    sha256 cellar: :any_skip_relocation, high_sierra:   "422342ce8dd8a50853e8289ccc936747f4a77a20803850e6481498cf8c4a12c5"
    sha256 cellar: :any_skip_relocation, sierra:        "f1219d522f61e89606f3e607a636e406faf5f954846b48965e37cc25dbb29b87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20c8a421d7c78aa0c0eec565f1a5584218910bd55c366ad06c865198b8a0a315" # linuxbrew-core
  end

  def install
    system "make"
    bin.install "bpm"
    bin.install "bpm-tag"
  end
end
