# modules/home/shell.nix
{ pkgs, ... }: {
  programs.fish = {
    enable = true;
    
    # Fish shell aliases
    shellAliases = {
      ll = "ls -l";
      la = "ls -la";
      ".." = "cd ..";
      "..." = "cd ../..";
      update = "sudo nixos-rebuild switch --flake /etc/nixos#thinkpad-laptop";
    };

    # Fish shell initialization
    interactiveShellInit = ''
      # Set Fish colors
      set fish_color_command green
      set fish_color_param normal
      set fish_color_error red

      # Disable Fish greeting
      set fish_greeting

      # Enable vi mode
      fish_vi_key_bindings

      # Set cursor shapes for different vi modes
      set fish_cursor_default block
      set fish_cursor_insert line
      set fish_cursor_replace_one underscore
      set fish_cursor_visual block

      # Add mode indicator to prompt
      function fish_mode_prompt
        switch $fish_bind_mode
          case default
            set_color red
            echo '[N] '
          case insert
            set_color green
            echo '[I] '
          case visual
            set_color yellow
            echo '[V] '
          case replace_one
            set_color magenta
            echo '[R] '
        end
        set_color normal
      end

      # Vi-style command line editing
      bind -M insert \cp up-or-search
      bind -M insert \cn down-or-search
      bind -M insert \cf forward-char
      bind -M insert \cb backward-char
      bind -M insert \ce end-of-line
      bind -M insert \ca beginning-of-line
      
      # Enable fzf key bindings if fzf is installed
      if type -q fzf
        bind -M insert \ct '__fzf_search_current_dir'
        bind -M insert \cr '__fzf_search_history'
      end
    '';

    functions = {
      # Simple prompt showing current directory

      # Additional vim-like functions
      # Quick edit command in vim
      edit_command_buffer = ''
        set -l f (mktemp)
        if set -q argv[1]
          echo -n "$argv" > $f
        else
          echo -n "$commandline" > $f
        end
        $EDITOR $f
        if test -s $f
          commandline (cat $f)
        end
        rm $f
      '';
    };

  };

  # Optional: Configure fzf for better integration
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };
}
