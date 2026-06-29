class Nsql < Formula
  desc "Run SQL from your terminal, composed in your real neovim — without taking over the screen."
  homepage "https://github.com/fredrir/nsql"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/fredrir/nsql/releases/download/v0.1.1/nsql-aarch64-apple-darwin.tar.xz"
      sha256 "c7e3ee5648de5878d40319c63617abb49612c3f4d7472b57374fabc08669ddca"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fredrir/nsql/releases/download/v0.1.1/nsql-x86_64-apple-darwin.tar.xz"
      sha256 "76c0bd46f31de04a65c9e75f03df5c04cadf0e298a33345b441a5cbd723e4cdd"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/fredrir/nsql/releases/download/v0.1.1/nsql-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "4f7d78ddfb8b43e18ca9d5ed304edf67d116804557244d5a2edbc87c3ae839e1"
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
