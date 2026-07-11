class Nsql < Formula
  depends_on "dbus" if OS.linux?
  desc "Run SQL from your terminal, composed in your real neovim — without taking over the screen."
  homepage "https://github.com/fredrir/nsql"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/fredrir/nsql/releases/download/v0.1.5/nsql-aarch64-apple-darwin.tar.xz"
      sha256 "27155f97057d5578ebcfda6c3486494ad1cce39dd3ab778befe72a269010fa38"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fredrir/nsql/releases/download/v0.1.5/nsql-x86_64-apple-darwin.tar.xz"
      sha256 "ccedcfece9cd01b98c8c00e3dfd2296dc4ea44171bacb7e23c440a43385e7395"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/fredrir/nsql/releases/download/v0.1.5/nsql-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ba6dee12f1b705efb2bf97da912b4d037d0d6f9fffc0dc7c60e1bc15bbcaabb3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fredrir/nsql/releases/download/v0.1.5/nsql-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e531c28638f09e305eb3d444289092f44e691adf6e3a8a2ca9deade1d20b357b"
    end
  end
  license "0BSD"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "nsql" if OS.mac? && Hardware::CPU.arm?
    bin.install "nsql" if OS.mac? && Hardware::CPU.intel?
    bin.install "nsql" if OS.linux? && Hardware::CPU.arm?
    bin.install "nsql" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
