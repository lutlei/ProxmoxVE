#!/usr/bin/env bash
source <(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/build.func)
# Copyright (c) 2021-2025 tteck
# Author: tteck (tteckster)
# License: MIT | https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE
# Source: https://www.proxmox.com/en/proxmox-backup-server
# 
# Modified by: lutlei
# Changes: Increased resources and ensure PBS v4 installation

APP="Proxmox-Backup-Server"
var_tags="${var_tags:-backup}"
var_cpu="${var_cpu:-4}"          # Increased from 2 to 4 for better backup performance
var_ram="${var_ram:-4096}"       # Increased from 2048 to 4096 for handling large backups
var_disk="${var_disk:-20}"       # Increased from 10 to 20 for more storage
var_os="${var_os:-debian}"       # Keep as Debian (stable)
var_version="${var_version:-12}" # Keep latest stable
var_unprivileged="${var_unprivileged:-1}"

header_info "$APP"
variables
color
catch_errors

function update_script() {
    header_info
    check_container_storage
    check_container_resources
    if [[ ! -e /usr/sbin/proxmox-backup-manager ]]; then
        msg_error "No ${APP} Installation Found!"
        exit
    fi
    msg_info "Updating $APP LXC"
    $STD apt-get update
    $STD apt-get -y upgrade
    msg_ok "Updated $APP LXC"
    exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${CREATING}${GN}${APP} setup has been successfully initialized!${CL}"
echo -e "${INFO}${YW} Access it using the following URL:${CL}"
echo -e "${TAB}${GATEWAY}${BGN}https://${IP}:8007${CL}"
