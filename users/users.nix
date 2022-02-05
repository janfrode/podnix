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
      #issystemuser = true;
      group = "unifi";
      uid = 271;
    };
    zigbee2mqtt = {
      #issystemuser = true;
      group = "zigbee2mqtt";
      uid = 317;
    };
  };

  users.groups.unifi.gid = 271;
  users.groups.zigbee2mqtt.gid = 317;

}
