{ pkgs, ... }:
{
  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      #dockerCompat = true;
    };
  };

  environment.etc = {
    "cni/net.d/podnetwork.conflist" = {
      text = ''
        {
           "cniVersion": "0.4.0",
           "name": "podnetwork",
           "plugins": [
              {
                 "type": "macvlan",
                 "master": "podnet",
                 "ipam": {
                    "type": "host-local",
                    "ranges": [
                        [
                            {
                                "subnet": "172.20.2.0/24",
                                "rangeStart": "172.20.2.50",
                                "rangeEnd": "172.20.2.254",
                                "gateway": "172.20.2.1" 
                            }
                        ]
                    ],
                    "routes": [
                        {"dst": "0.0.0.0/0"}
                    ]
                 }
              },
              {
                 "type": "tuning",
                 "capabilities": {
                    "mac": true
                 }
              }
           ]
        }
      '';
      mode = "0444";
    };
  };

}
