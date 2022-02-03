{ pkgs, lib, ... }:{
    services.grafana = {
        enable   = true;
        port     = 3000;
        domain   = "localhost";
        protocol = "http";
        dataDir  = "/srv/grafana";
    };
}
