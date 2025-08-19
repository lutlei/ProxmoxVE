#!/usr/bin/env bash

# Copyright (c) 2021-2025 tteck
# Author: tteck (tteckster)
# License: MIT | https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE
# Source: https://www.proxmox.com/en/proxmox-backup-server
#
# Modified by: lutlei  
# Changes: Ensure Proxmox Backup Server v4 installation

source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Proxmox Backup Server v4"

# Add Proxmox repository GPG key
curl -fsSL "https://enterprise.proxmox.com/debian/proxmox-release-bookworm.gpg" -o "/etc/apt/trusted.gpg.d/proxmox-release-bookworm.gpg"

# Add Proxmox Backup Server repository
cat <<EOF >>/etc/apt/sources.list
deb http://download.proxmox.com/debian/pbs bookworm pbs-no-subscription
EOF

# Update package lists
$STD apt-get update

# Install specific version 4 if available, otherwise latest
if apt-cache policy proxmox-backup-server | grep -q "4\."; then
    msg_info "Installing Proxmox Backup Server v4 (specific version)"
    # Try to install latest v4.x available
    VERSION=$(apt-cache policy proxmox-backup-server | grep "4\." | head -1 | awk '{print $1}')
    if [ -n "$VERSION" ]; then
        $STD apt-get install -y proxmox-backup-server=$VERSION
    else
        $STD apt-get install -y proxmox-backup-server
    fi
else
    msg_info "Installing latest available Proxmox Backup Server"
    $STD apt-get install -y proxmox-backup-server
fi

# Check installed version
INSTALLED_VERSION=$(dpkg -l proxmox-backup-server | grep ^ii | awk '{print $3}')
msg_ok "Installed Proxmox Backup Server version: $INSTALLED_VERSION"

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get -y autoremove
$STD apt-get -y autoclean
msg_ok "Cleaned"
