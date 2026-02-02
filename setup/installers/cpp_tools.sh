# TODO:

## === C++ Development (Optional by flag defined in .env.sh) ===
if [[ "$__DOT__INSTALL_CPP" == true ]]; then
  # Ninja is a small build system with a focus on speed
  brew install ninja

  # Install tools required by clangd Extension for C/C++
  # See: https://clangd.llvm.org/installation

  # Install language server
  brew install llvm

  # To generate compile_commands.json
  brew install bear
else
  echo "🚫 Skipping C++ Development tools installation..."
fi # __DOT__INSTALL_CPP

# Done. Final message
ejecho "🎉 All apps installed successfully!"
