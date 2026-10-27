# Wallpaper

A dynamic desktop background inspired by Theth and the Albanian Alps. It
changes through the day as the sun moves, from dawn to dusk.

![Dawn](../assets/wallpaper-dawn.jpg)
![Sunrise](../assets/wallpaper-sunrise.jpg)
![Morning](../assets/wallpaper-morning.jpg)
![Midday](../assets/wallpaper-midday.jpg)
![Golden hour](../assets/wallpaper-golden-hour.jpg)
![Dusk](../assets/wallpaper-dusk.jpg)

It's one HEIC file with six frames, each tied to a sun position. macOS works
out where the sun is from your location and switches frames on its own.

After stowing, set it on every display:

```sh
zsh scripts/apply-wallpaper.zsh
```

Run that from the repo root. For every Space, enable System Settings › Wallpaper › Show on all Spaces.
