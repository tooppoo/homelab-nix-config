{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    <home-manager/nixos>
  ];

  home-manager.users.philomagi = import ./home.nix;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "philomagi-homelab";

  time.timeZone = "Asia/Tokyo";

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "bws"
    ];

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
    neovim
    wget
    pass
    gnupg
    bws
    cloudflared
    podman
  ];

  systemd.sleep.settings.Sleep = {
    AllowSuspend = "no";
    AllowHibernation = "no";
    AllowHybridSleep = "no";
    AllowSuspendThenHibernate = "no";
  };

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

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  users.users.homelab-secrets = {
    isSystemUser = true;
    group = "homelab-secrets";
    home = "/var/lib/homelab-secrets";
    createHome = true;
  };
  users.groups.homelab-secrets = {};

  systemd.services.cloudflared-secret = {
    description = "Prepare Cloudflare Tunnel token";
  
    before = [ "cloudflared.service" ];
    requiredBy = [ "cloudflared.service" ];
  
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
  
      User = "homelab-secrets";
      Group = "homelab-secrets";
  
      RuntimeDirectory = "cloudflared";
      RuntimeDirectoryMode = "0700";
    };
  
    environment = {
      GNUPGHOME = "/var/lib/homelab-secrets/gnupg";
      PASSWORD_STORE_DIR = "/var/lib/homelab-secrets/password-store";
    };
  
    script = ''
      umask 077
  
      ${pkgs.pass}/bin/pass show cloudflare/tunnel-token \
        > /run/cloudflared/token
    '';
  };

  systemd.services.cloudflared = {
    description = "Cloudflare Tunnel";
  
    wantedBy = [ "multi-user.target" ];
  
    after = [
      "network-online.target"
      "cloudflared-secret.service"
    ];
  
    wants = [ "network-online.target" ];
  
    serviceConfig = {
      ExecStart =
        "${pkgs.cloudflared}/bin/cloudflared tunnel run "
        + "--token-file /run/cloudflared/token";
  
      Restart = "on-failure";
    };
  };

  system.stateVersion = "26.05";
}

