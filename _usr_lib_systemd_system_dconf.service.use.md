sudo chmod a+rx $XDG_RUNTIME_DIR; sudo chmod a+r $XAUTHORITY  
sudo systemctl enable dbus-server.socket dbus-server.service dconf.service  

sudo -u www-data -g www-data env DBUS_SESSION_BUS_ADDRESS=unix:path=/run/dbus/server_bus_socket dconf-editor  
sudo -u www-data -g www-data env DBUS_SESSION_BUS_ADDRESS=unix:path=/run/dbus/server_bus_socket busctl --acquired --user list  

sudo -u www-data -g www-data env DBUS_SESSION_BUS_ADDRESS=unix:path=/run/dbus/server_bus_socket busctl --acquired --user call ca.desrt.dconf /ca/desrt/dconf/Writer/user ca.desrt.dconf.Writer Change "ay" 46 47 97 112 112 115 47 115 101 97 104 111 114 115 101 47 115 101 114 118 101 114 45 97 117 116 111 45 112 117 98 108 105 115 104 0 0 0 0 0 0 1 0 98 0 35 45
