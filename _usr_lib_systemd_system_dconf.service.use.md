sudo chmod a+rx $XDG_RUNTIME_DIR; sudo chmod a+r $XAUTHORITY  
sudo systemctl enable dbus-server.socket dbus-server.service dconf.service  

sudo -u www-data -g www-data env DBUS_SESSION_BUS_ADDRESS=unix:path=/run/dbus/server_bus_socket dconf-editor  
sudo -u www-data -g www-data env DBUS_SESSION_BUS_ADDRESS=unix:path=/run/dbus/server_bus_socket busctl --acquired --user list  
