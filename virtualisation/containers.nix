{ config, pkgs, ... }:
{
  config.virtualisation.oci-containers.backend = "podman";

  config.virtualisation.oci-containers.containers = {

    zigbee2mqtt = {
      image = "docker.io/koenkk/zigbee2mqtt:latest";
      environment = {
            TZ = "Europe/Oslo";
          };
      extraOptions = [
        "--device=/dev/ttyACM0:/dev/ttyACM0"
        "--net=podnetwork"      
        "--ip=172.20.2.53"      
      ];
      volumes = [
        "/srv/zigbee2mqtt/data:/app/data"
	"/run/udev:/run/udev:ro"
      ];
    };

    pihole = {
      image = "pihole/pihole:2021.12.1";
      environment = {
        TZ = "Europe/Oslo";
        WEBPASSWORD = (builtins.readFile ../secrets/pihole-password) ;  
	PIHOLE_DNS_ = "109.247.114.4;92.220.228.70;8.8.8.8;";
	DHCP_ACTIVE = "false";
      };
      extraOptions = [
      "--net=podnetwork"      
      "--ip=172.20.2.50"      
      ];
    };

    # Image detection with doods2:
    doods2 = {
      image = "docker.io/snowzach/doods2:amd64";
      extraOptions = [
      "--net=podnetwork"      
      "--ip=172.20.2.51"      
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
      "--net=podnetwork"      
      "--ip=172.20.2.52"      
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
      #"--net=host"      
      "--net=podnetwork"      
      "--ip=172.20.2.54"      
      ];
    };
    unifi = {
      image = "quay.io/linuxserver.io/unifi-controller:latest";
      environment = {
	PUID = "271";
	PGID = "271";
      };
      volumes = [
        "/srv/unifi:/config"
      ];
      ports = [
	"8080:8080"
	"8443:8443"
        "8843:8843"
	"3478:3478/udp"
	"10001:10001/udp"
      ];
      #extraOptions = [
      #"--net=host"      
    #  "--net=podnetwork"      
    #  "--ip=172.20.2.54"      
    #  ];
    };
};
}
