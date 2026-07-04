class Nsql < Formula
  desc "Run SQL from your terminal, composed in your real neovim — without taking over the screen."
  homepage "https://github.com/fredrir/nsql"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/fredrir/nsql/releases/download/v0.1.3/nsql-aarch64-apple-darwin.tar.xz"
      sha256 "42af36f298f8ddee7a6a2919846d9d0d69f29dd55830d1eaea01caa36a65362b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fredrir/nsql/releases/download/v0.1.3/nsql-x86_64-apple-darwin.tar.xz"
      sha256 "616a1ae8a48264bc2654e0b15092139482b72b7134976b418d59df31d0fee0c7"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/fredrir/nsql/releases/download/v0.1.3/nsql-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "1b676db4b34765e9cd51b1191f72554f0e1556f2d4d1d231c0873b4476053d16"
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
