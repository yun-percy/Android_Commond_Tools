#!/bin/bash
# filename: firstrun.sh
# by: pengzi
# from: http://sublimetext.iaixue.com

clear
# cd ~

# run as root
if [[ $(id -u -n) != 'root' ]]; then
	echo ""
	echo "`basename $0` [ERROR]: You need to be sudo user to run this script."
	echo ""
	exit 0
fi

# app basename
app_name='Sublime Text 3'

# app filename
app_filename='sublime_text_3'

# icon filename
icon_filename='sublime-text'

if [[ -f .script_link_target_dir ]]; then
	rm .script_link_target_dir
fi

find . -maxdepth 1 -type l -lname "*`basename $0`" | while read -r LINK_FILE
do
	if [[ "$LINK_FILE" == "./`basename $0`" ]]; then
		echo $(dirname "$(readlink -f $0)") > .script_link_target_dir
	fi
done

if [[ -f .script_link_target_dir ]]; then
	target_dir="$(cat .script_link_target_dir)"
	cd "$target_dir"
	cd -
	rm .script_link_target_dir
	cd -
fi
clear

# install_dir
install_dir="$PWD"

# fcitx_lib_dir
fcitx_lib_dir=$install_dir

case "$install_dir" in
	*\ * )
		fcitx_lib_dir='/usr/lib';
		cp -rf ./sublime_text_fcitx.so /usr/lib/
		;;
	*)
		;;
esac

# copy icons to share folder
cd "./Icon"
find -type d -iname "*x*" | while read -r ICON_DIR
do
	cp -rf "$ICON_DIR"/* "/usr/share/icons/hicolor/$ICON_DIR/apps/"
done
cd "../"

# update install path in launch script and shortcut

cat >"./${app_filename}" <<EOF
#!/bin/bash
# filename: ${app_filename}
# by: pengzi
# from: http://sublimetext.iaixue.com

sh -c "'$PWD/sublime_text' --class=sublime-text '\$@'"
EOF

cat >"./${app_filename}_fcitx" <<EOF
#!/bin/bash
# filename: ${app_filename}_fcitx
# by: pengzi
# from: http://sublimetext.iaixue.com

sh -c "LD_PRELOAD='$fcitx_lib_dir/sublime_text_fcitx.so' '$PWD/sublime_text' --class=sublime-text '\$@'"
EOF

cat >"./${app_filename}.desktop" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name={APP_NAME}
GenericName=Text Editor
Comment=Sophisticated text editor for code, markup and prose
Exec="$PWD/{APP_EXE}" %F
Terminal=false
MimeType=text/plain;
Icon={APP_ICON}
Categories=TextEditor;Development;
StartupNotify=true
Actions=Window;Document;

[Desktop Action Window]
Name=New Window
Exec="$PWD/{APP_EXE}" -n
OnlyShowIn=Unity;

[Desktop Action Document]
Name=New File
Exec="$PWD/{APP_EXE}" --command new_file
OnlyShowIn=Unity;
EOF

# make executable
chmod 755 "./$app_filename"
chmod 755 "./${app_filename}_fcitx"
chmod 755 "./${app_filename}.desktop"
cp -rfp "./${app_filename}.desktop" "./${app_filename}_fcitx.desktop"
chown $SUDO_USER:$SUDO_USER "./$app_filename" "./${app_filename}_fcitx" "./${app_filename}.desktop" "./${app_filename}_fcitx.desktop"

sed -i "s/{APP_EXE}/sublime_text/" "./$app_filename.desktop"
sed -i "s/{APP_NAME}/$app_name/" "./$app_filename.desktop"
sed -i "s/{APP_ICON}/$icon_filename/" "./$app_filename.desktop"

sed -i "s/{APP_EXE}/${app_filename}_fcitx/" "./${app_filename}_fcitx.desktop"
sed -i "s/{APP_NAME}/$app_name [fcitx]/" "./${app_filename}_fcitx.desktop"
sed -i "s/{APP_ICON}/$icon_filename/" "./${app_filename}_fcitx.desktop"


# make command
cp -rfp "./$app_filename" "/usr/bin/$app_filename"
cp -rfp "./${app_filename}_fcitx" "/usr/bin/${app_filename}_fcitx"


# get user desktop dir
#desktop=$(grep -Po '(?<=XDG_DESKTOP_DIR=).*(")' ~/.config/user-dirs.dirs | tr -d '"' | sed 's/\$HOME/\~/g')
if [[ -f ${XDG_CONFIG_HOME:-~/.config}/user-dirs.dirs ]]; then
	test -f ${XDG_CONFIG_HOME:-~/.config}/user-dirs.dirs && source ${XDG_CONFIG_HOME:-~/.config}/user-dirs.dirs;
	DESKTOP_DIR="${XDG_DESKTOP_DIR:-$HOME/Desktop}";

	# create current user desktop shortcut
	sudo -H -u $SUDO_USER cp -rfp "./$app_filename.desktop" $XDG_DESKTOP_DIR
	sudo -H -u $SUDO_USER cp -rfp "./${app_filename}_fcitx.desktop" $XDG_DESKTOP_DIR
fi


# create applications shortcut
cp -rfp "./$app_filename.desktop" /usr/share/applications/
cp -rfp "./${app_filename}_fcitx.desktop" /usr/share/applications/
chmod 644 "/usr/share/applications/$app_filename.desktop"
chmod 644 "/usr/share/applications/${app_filename}_fcitx.desktop"

# update icon cache
gtk-update-icon-cache /usr/share/icons/hicolor


# install fcitx
apt-get install -y fcitx-table-wbpy
# run fcitx
# sudo -H -u $SUDO_USER fcitx

# set session
if [[ ! -d ~/.config/sublime-text-3 ]]; then
	sudo -H -u $SUDO_USER mkdir ~/.config/sublime-text-3
fi
if [[ ! -d ~/.config/sublime-text-3/Local ]]; then
	sudo -H -u $SUDO_USER mkdir ~/.config/sublime-text-3/Local
fi
sudo -H -u $SUDO_USER cp -rf Local/* ~/.config/sublime-text-3/Local
if [[ "$PWD" != "/opt/$app_filename" ]]; then
	current_install_dir=$(echo "$PWD/sn.txt" | sed 's/ /\\ /g')
	current_install_dir=$(echo "$current_install_dir" | sed 's/\//\\\//g')
	old_install_dir=$(echo "/opt/$app_filename/sn.txt" | sed 's/ /\\ /g')
	old_install_dir=$(echo "$old_install_dir" | sed 's/\//\\\//g')
	sed -i s/$old_install_dir/$current_install_dir/g ~/.config/sublime-text-3/Local/Session.sublime_session
fi

# unpackage Codecs33
if [[ ! -d ~/.config/sublime-text-3/Packages ]]; then
	sudo -H -u $SUDO_USER mkdir ~/.config/sublime-text-3/Packages
fi
if [[ ! -d ~/.config/sublime-text-3/Packages/Codecs33 ]]; then
	sudo -H -u $SUDO_USER mkdir ~/.config/sublime-text-3/Packages/Codecs33
fi
sudo -H -u $SUDO_USER unzip -o -qq Packages/Codecs33.sublime-package -d ~/.config/sublime-text-3/Packages/Codecs33

# done
echo ""
echo "================================================================"
echo ""
echo "Make $app_name shortcut completed!"
echo "For more: http://sublimetext.iaixue.com"
echo ""
echo "================================================================"
echo ""

exit 0
