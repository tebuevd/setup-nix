{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    clock24 = true;
    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = dracula;
        extraConfig = ''
          set -g @dracula-plugins "cpu-usage ram-usage battery time"

          set -g @dracula-time-format "%A, %d %b %Y %I:%M%p %Z"

          set -g @dracula-show-battery false
          set -g @dracula-show-powerline true
          set -g @dracula-refresh-rate 10

          set -g @dracula-battery-label false
          set -g @dracula-show-battery-status true
          set -g @dracula-no-battery-label " "
        '';
      }
      {
        plugin = yank;
      }
    ];
    extraConfig = ''
      unbind C-b
      set -g prefix C-Space
      bind C-Space send-prefix

      set -g mouse on
      set -g base-index 1
      set -g pane-base-index 1
      set -g renumber-windows on

      set -g repeat-time 1000

      # Vim-style pane navigation
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Vim-style window navigation
      # Currently uncommented, because I'd like to use the default
      # n - next, p - previous
      bind -r p select-window -t :-
      bind -r n select-window -t :+

      # set vi-mode
      set-window-option -g mode-keys vi
      # keybindings
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

      # new panes/windows open in the same directory
      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      # set status bar
      set -g status-position top

      # recognize ESC immediately (don't wait for other keys for key combo)
      set -g escape-time 0

      set-option -g default-terminal "screen-256color"
    '';
  };
}
