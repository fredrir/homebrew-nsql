class Nsql < Formula
  depends_on "dbus" if OS.linux?
  desc "Run SQL from your terminal, composed in your real neovim — without taking over the screen."
  homepage "https://github.com/fredrir/nsql"
  version "0.1.11"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/fredrir/nsql/releases/download/v0.1.11/nsql-aarch64-apple-darwin.tar.xz"
      sha256 "02aa2cf0fa7fb27240081bce658f0d67e005812b4e2f424fd3c0da276294d1b9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fredrir/nsql/releases/download/v0.1.11/nsql-x86_64-apple-darwin.tar.xz"
      sha256 "f4eb0dbade233aa22b934a01ce968d28c2cb3d08a1df9c6c738699efbceea50d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/fredrir/nsql/releases/download/v0.1.11/nsql-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "36d8f5c8d6a4bf86b6c56e86cf3f58a5205ac254eae63f900a4718cb546310de"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fredrir/nsql/releases/download/v0.1.11/nsql-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e08b7d08aad7f1c6a052683fc2a305d4ffe6a6cf2a2097beac802d4fc6c6ce66"
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
