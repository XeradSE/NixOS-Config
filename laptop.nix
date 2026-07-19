{ config, pkgs, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_latest;
  networking.hostName = "laptop";


  environment.systemPackages = with pkgs; [
    moonlight-qt
  ];
}
