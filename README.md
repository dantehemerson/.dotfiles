# :penguin:Dante Calderón dotfiles:rocket:

## Add user to sudoers file.
First of all we need add our user to sudoers file. 
```
su -
```
```
echo "%<username>    ALL=(ALL:ALL) ALL" >> /etc/sudoers
```
## Add non-free repositories
Add this line to `/etc/apt/sources.list`
```
deb http://deb.debian.org/debian/ stretch main contrib non-free
```
Then update dependencies and search in **Synaptic PM**: `broadcom` and install it.
