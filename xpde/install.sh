#!/bin/sh
echo "Remember you must execute this program as root!!!";

mkdir "/opt"

mkdir "/opt/xpde"
mkdir "/opt/xpde/bin"
mkdir "/opt/xpde/bin/apps"
mkdir "/opt/xpde/bin/applets"

mkdir "/opt/xpde/share"
mkdir "/opt/xpde/share/apps"
mkdir "/opt/xpde/share/applets"
mkdir "/opt/xpde/share/doc"
mkdir "/opt/xpde/share/fonts"
mkdir "/opt/xpde/share/icons"

mkdir "/opt/xpde/themes"

cp -r themes/default /opt/xpde/themes
cp -r defaultdesktop /opt/xpde
cp -r doc/* /opt/xpde/share/doc
cp *.so* /opt/xpde/bin
cp XPde /opt/xpde/bin
cp XPwm /opt/xpde/bin
cp stub.sh /opt/xpde/bin

cp DateTimeProps /opt/xpde/bin/applets
cp appexec /opt/xpde/bin/applets
cp networkstatus /opt/xpde/bin/applets
cp networkproperties /opt/xpde/bin/applets
cp systemproperties /opt/xpde/bin/applets
cp xpsu /opt/xpde/bin/applets
cp mouse /opt/xpde/bin/applets
cp keyboard /opt/xpde/bin/applets
cp regional /opt/xpde/bin/applets
cp desk /opt/xpde/bin/applets

cp taskmanager /opt/xpde/bin/apps
cp notepad /opt/xpde/bin/apps
cp calculator /opt/xpde/bin/apps
cp fontview /opt/xpde/bin/apps
cp regedit /opt/xpde/bin/apps
cp fileexplorer /opt/xpde/bin/apps

cp xinitrcDEFAULT /opt/xpde/bin/xpde
chmod a+x /opt/xpde/bin/xpde
ln -s /opt/xpde/bin/xpde /usr/local/bin/XPde

echo "Installation completed";