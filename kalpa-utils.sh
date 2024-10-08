#!/usr/bin/bash
# All in one Kalpa Utils script
# Mark this file as executable and run it as binary or via terminal

show_assitant(){
    option=`kdialog --radiolist "Choose tool:" \
    1 "Setup flatpak auto updater" off \
    2 "Setup SELinux" off \
    3 "Install nVidia drivers" off \
    4 "Install addional language files" off \
    5 "Migrate MicroOS Desktop to Kalpa" off`

    case $option in
        1)
        setup_flatpak_updater
        ;;
        2)
        setup_selinux
        ;;
        3)
        kdialog --msgbox "Not implemented yet"
        ;;
        4)
        install_language_files
        ;;
        5)
        migrate_microos_to_kalpa
        ;;
        *)
        exit 0
        ;;
    esac
}

migrate_microos_to_kalpa(){
    kdesu -c "transactional-update pkg in -y patterns-kalpa-base && transactional-update apply"
    handle_setup_result "Kalpa Migration"
}

install_language_files(){
    kdesu -c "transactional-update run zypper install-new-recommends -y && transactional-update apply"
    handle_setup_result "Language files"
}

handle_setup_result(){
    case $? in
        0)
        kdialog --msgbox "$1 setup complete"
        show_assitant
        ;;
        *)
        kdialog --error "$1 setup failed"
        ;;
    esac
    show_assitant
}

setup_flatpak_updater(){
    fp_unit_name="flatpak-update"

    cp "$PWD/systemd/flatpak_updater/$fp_unit_name.service" "$HOME/.config/systemd/user/"
    cp "$PWD/systemd/flatpak_updater/$fp_unit_name.timer" "$HOME/.config/systemd/user/"
    systemctl --user enable --now $fp_unit_name.timer
    handle_setup_result "Flatpak auto updater"
}

setup_selinux(){
    kdesu -c "setsebool -P selinuxuser_execmod 1 && setsebool -P selinuxuser_execheap 1 && setsebool -P selinuxuser_execstack 1"
    handle_setup_result "SELinux"
}

show_assitant
