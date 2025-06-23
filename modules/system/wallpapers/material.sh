if [ "$(hostname)" = "desktop" ]; then
    WALLPAPER_DIR="${HOME}/.config/wallpapers/1440p"
elif [ "$(hostname)" = "laptop" ]; then
    WALLPAPER_DIR="${HOME}/.config/wallpapers/1080p"
else
  echo "Unknown host type: $(hostname)"
  exit 1
fi

if [ $# -eq 0 ]; then
    echo "Usage: $0 <IMAGE>"
    echo "Specify 'select', 'random', or provide an image file path."
    exit 1
fi

IMAGE="$1"

if [ "$IMAGE" = "random" ]; then
    wallpaper_files=("${WALLPAPER_DIR}"/*)
    if [ ${#wallpaper_files[@]} -eq 0 ]; then
        echo "No wallpaper files found in ${WALLPAPER_DIR}"
        exit 1
    fi
    IMAGE="${wallpaper_files[RANDOM % ${#wallpaper_files[@]}]}"
elif [ "$IMAGE" = "select" ]; then
    IMAGE=$(zenity --file-selection --filename="${WALLPAPER_DIR}/")
fi

if [ -f "$IMAGE" ]; then
    swww img "$IMAGE" --transition-fps 75 --transition-type wipe --transition-duration 2
fi
