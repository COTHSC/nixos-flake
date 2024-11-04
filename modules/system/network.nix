# modules/system/network.nix
{ ... }: {
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;


    nameservers = [
        "9.9.9.9"
        "149.112.112.112"
    ];

  };
}
