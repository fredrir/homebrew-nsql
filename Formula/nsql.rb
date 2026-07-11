class Nsql < Formula
  desc "Run SQL from your terminal, composed in your real neovim — without taking over the screen."
  homepage "https://github.com/fredrir/nsql"
  version "0.1.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/fredrir/nsql/releases/download/v0.1.6/nsql-aarch64-apple-darwin.tar.xz"
      sha256 "b393834ee6b45b21fa3403b0fb81401f773e0b5a7c7cf0174a5c07794afa74bb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fredrir/nsql/releases/download/v0.1.6/nsql-x86_64-apple-darwin.tar.xz"
      sha256 "1832b074e1088315443a7fbdf0b79b60233ca1e27811814a28a1888db8e54645"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/fredrir/nsql/releases/download/v0.1.6/nsql-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "64fb0047cfcaef97bc48a7c18d7d16e18d753aaf142a42d64dfb8c2f03e04767"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fredrir/nsql/releases/download/v0.1.6/nsql-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4ddcfaa0a4694034e98413fb8658a744af3e8c34e9915a1fc1595b8d9891ce90"
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
