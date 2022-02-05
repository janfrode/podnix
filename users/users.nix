{ pkgs, lib, ... }:{

  users.users = {
    # Define a user account. Don't forget to set a password with ‘passwd’.
    janfrode = {
      isNormalUser = true;
      extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    };

    janfrode.openssh.authorizedKeys.keys =
      [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFYSqC6uqIbcTZQ9J0NqF389O7T5r61tUG8uGSCVqCHk" ];
    root.openssh.authorizedKeys.keys =
      [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFYSqC6uqIbcTZQ9J0NqF389O7T5r61tUG8uGSCVqCHk" ];

    unifi = {
      isSystemUser = true;
      group = "unifi";
      uid = 271;
    };
    zigbee2mqtt = {
      isSystemUser = true;
      group = "zigbee2mqtt";
      uid = 317;
    };
    mosquitto = {
      isSystemUser = true;
      group = "mosquitto";
      uid = 1883;
    };
    influxdb = {
      isSystemUser = true;
      group = "influxdb";
      uid = 3318;
    };
    grafana = {
      isSystemUser = true;
      group = "grafana";
      uid = 3319;
    };
  };

  users.groups.unifi.gid = 271;
  users.groups.zigbee2mqtt.gid = 317;
  users.groups.mosquitto.gid = 1883;
  users.groups.influxdb.gid = 3318;
  users.groups.grafana.gid = 3319;

}
