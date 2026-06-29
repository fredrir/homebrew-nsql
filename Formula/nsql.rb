class Nsql < Formula
  depends_on "dbus" if OS.linux?
  desc "Run SQL from your terminal, composed in your real neovim — without taking over the screen."
  homepage "https://github.com/fredrir/nsql"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/fredrir/nsql/releases/download/v0.1.2/nsql-aarch64-apple-darwin.tar.xz"
      sha256 "e8bad38c13c35201b1b7a0a82f6e066cff37f5275e836621163c763fd3a3e160"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fredrir/nsql/releases/download/v0.1.2/nsql-x86_64-apple-darwin.tar.xz"
      sha256 "62b07a336d4b9e4ddfd8e7ab91305e207b4ae50c8877cff50ff81a0d6fd6f39a"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/fredrir/nsql/releases/download/v0.1.2/nsql-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "412337d56d7b2fa390fe2ce2d1f8ab5ec7fcfc93a4ef42cff84726df3a78b1e0"
  end
  license "0BSD"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-unknown-linux-gnu": {},
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
