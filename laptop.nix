{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [ inputs.degoog.nixosModules.default ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  networking.hostName = "laptop";

  services.power-profiles-daemon.enable = false;

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 80;

      # Optional helps save long term battery health
      START_CHARGE_THRESH_BAT0 = 40; # 40 and below it starts to charge
      STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
    };
  };

  environment.systemPackages = with pkgs; [
  ];

  services.degoog = {
    enable = true;
    configurePostgres = true;

    environment = {
      # DEGOOG_UNIX_SOCKET = "/var/run/degoog/degoog.sock";
      # Other environment variables can be found at https://degoog-org.github.io/docs/environment-variables.html
      DEGOOG_SETTINGS_PASSWORDS = "Yurkzerk52?!";
      DEGOOG_PUBLIC_INSTANCE = "false"; # Désactive le mode public
    };

    # Other option definitions can be found at https://github.com/degoog-org/degoog/blob/main/third-party/nix/module.nix
  };

}
