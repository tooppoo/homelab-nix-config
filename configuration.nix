{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "philomagi-homelab";

  time.timeZone = "Asia/Tokyo";

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
    vim
    wget
    pass
    gnupg
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

  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
  };

  system.stateVersion = "26.05";
}

