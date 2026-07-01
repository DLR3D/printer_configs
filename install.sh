#!/bin/bash
repo=HF400_printer_configs
repo_path="$(cd "$(dirname "$0")" && pwd)"

# Exit if root
if [ "$(id -u)" = "0" ]; then
    echo "Script must run from non-root !!!"
    exit 1
fi

echo "Installing HF400 configs."

module_name1="hf400.cfg"
module_name2="hf400_macros.cfg"
module_name3="hf_macros.cfg"
module_name4="moonraker.conf"
module_name5="nozzle_wipe.cfg"

copy_module_name1="printer.cfg"
copy_module_name2="wifi"
copy_module_name3="KlipperScreen.conf"

klipper_config_path="$HOME/printer_data/config/"

# Linking non modifiable files
ln -sf "$repo_path/$module_name1" "${klipper_config_path}${module_name1}"
ln -sf "$repo_path/$module_name2" "${klipper_config_path}${module_name2}"
ln -sf "$repo_path/$module_name3" "${klipper_config_path}${module_name3}"
ln -sf "$repo_path/$module_name4" "${klipper_config_path}${module_name4}"
ln -sf "$repo_path/$module_name5" "${klipper_config_path}${module_name5}"

# Copying modifiable files
cp -f "$repo_path/$copy_module_name1" "${klipper_config_path}${copy_module_name1}"
cp -f "$repo_path/$copy_module_name2" "${klipper_config_path}${copy_module_name2}"
cp -f "$repo_path/$copy_module_name3" "${klipper_config_path}${copy_module_name3}"

blk_path=~/printer_data/config/moonraker.conf
# Include update block in moonraker.conf
if [ -f "$blk_path" ]; then
    if ! grep -q "^\[update_manager $repo\]$" "$blk_path"; then
        sudo service moonraker stop
        sed -i "\$a \ " "$blk_path"
        sed -i "\$a [update_manager $repo]" "$blk_path"
        sed -i "\$a type: git_repo" "$blk_path"
        sed -i "\$a path: $repo_path" "$blk_path"
        sed -i "\$a origin: https://github.com/DLR3D/printer_configs.git" "$blk_path"
        sed -i "\$a primary_branch: HF400" "$blk_path"
        sed -i "\$a is_system_service: False" "$blk_path"
        sudo service moonraker start
    else
        echo "Including [update_manager] aborted, [update_manager] already exists in $blk_path"
    fi

    if ! grep -q "^\[update_manager $repo\]$" "$blk_path"; then
        sudo service moonraker stop
        sed -i "\$a \ " "$blk_path"
        sed -i "\$a [update_manager klipper]" "$blk_path"
        sed -i "\$a channel: stable" "$blk_path"
        sed -i "\$a pinned_commit: a0d2769639493c4344546d922d40c30d2b121b91:" "$blk_path"
        sudo service moonraker start
    else
        echo "Including [update_manager] aborted, [update_manager] already exists in $blk_path"
    fi
fi

echo "Installation successful restarting klipper now."
sudo service klipper stop
sudo service klipper start