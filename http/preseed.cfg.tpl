# 1. LOCALIZATION
d-i debian-installer/locale                         string   fr_FR.UTF-8
d-i debian-installer/language                       string   fr
d-i debian-installer/country                        string   FR
d-i keyboard-configuration/xkb-keymap               select   fr
d-i keyboard-configuration/variant                  select   French

# 2. NETWORK
d-i netcfg/choose_interface                         select   auto
d-i netcfg/get_hostname                             string   debian-golden
d-i netcfg/get_domain                               string   localdomain
d-i netcfg/wireless_wep                             string

# 3. MIRROR
d-i mirror/country                                  string   manual
d-i mirror/http/hostname                            string   deb.debian.org
d-i mirror/http/directory                           string   /debian
d-i mirror/http/proxy                               string
d-i mirror/suite                                    string   trixie

# 4. CLOCK & TIMEZONE
d-i clock-setup/utc                                 boolean  true
d-i time/zone                                       string   Europe/Paris
d-i clock-setup/ntp                                 boolean  true

# 5. DISK PARTITIONING
d-i partman-auto/method                             string   lvm
d-i partman-auto-lvm/new_vg_name                    string   vg0

d-i partman-lvm/device_remove_lvm                   boolean  true
d-i partman-md/device_remove_md                     boolean  true
d-i partman-lvm/confirm                             boolean  true
d-i partman-lvm/confirm_nooverwrite                 boolean  true

d-i partman-auto/expert_recipe string                                                        \
    sys-lvm ::                                                                               \
        ${boot_mb} ${boot_mb} ${boot_mb} ext4                                                \
            $primary{ } $bootable{ }                                                         \
            method{ format } format{ }                                                       \
            use_filesystem{ } filesystem{ ext4 }                                             \
            mountpoint{ /boot }                                                              \
        .                                                                                    \
        ${lv_root_mb} ${lv_root_mb} ${lv_root_mb} ext4                                      \
            $lvmok{ } lv_name{ root }                                                        \
            in_vg{ vg0 }                                                                     \
            method{ format } format{ }                                                       \
            use_filesystem{ } filesystem{ ext4 }                                             \
            mountpoint{ / }                                                                  \
        .                                                                                    \
        ${lv_tmp_mb} ${lv_tmp_mb} ${lv_tmp_mb} ext4                                         \
            $lvmok{ } lv_name{ tmp }                                                         \
            in_vg{ vg0 }                                                                     \
            method{ format } format{ }                                                       \
            use_filesystem{ } filesystem{ ext4 }                                             \
            mountpoint{ /tmp }                                                               \
            options/nodev{ nodev }                                                           \
            options/nosuid{ nosuid }                                                         \
            options/noexec{ noexec }                                                         \
        .                                                                                    \
        ${lv_var_mb} ${lv_var_mb} ${lv_var_mb} ext4                                         \
            $lvmok{ } lv_name{ var }                                                         \
            in_vg{ vg0 }                                                                     \
            method{ format } format{ }                                                       \
            use_filesystem{ } filesystem{ ext4 }                                             \
            mountpoint{ /var }                                                               \
        .                                                                                    \
        ${lv_vartmp_mb} ${lv_vartmp_mb} ${lv_vartmp_mb} ext4                                \
            $lvmok{ } lv_name{ vartmp }                                                      \
            in_vg{ vg0 }                                                                     \
            method{ format } format{ }                                                       \
            use_filesystem{ } filesystem{ ext4 }                                             \
            mountpoint{ /var/tmp }                                                           \
            options/nodev{ nodev }                                                           \
            options/nosuid{ nosuid }                                                         \
            options/noexec{ noexec }                                                         \
        .                                                                                    \
        ${lv_varlog_mb} ${lv_varlog_mb} ${lv_varlog_mb} ext4                                \
            $lvmok{ } lv_name{ varlog }                                                      \
            in_vg{ vg0 }                                                                     \
            method{ format } format{ }                                                       \
            use_filesystem{ } filesystem{ ext4 }                                             \
            mountpoint{ /var/log }                                                           \
            options/nodev{ nodev }                                                           \
            options/nosuid{ nosuid }                                                         \
            options/noexec{ noexec }                                                         \
        .                                                                                    \
        ${lv_audit_mb} ${lv_audit_mb} ${lv_audit_mb} ext4                                   \
            $lvmok{ } lv_name{ audit }                                                       \
            in_vg{ vg0 }                                                                     \
            method{ format } format{ }                                                       \
            use_filesystem{ } filesystem{ ext4 }                                             \
            mountpoint{ /var/log/audit }                                                     \
            options/nodev{ nodev }                                                           \
            options/nosuid{ nosuid }                                                         \
            options/noexec{ noexec }                                                         \
        .                                                                                    \
        ${lv_home_mb} ${lv_home_mb} ${lv_home_mb} ext4                                      \
            $lvmok{ } lv_name{ home }                                                        \
            in_vg{ vg0 }                                                                     \
            method{ format } format{ }                                                       \
            use_filesystem{ } filesystem{ ext4 }                                             \
            mountpoint{ /home }                                                              \
            options/nodev{ nodev }                                                           \
            options/nosuid{ nosuid }                                                         \
        .                                                                                    \
        ${lv_swap_mb} ${lv_swap_mb} ${lv_swap_mb} linux-swap                                \
            $lvmok{ } lv_name{ swap }                                                        \
            in_vg{ vg0 }                                                                     \
            method{ swap } format{ }                                                         \
        .

