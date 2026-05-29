#!/bin/bash
repo=klipper_addon_de
repo_path="$(cd "$(dirname "$0")" && pwd)"

# Exit if root
if [ "$(id -u)" = "0" ]; then
    echo "Script must run from non-root !!!"
    exit 1
fi

echo "Installing DE Beta configs."

module_name1="de-beta.cfg"
module_name2="de-beta-macros.cfg"
module_name3="de-macros.cfg"
module_name4="moonraker.conf"
module_name5="nozzle_wipe.cfg"

copy_module_name1="printer.cfg"
copy_module_name2="wifi"

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

echo "Installation successful restarting klipper now."
sudo service klipper stop
sudo service klipper start