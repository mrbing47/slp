
# Regular Colors
Red=''
Green=''
Dim='' # White

# Bold
Bold_White=''
Bold_Green=''

if [[ -t 1 ]]; then
    # Reset
    Color_Off='\033[0m' # Text Reset

    # Regular Colors
    Red='\033[0;31m'   # Red
    Green='\033[0;32m' # Green
    Dim='\033[0;2m'    # White

    # Bold
    Bold_Green='\033[1;32m' # Bold Green
    Bold_White='\033[1m'    # Bold White
fi

error() {
    echo -e "${Red}error${Color_Off}:" "$@" >&2
    exit 1
}

info() {
    echo -e "${Dim}$@ ${Color_Off}"
}

info_bold() {
    echo -e "${Bold_White}$@ ${Color_Off}"
}

success() {
    echo -e "${Green}$@ ${Color_Off}"
}


command -v sleep > /dev/null || error "Need to have sleep commend."
command -v pmset > /dev/null || error "Need to have pmset commend."



GITHUB=${GITHUB-"https://github.com"}

github_repo="$GITHUB/mrbing47/slp"

install_dir=$HOME/.slp


if [[ ! -d $install_dir ]]; then
    mkdir -p "$install_dir" ||
        error "Failed to create install directory \"$install_dir\""
fi

curl --fail --location --progress-bar --output "$exe.zip" "$bun_uri" ||
    error "Failed to download bun from \"$github_repo\""

