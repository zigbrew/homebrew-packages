class Zig < Formula
  arch = Hardware::CPU.intel? ? "x86_64" : "aarch64"
  os = OS.mac? ? "macos" : "linux"

  index_json, = Utils::Curl.curl_output("https://ziglang.org/download/index.json")
  index = JSON.parse(index_json)
  release = index["master"]
  download = release["#{arch}-#{os}"]

  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  url download["tarball"]
  version release["version"]
  sha256 download["shasum"] if download["shasum"]
  license "MIT"

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"zig"
  end

  test do
    (testpath/"hello.zig").write <<~EOS
      const std = @import("std");
      pub fn main() !void {
          const stdout = std.io.getStdOut().writer();
          try stdout.print("Hello, world!", .{});
      }
    EOS
    assert_equal "Hello, world!", shell_output("#{bin}/zig run hello.zig")
  end
end
