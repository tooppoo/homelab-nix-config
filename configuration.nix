{ config, pkgs, ... }:

{
  users.users.philomagi = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];

    openssh.authorizedKeys.keys = [
    ];
  };

  environment.systemPackages = with pkgs; [
    git
    ripgrep
    jq
    tmux
    htop
  ];

  services.openssh = {
    enable = true;

    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  networking.hostName = "nixos-lab";

  system.stateVersion = "26.05";
}

