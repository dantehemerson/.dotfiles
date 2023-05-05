#### Stop samba

```
sudo systemctl stop smbd
```

#### Mount storage

```
sudo mkdir /mnt/msi_storage
sudo mount /dev/sdb1 /mnt/msi_storage
```

#### Fix rar corruped

```
unrar x -kb file.rar
```
