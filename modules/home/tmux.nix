# modules/home/tmux.nix
{ pkgs, ... }: {
  programs.tmux = {
    enable = true;
    # Use C-a as prefix
    prefix = "C-a";
    
    # Basic settings
    baseIndex = 1;                # Start windows from 1
    escapeTime = 0;              # No delay for escape key
    historyLimit = 50000;
    keyMode = "vi";              # Vi-style keys
    mouse = true;                # Enable mouse support
    
    # Custom key bindings and settings
    extraConfig = ''
      # Vi copypaste mode
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      
      # Split panes using | and -
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %
      
      # Switch panes using Alt-vim keys without prefix
      bind -n M-h select-pane -L
      bind -n M-l select-pane -R
      bind -n M-k select-pane -U
      bind -n M-j select-pane -D
      
      # Resize panes with vim keys
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5
      
      # Easier window navigation
      bind -r C-h previous-window
      bind -r C-l next-window
      
      # Quick reloads
      bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"
      
      # Status bar styling
      set -g status-style 'bg=#333333 fg=#5eacd3'
      set -g status-position top
      set -g status-left '#[fg=blue,bold]#S '
      set -g status-right '%H:%M '
      set -g status-justify centre
      
      # Window styling
      set -g window-status-current-style 'fg=cyan bold'
      set -g window-status-current-format ' #I#[fg=colour250]:#[fg=colour255]#W#[fg=cyan]#F '
      set -g window-status-format ' #I#[fg=colour237]:#[fg=colour250]#W#[fg=colour244]#F '
      
      # Pane borders
      set -g pane-border-style 'fg=#333333'
      set -g pane-active-border-style 'fg=#5eacd3'
      
      # Enable true colors
      set -g default-terminal "tmux-256color"
      set -ag terminal-overrides ",xterm-256color:RGB"
    '';
  };
}
