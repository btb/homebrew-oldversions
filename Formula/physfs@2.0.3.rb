class PhysfsAT203 < Formula
  desc "Library to provide abstract access to various archives"
  homepage "https://icculus.org/physfs/"
  url "https://icculus.org/physfs/downloads/physfs-2.0.3.tar.bz2"
  sha256 "ca862097c0fb451f2cacd286194d071289342c107b6fe69079c079883ff66b69"
  head "https://hg.icculus.org/icculus/physfs/", using: :hg

  bottle do
    root_url "https://github.com/btb/homebrew-oldversions/releases/download/physfs@2.0.3-2.0.3"
    sha256 cellar: :any, catalina: "663c43100542576f828a62626a77fe07d34399e517e25fd6b536bdf327072f4e"
  end

  depends_on "cmake" => :build

  def install
    mkdir "macbuild" do
      args = std_cmake_args
      args << "-DPHYSFS_BUILD_TEST=TRUE"
      args << "-DPHYSFS_BUILD_WX_TEST=FALSE" unless build.head?
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.txt").write "homebrew"
    system "zip", "test.zip", "test.txt"
    (testpath/"test").write <<~EOS
      addarchive test.zip 1
      cat test.txt
    EOS
    assert_match(/Successful\.\nhomebrew/, shell_output("#{bin}/test_physfs < test 2>&1"))
  end
end
