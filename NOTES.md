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