# modules/wm/default.nix
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.windowManagers;
in {
  options.modules.windowManagers = {
    enable = lib.mkEnableOption "Additional window managers";
    
    hyprland = {
      enable = lib.mkEnableOption "Hyprland compositor";
      nvidia = lib.mkEnableOption "Enable Nvidia-specific configuration";
    };
  };

  config = lib.mkIf cfg.enable {
    # Enable Hyprland
    programs.hyprland = lib.mkIf cfg.hyprland.enable {
      enable = true;
      nvidiaPatches = cfg.hyprland.nvidia;
      xwayland.enable = true;
    };

    # General packages for Hyprland
    environment.systemPackages = with pkgs; [
      waybar               # Status bar
      wofi                 # Application launcher
      dunst               # Notification daemon
      swww                # Wallpaper tool
      swaylock-effects    # Lock screen
      wl-clipboard        # Clipboard manager
      grim                # Screenshot utility
      slurp               # Screen area selection
      brightnessctl       # Brightness control
      pamixer             # Volume control
      networkmanagerapplet # Network management
      alacritty           # Terminal
      kitty               # Alternative terminal
    ];

    # XDG desktop portal
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
    };

    # Enable services needed for Hyprland
    security.pam.services.swaylock = {}; # Allow swaylock to unlock
    security.polkit.enable = true;
  };
}