d-i partman-partitioning/confirm_write_new_label    boolean  true
d-i partman/choose_partition                        select   finish
d-i partman/confirm                                 boolean  true
d-i partman/confirm_nooverwrite                     boolean  true

# 6. BASE SYSTEM
d-i base-installer/install-recommends               boolean  false
d-i base-installer/kernel/image                     string   linux-image-amd64

# 7. APT SETUP
d-i apt-setup/non-free-firmware                     boolean  true
d-i apt-setup/non-free                              boolean  false
d-i apt-setup/contrib                               boolean  false
d-i apt-setup/disable-cdrom-repositories           boolean  true
d-i apt-setup/use_mirror                            boolean  true

# 8. ACCOUNTS
d-i passwd/root-login                               boolean  false
d-i passwd/root-password-crypted                   password !

d-i passwd/user-fullname                            string   Provisioner
d-i passwd/username                                 string   provisioner
d-i passwd/user-password                        password debian
d-i passwd/user-default-groups                     string   sudo
d-i passwd/user-uid                                 string   1001

# 9. PACKAGE SELECTION
tasksel tasksel/first                               multiselect
d-i pkgsel/include                                  string   \
    openssh-server                                           \
    qemu-guest-agent                                         \
    curl                                                     \
    wget                                                     \
    ca-certificates                                          \
    sudo

d-i pkgsel/upgrade                                  select   full-upgrade
d-i pkgsel/update-policy                            select   none
popularity-contest popularity-contest/participate   boolean  false

# 10. BOOTLOADER
d-i grub-installer/only_debian                      boolean  true
d-i grub-installer/bootdev                          string   default
d-i grub-installer/with_other_os                   boolean  false

# 11. LATE COMMAND
d-i preseed/late_command string \
    in-target /bin/bash -c ' \
        set -e; \
        \
        # (a) passwordless sudo \
        echo "provisioner ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/provisioner; \
        chmod 0440 /etc/sudoers.d/provisioner; \
        \
        # (c) SSH daemon hardening \
        sed -i "s|^#*PermitRootLogin.*|PermitRootLogin no|"                /etc/ssh/sshd_config; \
        sed -i "s|^#*PasswordAuthentication.*|PasswordAuthentication yes|" /etc/ssh/sshd_config; \
        sed -i "s|^#*PubkeyAuthentication.*|PubkeyAuthentication yes|"     /etc/ssh/sshd_config; \
        sed -i "s|^#*PermitEmptyPasswords.*|PermitEmptyPasswords no|"      /etc/ssh/sshd_config; \
        sed -i "s|^#*X11Forwarding.*|X11Forwarding no|"                    /etc/ssh/sshd_config; \
        sed -i "s|^#*MaxAuthTries.*|MaxAuthTries 4|"                       /etc/ssh/sshd_config; \
        \
        # (d) qemu-guest-agent \
        systemctl enable qemu-guest-agent; \
        # (f) apt cache purge \
        apt-get clean; \
        rm -rf /var/lib/apt/lists/*; \
    '
# 12. FINISH
d-i finish-install/reboot_in_progress               note
d-i debian-installer/exit/poweroff                  boolean  false
