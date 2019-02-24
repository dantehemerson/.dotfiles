# :penguin:Dante Calderón dotfiles:rocket:

## Add user to sudoers file.
First of all we need add our user to sudoers file. 
```
su -
```
```
echo "%<username>    ALL=(ALL:ALL) ALL" >> /etc/sudoers
```
