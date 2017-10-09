{ config, lib, pkgs, ...}:
{
  # Enter custom configuration here

  environment.systemPackages = with pkgs; [
    wget
    vim
    tmux
    git
    sudo
  ];
}
