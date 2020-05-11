#!/bin/bash
:<<!
This script helps change brew source
Author: c
Last update: 11/05/2020
!

sh_ver="0.2"
github_addr="https://raw.githubusercontent.com/svonx/self-public/master/brew_source.sh"
green_font_prefix="\033[32m" && cyan_font_prefix="\033[36m" && red_font_prefix="\033[31m" && font_color_suffix="\033[0m"
ini_dir="$PWD"

start_menu(){
    clear
    echo
    echo -e "${cyan_font_prefix}Change brew source to${font_color_suffix}"
    echo -e "${green_font_prefix}1.${font_color_suffix} USTC mirror source"
    echo -e "${green_font_prefix}2.${font_color_suffix} Tsinghua University mirror source"
    echo -e "${green_font_prefix}3.${font_color_suffix} default source"
    echo "or"
    echo -e "${red_font_prefix}8.${font_color_suffix} update"
    echo -e "${red_font_prefix}9.${font_color_suffix} exit"
    echo ""
    read -p "Your choice: " usr_choice

    case "$usr_choice" in
        1)
        change_to_ustc
        success_info 1
        cd ${ini_dir}
        ;;
        2)
        change_to_tsinghua
        success_info 2
        cd ${ini_dir}
        ;;
        3)
        change_to_default
        success_info 3
        cd ${ini_dir}
        ;;
        8)
        update_shell
        ;;
        9)
        cd ${ini_dir}
        exit 0
        ;;
        *)
        echo -e "${red_font_prefix}Please enter a correct number.${font_color_suffix}"
        sleep 3s
        start_menu
        ;;
    esac
}

change_to_ustc(){
    cd "$(brew --repo)"
    git remote set-url origin https://mirrors.ustc.edu.cn/brew.git
    cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
    git remote set-url origin https://mirrors.ustc.edu.cn/homebrew-core.git
}

change_to_tsinghua(){
    cd "$(brew --repo)"
    git remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git
    cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
    git remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git
}

change_to_default(){
    cd "$(brew --repo)"
    git remote set-url origin https://github.com/Homebrew/brew.git
    cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
    git remote set-url origin https://github.com/Homebrew/homebrew-core.git
}

success_info(){
    echo -n "brew source changed to "
    case $1 in
        1)
        echo -n "USTC mirror source"
        ;;
        2)
        echo -n "Tsinghua mirror source"
        ;;
        3)
        echo -n "default source"
        ;;
    esac
    echo -e "${green_font_prefix} successfully${font_color_suffix}."
    echo ""
}

update_shell(){
    echo -e "Current version is ${sh_ver}, checking in progress..."
    new_sh_ver=$(curl -s ${github_addr} | grep "sh_ver=" | head -n 1 | awk -F "=" '{print $NF}' | sed 's/\"//g')
    if [[ ${sh_ver} != ${new_sh_ver} ]]
    then
        read -p "A new version is found. Do you want to update? y/n: " yn
        [[ -z ${yn} ]] && yn="y"
        if [[ ${yn} = [yY] ]]
        then
            curl -o brew_source.sh ${github_addr} && chmod 755 brew_source.sh
        else
            echo "cancelled."
        fi
    else
        echo "This is the latest one."
    fi

}

#
start_menu
