{ pkgs, ... }:

{
  home.stateVersion = "26.05";

  programs.bash.enable = true;

  xdg.configFile."nvim/init.lua".source = ./nvim/init.lua;

  home.shellAliases = {
    ll = "ls -al";
    vi = "nvim";

    rebuild = ''
    sudo systemd-run \
      --unit=nixos-rebuild-detached \
      --collect \
      --no-block \
      --setenv=PATH=/run/wrappers/bin:/run/current-system/sw/bin \
      --setenv=SUDO_UID=$UID \
      /run/current-system/sw/bin/nixos-rebuild test \
      --flake /home/philomagi/homelab-nix-config
    '';
    rebuild-status = "sudo journalctl -fu nixos-rebuild-detached.service";

    switch = ''
    sudo systemd-run \
      --unit=nixos-switch-detached \
      --collect \
      --no-block \
      --setenv=PATH=/run/wrappers/bin:/run/current-system/sw/bin \
      --setenv=SUDO_UID=$UID \
      /run/current-system/sw/bin/nixos-rebuild switch \
      --flake /home/philomagi/homelab-nix-config
    '';
    switch-status = "sudo journalctl -fu nixos-switch-detached.service";

    bwss = "BWS_ACCESS_TOKEN=$(pass bws/token) bws";
    bws-run = "bwss run --project-id=$(pass bws/project-id)";

    reload = "source ~/.bashrc";
  };

  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "philomagi";
        email = "philomagi-contact@philomagi.dev";
      };
      core = {
        autocrlf = false;
        eol = "lf";
        safecrlf = "warn";
        ignorecase = false;
        filemode = true;
      };

      pull.ff = true;
      fetch.prune = true;
      diff.renames = true;

      init.defaultBranch = "main";
    };
  };
}
