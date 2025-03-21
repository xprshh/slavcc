{ pkgs, ... }: {
  # nix
  documentation.nixos.enable = false; # .desktop
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };

  # camera
  programs.droidcam.enable = false;

  # virtualisation
  programs.virt-manager.enable = false;
  virtualisation = {
    podman.enable = true;
    docker.enable = true;
    libvirtd.enable = true;
  };

  # dconf
  programs.dconf.enable = true;

  # packages
  environment.systemPackages = with pkgs; [
    home-manager
    neovim
    git
    wget
  ];

  # services
  services = {
    xserver = {
      enable = true;
      excludePackages = [ pkgs.xterm ];
    };
    printing.enable = false;
    flatpak.enable = true;
    openssh.enable = true;
  };

  # logind
  services.logind.extraConfig = ''
    HandlePowerKey=ignore
    HandleLidSwitch=suspend
    HandleLidSwitchExternalPower=ignore
  '';

  # kde connect
  networking.firewall = {
    allowedTCPPortRanges = [{ from = 1714; to = 1764; }];
    allowedUDPPortRanges = [{ from = 1714; to = 1764; }];
  };

  # network
  networking.networkmanager.enable = true;

  # bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    settings.General.Experimental = true; # for gnome-bluetooth percentage
  };

  # bootloader
  boot = {
    tmp.cleanOnBoot = true;
    supportedFilesystems = [ "ntfs" ];
    loader = {
      timeout = 2;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  # garbage collection for disk
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 3d";
  };

  # systemd OOMD
  systemd.oomd = {
    enableRootSlice = true;
    extraConfig = {
      DefaultMemoryPressureDurationSec = "20s";
    };
  };


# Appimage Support if you use it 
#   boot.binfmt.registrations.appimage = {
 # wrapInterpreterInShell = false;
  #interpreter = "${pkgs.appimage-run}/bin/appimage-run";
  #recognitionType = "magic";
  #offset = 0;
  #mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
  #magicOrExtension = ''\x7fELF....AI\x02'';
# };


  system.stateVersion = "23.05";
}
