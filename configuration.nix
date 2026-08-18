{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "philomagi-homelab";

  users.users.philomagi = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIaRdKboD7jA87IFZAm1maUF8P/vhNIwAcyrINpRDZFS philomagi@philomagi-win"
    ];
  };

  environment.systemPackages = with pkgs; [
    git
    ripgrep
    jq
    tmux
  ];

  services.openssh = {
    enable = true;

    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
  };
  system.stateVersion = "26.05";
}

