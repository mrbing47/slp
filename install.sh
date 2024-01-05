#!/usr/bin/env bash
set -euo pipefail

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

latest_release_url=$github_repo/releases/latest/download/slp

install_dir=$HOME/.slp

bin=$install_dir/slp


if [[ ! -d $install_dir ]]; then
    mkdir -p "$install_dir" ||
        error "Failed to create install directory \"$install_dir\""
fi

curl --fail --location --progress-bar --output "$bin" "$latest_release_url" ||
    error "Failed to download slp from \"$latest_release_url\""

chmod +x "$bin" ||
    error 'Failed to set permissions on slp executable'

success "Successfully installed slp"

tildify() {
    if [[ $1 = $HOME/* ]]; then
        local replacement=\~

        echo "${1/$HOME/$replacement}"
    else
        echo "$1"
    fi
}

echo

case $(basename "$SHELL") in
fish)

    commands=(
        "set --export PATH $install_dir \$PATH"
    )

    fish_config=$HOME/.config/fish/config.fish
    tilde_fish_config=$(tildify "$fish_config")

    if [[ -w $fish_config ]]; then
        {
            echo -e '\n# slp'

            for command in "${commands[@]}"; do
                echo "$command"
            done
        } >>"$fish_config"

        info "Added \"$(tildify $install_dir)\" to \$PATH in \"$tilde_fish_config\""

        refresh_command="source $tilde_fish_config"
    else
        echo "Manually add the directory to $tilde_fish_config (or similar):"

        for command in "${commands[@]}"; do
            info_bold "  $command"
        done
    fi
    ;;
zsh)

    commands=(
        "export PATH=\"$install_dir:\$PATH\""
    )

    zsh_config=$HOME/.zshrc
    tilde_zsh_config=$(tildify "$zsh_config")

    if [[ -w $zsh_config ]]; then
        {
            echo -e '\n# slp'

            for command in "${commands[@]}"; do
                echo "$command"
            done
        } >>"$zsh_config"

        info "Added \"$(tildify $install_dir)\" to \$PATH in \"$tilde_zsh_config\""

        refresh_command="exec $SHELL"
    else
        echo "Manually add the directory to $tilde_zsh_config (or similar):"

        for command in "${commands[@]}"; do
            info_bold "  $command"
        done
    fi
    ;;
bash)

    commands=(
        "export PATH=$install_dir:\$PATH"
    )

    bash_configs=(
        "$HOME/.bashrc"
        "$HOME/.bash_profile"
    )

    if [[ ${XDG_CONFIG_HOME:-} ]]; then
        bash_configs+=(
            "$XDG_CONFIG_HOME/.bash_profile"
            "$XDG_CONFIG_HOME/.bashrc"
            "$XDG_CONFIG_HOME/bash_profile"
            "$XDG_CONFIG_HOME/bashrc"
        )
    fi

    set_manually=true
    for bash_config in "${bash_configs[@]}"; do
        tilde_bash_config=$(tildify "$bash_config")

        if [[ -w $bash_config ]]; then
            {
                echo -e '\n# slp'

                for command in "${commands[@]}"; do
                    echo "$command"
                done
            } >>"$bash_config"

            info "Added \"$(tildify $install_dir)\" to \$PATH in \"$tilde_bash_config\""

            refresh_command="source $bash_config"
            set_manually=false
            break
        fi
    done

    if [[ $set_manually = true ]]; then
        echo "Manually add the directory to $tilde_bash_config (or similar):"

        for command in "${commands[@]}"; do
            info_bold "  $command"
        done
    fi
    ;;
*)
    echo 'Manually add the directory to ~/.bashrc (or similar):'
    info_bold "  export PATH=\"$install_dir:\$PATH\""
    ;;
esac

echo
info "To get started, run:"


if [[ $refresh_command ]]; then
    info_bold "$refresh_command"
fi

