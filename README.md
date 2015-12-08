# arch
Helper scripts to get arch linux installed

## Steps for base arch linux:
- Boot into linux iso image
- Get the base install script
```
wget https://raw.githubusercontent.com/atreb/arch/master/base-install.sh
```
Open the base-install.sh script to update the variables if needed
- Change permission for the script to execute
```
chmod 775 base-install.sh
```
- Run the script.
```
./base-install.sh
```