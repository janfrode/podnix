# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./users/users.nix
      ./networking/firewall.nix
      ./networking/interfaces.nix
      #./services/grafana.nix
      ./virtualisation/podman.nix
      ./virtualisation/containers.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  networking = {
    hostName = "podnix";
    domain = "tanso.net";
    hostId = "f2586814";
    nameservers = [ "172.20.30.1" "1.1.1.1" "8.8.8.8" ];
    defaultGateway = "172.20.30.1";
    timeServers = [ "0.no.pool.ntp.org" "1.no.pool.ntp.org" "2.no.pool.ntp.org" "3.no.pool.ntp.org" ];
  };

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  #networking.interfaces.eno1.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;


  

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.jane = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  # };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    tmux
    nftables
    ethtool
    (import ./vim.nix)
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 
	22	# ssh
	53	# dns/pihole
	80	# pihole
	1883	# mosquitto
	8080	# Doods2
	8123	# Home Assistant
  ];
  networking.firewall.allowedUDPPorts = [ 53 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?


# The services doesn't actually work atm, define an additional service
# Fix e1000e adapter reset:
# https://serverfault.com/questions/616485/e1000e-reset-adapter-unexpectedly-detected-hardware-unit-hang
  # see https://github.com/NixOS/nixpkgs/issues/91352
  systemd.services.ethtool = {
    description = "Disable TSO on boot";
    after = [ "network.target" ];
    serviceConfig = {
      Type = "simple";
      RemainAfterExit = "true";
      ExecStart = "${pkgs.ethtool}/sbin/ethtool -K eno1 tso off";
    };
    wantedBy = [ "default.target" ];
  };

  # Only members of wheel may sudo:
  security.sudo.execWheelOnly = true;
  environment.variables = { EDITOR = "vi"; };

#services.zigbee2mqtt.enable = true; 
#services.zigbee2mqtt.dataDir = "/srv/zigbee2mqtt";
#services.zigbee2mqtt.settings = {
#	homeassistant = true;
#	frontend = {
#  		port = 8088;
#  		host = "0.0.0.0";
#        };
#	permit_join = false;
#	mqtt = {
#  		base_topic = "zigbee2mqtt-hjemma";
#  		server = "mqtt://172.20.30.2";
#  		user = "hjemma";
#  		password = "rahZigh3airahluP";
#        };
#	serial = {
# 		port = "/dev/ttyACM0";
#        };
#	availability  = true;
#	devices = "devices.yaml";
#	groups = "groups.yaml";
#};

}
