{
    description = "Simple NixOS configuration";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
        home-manager = {
            url = "github:nix-community/home-manager/release-24.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        firefox-addons = {
            url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
            inputs.nixpkgs.follows = "nixpkgs";
        };
# Add your neovim flake as an input
        my-neovim = {
            url = "github:cothsc/nvim-flake";
# If your neovim flake uses nixpkgs, make it use the same version
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, home-manager, firefox-addons, my-neovim, ... }: {
        nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
                ./hardware-configuration.nix
                    ./modules/system/network.nix ./modules/system/yubikey.nix
                    ({ pkgs, ... }: {
                     nix.settings.experimental-features = [ "nix-command" "flakes" ];
                     boot.loader.systemd-boot.enable = true;
                     boot.loader.efi.canTouchEfiVariables = true;
                     services.xserver = {
                     enable = true;
                     desktopManager.plasma5.enable = true;
                     xkb.layout = "us";
                     };
                     services.displayManager.sddm.enable = true;
                     services.displayManager.defaultSession = "plasmawayland";
                     programs.hyprland = {
                         enable = true;
                         xwayland.enable = true;
                     };
                     programs.fish = {
                         enable = true;
                     };
                     sound.enable = true;
                     hardware.pulseaudio.enable = false;
                     security.rtkit.enable = true;
                     services.pipewire = {
                         enable = true;
                         alsa.enable = true;
                         alsa.support32Bit = true;
                         pulse.enable = true;
                     };
                     users.users.jcts = {
                         isNormalUser = true;
                         description = "jcts";
                         extraGroups = [ "networkmanager" "wheel" ];
                         shell = pkgs.fish;
                     };
                     environment.shells = with pkgs; [ fish ];
                     environment.systemPackages = with pkgs; [
                         git
                             wget
                             curl
                             gcc
                             fish
                             my-neovim.packages.${system}.default
                             rustc
                             cargo
                             konsole
                             dolphin
                             ark
                             spectacle
                             waybar
                             dunst
                             rofi-wayland
                             swww
                             kitty
                             papirus-icon-theme     # Popular icon theme
                             font-awesome          # Icons used by many status bars
                             nerdfonts            # Additional icons and symbols
                             ];

                     xdg.portal = {
                         enable = true;
                         extraPortals = [ 
                             pkgs.xdg-desktop-portal-hyprland  # For Hyprland
                             pkgs.xdg-desktop-portal-kde       # For KDE
                         ];
# Use KDE's file picker even in Hyprland
                         config.common.default = "*"; # Let the system pick the right portal
                     };

# Allow unfree packages
                     nixpkgs.config.allowUnfree = true;

                     system.stateVersion = "24.05";
                    })

# Home-manager configuration
            home-manager.nixosModules.home-manager {
             home-manager.useGlobalPkgs = true;
             home-manager.backupFileExtension = "backupup";
             home-manager.useUserPackages = true;
             home-manager.extraSpecialArgs = { inherit firefox-addons; };
             home-manager.users.jcts = { pkgs, ... }: {

             imports = [
             ./modules/home/firefox.nix
             ./modules/home/shell.nix
             ./modules/home/tmux.nix
             ./modules/home/git.nix
             ./modules/home/hyprland.nix
             ];

             home.packages = with pkgs; [
             signal-desktop
             whatsapp-for-linux
             nchat
             cowsay
             ];

             home = {
                 stateVersion = "24.05";
                 username = "jcts";
                 homeDirectory = "/home/jcts";

             };
             };
            }
            ];
        };
    };
}
