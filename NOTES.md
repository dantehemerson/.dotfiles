#### Stop samba

```
sudo systemctl stop smbd
```

#### Mount storage

```
sudo mkdir -p /mnt/msi_storage
sudo mount /dev/sdb1 /mnt/msi_storage
```

#### Fix rar corruped

```
unrar x -kb file.rar
```


### Delete/Uninstall App

```

Remove data related to the app in this folders:

Library/Application Support/
Library/Caches/
Library/Saved Application State/
Library/WebKit/
Library/Preferences/

```

## Useful commands

```

# Upgrade packages interactively
ncu --interactive --format group


```



# VIM

* **Delete** up to the first character ocurrence: `dt <c>`
  e.g. `dt"` (deletes up to `"` character)


To use the bundled libc++ please add the following LDFLAGS:
  LDFLAGS="-L/opt/homebrew/opt/llvm/lib/c++ -Wl,-rpath,/opt/homebrew/opt/llvm/lib/c++"

  llvm is keg-only, which means it was not symlinked into /opt/homebrew,
  because macOS already provides this software and installing another version in
  parallel can cause all kinds of trouble.

  If you need to have llvm first in your PATH, run:
    echo 'export PATH="/opt/homebrew/opt/llvm/bin:$PATH"' >> ~/.zshrc

    For compilers to find llvm you may need to set:
      export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
        export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"


## Size of current directories

```sh
du -sh */
```
