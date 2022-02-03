{ pkgs, lib, ... }:{

  networking.vlans = {
      vlan1 = { id=1; interface="eno1"; };
      vlan30 = { id=30; interface="eno1"; };
    };

  networking.interfaces = {
    eno1.useDHCP = false;
    vlan1.ipv4.addresses = [{
      address = "192.168.1.7";
      prefixLength = 24;
    }];
    vlan30.ipv4.addresses = [{
        address = "172.20.30.3";
        prefixLength = 24;
    }];
  };
}
