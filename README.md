## (WIP) Niri Outputs Manager

The aim of this script is to set on the fly configurations values for the outputs that are plugged onto your system

** DO NOT USE THIS SOFTWARE! no check have been implemented at mode setting tweak, it can damages your screen! **

### Dependancies

- `jq` : to use this data (json formatted by niri)
- `fuzzel` : just yet... soon to be universal..
- `bash` : not sh only !
- `niri` : to retrieve data from the IPC

### Installation

```bash
wget https://raw.githubusercontent.com/Clownatique/niri-output-dmenu/refs/heads/main/niri-outputs-dmenu.sh
```


```bash
chmod +x niri-outputs-dmenu.sh
mv niri-outputs-dmenu.sh ~/.local/bin/ # but somewhere that appears in your $PATH variable
```

## What are the currents features 

- You can get the list of the screens detected
- You can change the scale, mode, position, vrr, transform

## TODO:

- fix: refresh rate conversion
- build: ensure this script may run with any dmenu program /!\
- style: make sure nerds font are optional
