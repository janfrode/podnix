{ pkgs, lib, ... }:{

  networking = {
    useNetworkd = true;
    useDHCP = false;
  };

  systemd.network.networks = {
    "10-eno1" = {
      matchConfig.Name = "eno1";
      networkConfig.LinkLocalAddressing = "no";
      networkConfig.DHCP = "no";
      extraConfig = ''
        VLAN=vlan30
        VLAN=vlan1
        VLAN=podnet
        # In case of 'tagged only' setups, you probably don't need any IP
        # configuration on the link without VLAN (or: default VLAN).
        # For that just omit an [Address] section and disable all the
        # autoconfiguration magic like this:
        #LinkLocalAddressing=no
        LLDP=no
        EmitLLDP=no
        IPv6AcceptRA=no
        IPv6SendRA=no
      '';
    };
    "11-vlan1" = {
      matchConfig.Name = "vlan1";
      linkConfig.RequiredForOnline = false;
      networkConfig.DHCP = "no";
      networkConfig.Address = "192.168.1.7/24";
      networkConfig.Domains = "tanso.net";
    };
    "11-podnet" = {
      matchConfig.Name = "podnet";
      linkConfig.RequiredForOnline = false;
      networkConfig.DHCP = "no";
      extraConfig = ''
        LinkLocalAddressing=no
        LLDP=no
        EmitLLDP=no
        IPv6AcceptRA=no
        IPv6SendRA=no
      '';
    };
    "11-vlan30" = {
      matchConfig.Name = "vlan30";
      networkConfig.DHCP = "no";
      networkConfig.Address = "172.20.30.3/24";
      networkConfig.Domains = "tanso.net";
      extraConfig = ''
        [Route]
        Gateway=172.20.30.1
        GatewayOnLink=false
      '';
    };
  };


  systemd.network.netdevs = { 
    "11-vlan1" = {
      netdevConfig = { Name = "vlan1"; Kind = "vlan"; };
      vlanConfig.Id = 1;
    };
    "11-podnet" = {
      netdevConfig = { Name = "podnet"; Kind = "vlan"; };
      vlanConfig.Id = 2;
    };
    "11-vlan30" = {
      netdevConfig = { Name = "vlan30"; Kind = "vlan"; };
      vlanConfig.Id = 30;
    };
  };

}
