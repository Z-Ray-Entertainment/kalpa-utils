#!/usr/bin/bash
# All in one Kalpa Utils script
# Mark this file as executable and run it as binary or via terminal

show_assitant(){
    option=`kdialog --radiolist "Choose tool:" \
    1 "Setup flatpak auto updater" off \
    2 "Setup SELinux" off \
    3 "Install nVidia drivers" off`

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
        *)
        exit 0
        ;;
    esac
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
