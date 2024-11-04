{ config, lib, pkgs, ... }:

{
  options = {
    # You can add module options here if needed
  };

  config = {
    # Required packages for YubiKey functionality
    environment.systemPackages = with pkgs; [
      yubikey-manager    # CLI tools for YubiKey management
      opensc             # Smart card utilities
      pcsctools         # PC/SC tools for smart card support
      gnupg             # For GPG operations
      pinentry-curses   # For PIN entry
      pinentry-gtk2     # GUI PIN entry (optional)
    ];

    # Enable smartcard daemon
    services.pcscd = {
      enable = true;
      plugins = [ pkgs.ccid ];  # Common CCID driver for smart cards
    };

    # Configure GPG Agent
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    # System-wide GPG and SSH configuration
    environment.shellInit = ''
      export GPG_TTY="$(tty)"
      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
      gpgconf --launch gpg-agent
    '';

  };
}
