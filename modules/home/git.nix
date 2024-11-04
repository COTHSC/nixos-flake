{ config, lib, pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "COTHSC";
    userEmail = "thierryscully.colomban@gmail.com";
    
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
      
      # GPG signing with your YubiKey
      commit.gpgsign = true;
      user.signingkey = "A0A7E717EEF8CB65"; # Your GPG key ID from earlier
    };
  };
}
