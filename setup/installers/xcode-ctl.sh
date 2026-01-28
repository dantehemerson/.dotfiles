if ! xcode-select -p >/dev/null 2>&1; then
  echo "Installing Xcode Command Line Tools…"
  xcode-select --install

  echo "Please complete the Xcode Command Line Tools installation,"
  echo "then re-run this script."
  exit 1
fi
