# osu-linux-launcher
osu-lazer launcher for linux. Lets you know when an update is available before opening the game and performs a download of the new AppImage if wanted.

This project is made to facilitate the updating process of lazer on linux machines, until the osu!team makes osu! AppImage updates seamless.

This script only relies on github and your local osu-lazer install to look for a new version. Using repositories like the AUR wasn't satisfying solution for me because it involves a delay between the new update going up and the repo maintainers posting the new AppiImage. Furthermore, if the maintainers were to stop contributing, you would have to actively look for another source for your AppImage.

This project is also made for lazy people (me included) who are tired of having to close their game to update it after a notification pops up. If there is an update, you're now aware of it before opening the game.

#### Clone repository :
```bash
git clone https://github.com/Lecornflake/osu-linux-launcher.git
```

#### Usage :
```bash
cd /path/to/osu-linux-launcher

# Before first start only
chmod u+x osu.sh

./osu.sh
```

Note that this script will store the used AppImage in your osu-lazer folder. You may choose to delete your previous lazer AppImage to save disk space.
On application start, a popup from AppImageLauncher may appear asking you to move your lazer AppImage into your application folder. You can mute this popup **for all AppImages** using
```bash
export APPIMAGELAUNCHER_DISABLE=1
```

#### Update this launcher :
```bash
git pull
```