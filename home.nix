{ pkgs, ... }:

{
  home.stateVersion = "26.05";

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
