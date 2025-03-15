{ pkgs, ... }:

{
  # Make sudo TouchID work in Tmux
  environment.etc = {
    "pam.d/sudo_local".text = ''
      # Managed by Nix Darwin
      auth       optional       ${pkgs.pam-reattach}/lib/pam/pam_reattach.so ignore_ssh
      auth       sufficient     pam_tid.so
    '';
  };

  security.pam.services.sudo_local.touchIdAuth = true;
}
