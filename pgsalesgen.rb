class Pgsalesgen < Formula
  include Language::Python::Virtualenv

  desc "PostgreSQL Sales Generator"
  homepage "https://github.com/rioriost/homebrew-pgsalesgen/"
  url "https://files.pythonhosted.org/packages/94/91/3adf75c359899d01622a079dc57e6c739dbaca3684f4e7a4fe0214ac95cc/pgsalesgen-0.1.2.tar.gz"
  sha256 "4591bfb8bd0ecac611f073e538e2b782566d6da2c5de752ea5f57a58c1b7aaf0"
  license "MIT"

  depends_on "python@3.14"
  depends_on "libpq"

  def install
    venv = virtualenv_create(libexec, "python3.14")

    ENV["PG_CONFIG"] = Formula["libpq"].opt_bin/"pg_config"

    venv.pip_install_and_link buildpath

    venv.pip_install "psycopg[c]"
  end

  test do
    system "#{bin}/pgsalesgen", "--help"
  end
end
