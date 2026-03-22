class Pgsalesgen < Formula
  include Language::Python::Virtualenv

  desc "Generate sales data for PostgreSQL"
  homepage "https://github.com/rioriost/pgsalesgen"
  url "https://github.com/rioriost/pgsalesgen/releases/download/0.1.4/pgsalesgen-0.1.4.tar.gz"
  sha256 "ef58a207d168c74af8fc55f79f4f6dc33acfaf5fc7d6a04f8f7d4b8b0e488a01"
  license "MIT"

  depends_on "python@3.14"
  resource "numpy" do
    if OS.mac? && Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/9b/62/760f2b55866b496bb1fa7da2a6db076bef908110e568b02fcfc1422e2a3a/numpy-2.4.3-cp314-cp314-macosx_11_0_arm64.whl"
      sha256 "297837823f5bc572c5f9379b0c9f3a3365f08492cbdc33bcc3af174372ebb168"
    elsif OS.mac? && Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/70/ae/3936f79adebf8caf81bd7a599b90a561334a658be4dcc7b6329ebf4ee8de/numpy-2.4.3-cp314-cp314-macosx_10_15_x86_64.whl"
      sha256 "5884ce5c7acfae1e4e1b6fde43797d10aa506074d25b531b4f54bde33c0c31d4"
    elsif OS.linux?
      url "https://files.pythonhosted.org/packages/a9/7e/4f120ecc54ba26ddf3dc348eeb9eb063f421de65c05fc961941798feea18/numpy-2.4.3-cp314-cp314-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "679f2a834bae9020f81534671c56fd0cc76dd7e5182f57131478e23d0dc59e24"
    else
      url "https://files.pythonhosted.org/packages/10/8b/c265f4823726ab832de836cdd184d0986dcf94480f81e8739692a7ac7af2/numpy-2.4.3.tar.gz"
      sha256 "483a201202b73495f00dbc83796c6ae63137a9bdade074f7648b3e32613412dd"
    end
  end
  resource "psycopg" do
    url "https://files.pythonhosted.org/packages/c8/5b/181e2e3becb7672b502f0ed7f16ed7352aca7c109cfb94cf3878a9186db9/psycopg-3.3.3-py3-none-any.whl"
    sha256 "f96525a72bcfade6584ab17e89de415ff360748c766f0106959144dcbb38c698"
  end

  def install
    venv = virtualenv_create(libexec, "python3.14")

    resource("numpy").stage do
      if OS.mac? && Hardware::CPU.arm?
        venv.pip_install Pathname(Dir["*.whl"].first)
      elsif OS.mac? && Hardware::CPU.intel?
        venv.pip_install Pathname(Dir["*.whl"].first)
      elsif OS.linux?
        venv.pip_install Pathname(Dir["*.whl"].first)
      else
        venv.pip_install Pathname.pwd
      end
    end

    resource("psycopg").stage do
      wheel = Dir["*.whl"].first
      if wheel
        venv.pip_install Pathname(wheel)
      else
        venv.pip_install Pathname.pwd
      end
    end

    venv.pip_install buildpath
    bin.install_symlink libexec/"bin/pgsalesgen"
  end

  test do
    system "#{bin}/pgsalesgen", "--help"
  end
end
