A lightweight live wallpaper system for **Hyprland** using `mpvpaper`.

It automatically pauses the wallpaper when a window is open (to save CPU/GPU) and resumes when the desktop is empty. Includes a simple Rofi menu to switch wallpapers on the fly.

---

## Features

- Auto pause/resume based on active window
- Rofi-based wallpaper picker
- Supports `.mp4`, `.mkv`, `.webm`
- Remembers last selected wallpaper
- Very low resource usage when paused

---

## Dependencies

```bash
# Arch Linux (yay/paru)
yay -S mpvpaper-git rofi jq socat


PackagePurposempvpaperVideo wallpaper enginerofiWallpaper selection menujqParse Hyprland window infosocatControl mpv via IPCInstallation1. Create foldersBashmkdir -p ~/Videos/LiveWallpapers
mkdir -p ~/.local/bin
mkdir -p ~/.cachePut your video files inside ~/Videos/LiveWallpapers.2. Install the scriptsCopy the two scripts to ~/.local/bin/:Bashcp wallpaper-engine.sh ~/.local/bin/
cp wallpaper-picker.sh ~/.local/bin/
chmod +x ~/.local/bin/wallpaper-engine.sh
chmod +x ~/.local/bin/wallpaper-picker.sh3. Hyprland configAdd these lines to your ~/.config/hypr/hyprland.conf:Bash# Start live wallpaper on login
exec-once = ~/.local/bin/wallpaper-engine.sh

# Open wallpaper picker (SUPER + W)
bind = SUPER, W, exec, ~/.local/bin/wallpaper-picker.sh

# Optional: manual pause/play
bind = SUPER, P, exec, echo '{ "command": ["cycle", "pause"] }' | socat - /tmp/mpvpaper-socket

# Optional: kill wallpaper completely
bind = SUPER ALT, P, exec, pkill mpvpaperThen reload Hyprland:Bashhyprctl reloadUsage
Press SUPER + W → Rofi menu opens → select a video
Wallpaper changes instantly
When any window is focused → wallpaper pauses
When desktop is empty → wallpaper plays again
How it works
wallpaper-engine.sh runs in the background
It checks every 0.4s if there is an active window using hyprctl
If a window is open → sends pause command to mpvpaper via socket
If no window → resumes playback
wallpaper-picker.sh lets you choose a video and saves the selection
CreditsThis project is based on LiveWall by SilverCipherr

Original author: Prottay (SilverCipherr)
```
