# typed: strict
# frozen_string_literal: true

# Homebrew package for the Starshot macOS command-line client.
class Starshot < Formula
  desc "Screenshot uploader for humans and automation"
  homepage "https://github.com/rockstarsunlimited/starshot"
  url "https://github.com/rockstarsunlimited/starshot/releases/download/v0.2.3/starshot-macos.zip"
  version "0.2.3"
  sha256 "c7c186f94288c563361f33ce9444204ca9921de3b13033373180b3846bdfb04e"
  license "MIT"

  depends_on "bun"
  depends_on :macos

  def install
    libexec.install Dir["*"]
    libexec.install ".env.schema"
    (bin/"starshot").write <<~SH
      #!/bin/sh
      export STARSHOT_EXECUTABLE="$0"
      exec "#{formula_opt_bin("bun")}/bun" "#{libexec}/bin/starshot.ts" "$@"
    SH
    bin.install_symlink libexec/"bin/starshot-native" => "starshot-native"
  end

  def caveats
    <<~EOS
      Run `starshot setup` to configure your uploader, then `starshot install`
      to install the Finder Quick Action.
    EOS
  end

  test do
    assert_match "Starshot", shell_output("#{bin}/starshot --help")
  end
end
