# Niri Outputs Dmenu Manager

![](./assets/mainsetting.png)
[more screenshots here...](./assets)

The aim of this script is to set on the fly configurations values for the outputs that are plugged onto your system

**Use this script at your own risk !**

## FEATURES

- Show all the outputs recognized by your system
- Tweak the scale, choose a decent resolution+frame rate combinatioin, arrangement of your dual screen setup, toggle the variable fresh rate, or orient your screen

## USAGE

You'll need to download this script

```bash
wget https://raw.githubusercontent.com/Clownatique/niri-output-dmenu/refs/heads/main/niri-outputs-dmenu.sh
```
Make it executable and put it in your path..

```bash
chmod +x niri-outputs-dmenu.sh
mv niri-outputs-dmenu.sh ~/.local/bin/ # but somewhere that appears in your $PATH variable
```

### Programs used in this script

- `jq` : to use the outputs data beautifully json formatted by niri ipc
- `dmenu like launcher`
- `bash` : im sorry if youre using niri from a 1Mb embedeed device..
- `niri` : to retrieve data from the IPC
