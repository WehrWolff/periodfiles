#!/bin/bash

cat <<"EOF"
 _      __     ____                         
| | /| / /__ _/ / /__  ___ ____  ___ _______
| |/ |/ / _ `/ / / _ \/ _ `/ _ \/ -_) __(_-<
|__/|__/\_,_/_/_/ .__/\_,_/ .__/\__/_/ /___/
               /_/       /_/                

EOF

# Function to check if a tool is installed
check_installed() {
  if ! command -v "$1" &>/dev/null; then
    return 1  # Tool is not installed
  else
    return 0  # Tool is installed
  fi
}

install_feh() {
  if sudo -n true &> /dev/null; then
    gum spin -s dot --title "Installing feh for previewing images. (It will be removed at the end of the script if you want)." -- sudo pacman -S --noconfirm feh
  else
    echo "Installing feh for previewing images. (It will be removed at the end of the script if you want)."
    sudo pacman -S --noconfirm feh &> /dev/null
    clear
  fi
  FEH_INSTALLED=true
}

install_optipng() {
  if sudo -n true &> /dev/null; then
    gum spin -s dot --title "Installing optipng for lossless image compression. (It will be removed at the end of the script if you want)." -- sudo pacman -S --noconfirm optipng
  else
    echo "Installing optipng for lossless image compression. (It will be removed at the end of the script if you want)."
    sudo pacman -S --noconfirm optipng &> /dev/null
    clear
  fi
  OPTIPNG_INSTALLED=true
}

install_lossy_tools() {
  if sudo -n true &> /dev/null; then
    gum spin -s dot --title "Installing libjpeg-turbo and pngquant for lossy image compression. (They will be removed at the end of the script if you want)." -- sudo pacman -S --noconfirm libjpeg-turbo pngquant
  else
    echo "Installing libjpeg-turbo and pngquant for lossy image compression. (They will be removed at the end of the script if you want)."
    sudo pacman -S --noconfirm libjpeg-turbo pngquant &> /dev/null
    clear
  fi
  LOSSY_TOOLS_INSTALLED=true
}

# Function to prompt removal of tools after use
prompt_removal() {
  PACKAGE=$1
  TOOL_DESC=$2
  
  if [[ gum confirm "Do you want to keep $PACKAGE $TOOL_DESC?" ]]; then
    echo "$PACKAGE will be kept installed."
  else
    sudo pacman -Rns --noconfirm "$PACKAGE" &> /dev/null
    echo "$PACKAGE has been removed"
  fi
}

# Function to compress the image (lossless)
compress_lossless() {
  IMAGE=$1
  EXT="${IMAGE##*.}"
  
  if [[ "$EXT" == "jpg" || "$EXT" == "jpeg" ]]; then
    cjpeg -quality 100 -optimize -progressive -outfile "$IMAGE" "$IMAGE"
  elif [[ "$EXT" == "png" ]]; then
    optipng -o7 "$IMAGE"
  fi
}

# Function to compress the image (lossy)
compress_lossy() {
  IMAGE=$1
  EXT="${IMAGE##*.}"

  if [[ "$EXT" == "jpg" || "$EXT" == "jpeg" ]]; then
    cjpeg -quality 80 -optimize -outfile "$IMAGE" "$IMAGE"
  elif [[ "$EXT" == "png" ]]; then
    pngquant --quality=65-80 --ext .png --force "$IMAGE"  # Lossy compression for PNG
  fi
}

# Install tools for script usage
if ! check_installed "feh"; then
    install_feh
fi

if ! check_installed "optipng"; then
    install_optipng
fi

if ! check_installed "mozjpeg" || ! check_installed "pngquant"; then
    install_lossy_tools
fi

# Prompt the user for the location to install wallpapers
DIR_PATH=$(gum input --placeholder "Where would you like to store the wallpapers?" --value "$HOME/.wallpapers")

# Expand the tilde (~) to the full home directory path
WALLPAPER_DIR=$(eval echo "$DIR_PATH")

# Create the specified wallpaper directory if it doesn't exist
mkdir "$WALLPAPER_DIR"

# Ask what type of installation (compression) the user wants for all wallpapers
FULL_INSTALL_OPTION=$(gum choose --header "How would you like to install wallpapers?" "Install All" "Install and Compress (Lossless)" "Install and Compress (Lossy)" "Install Individually per File")

# List of repositories to clone
REPOS=(
  "https://github.com/JaKooLit/Wallpaper-Bank"
  "https://github.com/mylinuxforwork/wallpaper"
)

# Loop through each repository and clone it
for REPO in "${REPOS[@]}"; do
  # Get the repo name from the URL
  REPO_NAME=$(basename "$REPO" .git)

  # Clone the repository into a temporary folder with depth 1 (shallow clone)
  gum spin -s dot --title "Downloading Wallpapers from repository ($REPO)" -- git clone --recursive --depth 1 "$REPO" "$HOME/$REPO_NAME"

  # Find all image files in the cloned repository, including subfolders
  # find "$HOME/$REPO_NAME" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) | while read -r IMAGE; do
  for IMAGE in $(find "$HOME/$REPO_NAME" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \)); do
    IMAGE_NAME=$(basename "$IMAGE")

    # Handle installation and compression based on user selection
    if [[ "$FULL_INSTALL_OPTION" == "Install All" ]]; then
      # Move the image to the specified folder, overwrite if the file exists
      mv -f "$IMAGE" "$WALLPAPER_DIR/$IMAGE_NAME"
    elif [[ "$FULL_INSTALL_OPTION" == "Install and Compress (Lossless)" ]]; then
      # Install and Compress (Lossless)
      compress_lossless "$IMAGE"
      mv -f "$IMAGE" "$WALLPAPER_DIR/$IMAGE_NAME"
    elif [[ "$FULL_INSTALL_OPTION" == "Install and Compress (Lossy)" ]]; then
      # Install and Compress (Lossy)
      compress_lossy "$IMAGE"
      mv -f "$IMAGE" "$WALLPAPER_DIR/$IMAGE_NAME"
    fi

    # echo "Downloaded and processed $IMAGE_NAME"

    # If the user selected to install individually, ask for each image
    if [[ "$FULL_INSTALL_OPTION" == "Install Individually per File" ]]; then
      # read -p "Do you want to install? (default: Install, 1: Install, 2: Compress Lossless, 3: Compress Lossy, 4: Don't Install): " INSTALL_OPTION
      # INSTALL_OPTION="${INSTALL_OPTION:-1}"
      # Show the image preview using feh before asking for confirmation
      feh --scale-down --auto-zoom --title "$IMAGE_NAME Preview" --slideshow-delay 1 --on-last-slide quit "$IMAGE"

      # Combined prompt for installation and compression options
      read -p "Do you want to install $IMAGE_NAME? (default: Install, 1: Install, 2: Compress Lossless, 3: Compress Lossy, 4: Don't Install): " INSTALL_OPTION
      INSTALL_OPTION="${INSTALL_OPTION:-1}"  # Default to '1' (Install)

      if [[ "$INSTALL_OPTION" == "1" ]]; then
        # Install without compression
        mv -f "$IMAGE" "$WALLPAPER_DIR/$IMAGE_NAME"
        echo "Installed $IMAGE_NAME without compression."

      elif [[ "$INSTALL_OPTION" == "2" ]]; then
        # Compress lossless and install
        compress_lossless "$IMAGE"
        mv -f "$IMAGE" "$WALLPAPER_DIR/$IMAGE_NAME"
        echo "Installed and applied lossless compression to $IMAGE_NAME."

      elif [[ "$INSTALL_OPTION" == "3" ]]; then
        # Compress lossy and install
        compress_lossy "$IMAGE"
        mv -f "$IMAGE" "$WALLPAPER_DIR/$IMAGE_NAME"
        echo "Installed and applied lossy compression to $IMAGE_NAME."

      else
        echo "No install, skipping $IMAGE_NAME."
      fi

    fi
  done

  # Clean up by removing the cloned repository
  rm -rf "$HOME/$REPO_NAME"
  echo "Cleaning up image repository ($REPO_NAME)."
  clear
done

# Ask to remove `feh` if it was installed temporarily
if [[ "$FEH_INSTALLED" == true ]]; then
    prompt_removal "feh" "(for previewing images)"
fi

# Ask to remove `imagemagick` if it was installed temporarily
if [[ "$OPTIPNG_INSTALLED" == true ]]; then
    prompt_removal "optipng" "(for lossless image compression)"
fi

# Ask to remove `jpegoptim` and `pngquant` ("lossy tools") if they were installed temporarily
if [[ "$LOSSY_TOOLS_INSTALLED" == true ]]; then
    prompt_removal "libjpeg-turbo" "(for lossy and lossless jpg/jpeg compression)"
    prompt_removal "pngquant" "(for lossy png compression)"
fi

echo "All selected wallpapers have been downloaded to $WALLPAPER_DIR"
gum confirm "Do you want to set a wallpaper as your background?" && waypaper &> /dev/null
