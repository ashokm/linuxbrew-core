class ScalaAT211 < Formula
  desc "JVM-based programming language"
  homepage "https://www.scala-lang.org/"
  url "https://downloads.lightbend.com/scala/2.11.12/scala-2.11.12.tgz"
  mirror "https://downloads.typesafe.com/scala/2.11.12/scala-2.11.12.tgz"
  mirror "https://www.scala-lang.org/files/archive/scala-2.11.12.tgz"
  sha256 "b11d7d33699ca4f60bc3b2b6858fd953e3de2b8522c943f4cda4b674316196a8"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f2cd523e7746274f21c08e9cc4b4590a759186e44611ef25c43fe3812a526ec9" # linuxbrew-core
  end

  keg_only :versioned_formula

  deprecate! date: "2017-11-09", because: :unsupported

  depends_on arch: :x86_64 # openjdk@8 is not supported on ARM
  depends_on "openjdk@8"

  def install
    rm_f Dir["bin/*.bat"]
    doc.install Dir["doc/*"]
    share.install "man"
    libexec.install "bin", "lib"
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("1.8"))

    # Set up an IntelliJ compatible symlink farm in 'idea'
    idea = prefix/"idea"
    idea.install_symlink libexec/"src", libexec/"lib"
    idea.install_symlink doc => "doc"
  end

  test do
    file = testpath/"Test.scala"
    file.write <<~EOS
      object Test {
        def main(args: Array[String]) {
          println(s"${2 + 2}")
        }
      }
    EOS

    out = shell_output("#{bin}/scala -nc #{file}").strip

    assert_equal "4", out
  end
end
