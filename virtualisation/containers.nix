{ config, pkgs, ... }:
{
  config.virtualisation.oci-containers.backend = "podman";

#  systemd.services.create-elk-pod = with config.virtualisation.oci-containers; {
#    serviceConfig.Type = "oneshot";
#    wantedBy = [ "${backend}-influxdb.service" ];
#    script = ''
#      ${pkgs.podman}/bin/podman pod exists elk || \
#        ${pkgs.podman}/bin/podman pod create -n elk -p '127.0.0.1:8040:3000'
#    '';
#  };

## macvlan kanskje ?
### https://discourse.nixos.org/t/nixos-containers-with-macvlan-accessible-from-host/14514


  config.virtualisation.oci-containers.containers = {

    zigbee2mqtt = {
      image = "docker.io/koenkk/zigbee2mqtt:latest";
      environment = {
            TZ = "Europe/Oslo";
          };
      extraOptions = [
        "--device=/dev/ttyACM0:/dev/ttyACM0"
      ];
      ports = ["8088:8088"];
      volumes = [
        "/srv/zigbee2mqtt/data:/app/data"
	"/run/udev:/run/udev:ro"
      ];
    };

    pihole = {
      image = "pihole/pihole:2021.12.1";
      #dependsOn = [ "unbound" ]; 
      ports = [
         "0.0.0.0:53:53/tcp"
         "0.0.0.0:53:53/udp" 
         "80:80/tcp"
      #   "443:443/tcp"
      ];
      environment = {
        TZ = "Europe/Oslo";
        WEBPASSWORD = (builtins.readFile ../secrets/pihole-password) ;  
        DNS1 = "172.20.30.1";
        DNS2 = "8.8.8.8";
      };
      #extraOptions = [
      #"--net=host"      
      #];
    };

    # Image detection with doods2:
    doods2 = {
      image = "docker.io/snowzach/doods2:amd64";
      #ports = ["8080:8080"];
      extraOptions = [
      "--net=host"      
      ];
    };
    # Home Assistant
    hass = {
      image = "docker.io/homeassistant/home-assistant:stable";
      volumes = [
        "/etc/localtime:/etc/localtime:ro"
	"/srv/home-assistant/config:/config"
      ];
      extraOptions = [
      "--net=host"      
      ];
    };
    # Mosquitto
    mosquitto = {
      image = "docker.io/library/eclipse-mosquitto:latest";
      volumes = [
        "/srv/mosquitto/config:/mosquitto/config"
        "/srv/mosquitto/data:/mosquitto/data"
        "/srv/mosquitto/log:/mosquitto/log"
      ];
      extraOptions = [
      "--net=host"      
      ];
    };
};
}
