{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  #boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;
  
  # Use GRUB as your boot loader. (It can handle dual boot and more uwu)
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "nodev" ];
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;

  # Use lastest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Kernel parameters
  boot.kernelParams = ["pci=nocrs" "kvm-intel"];  

  networking.hostName = "dk43-81w6";
  networking.networkmanager.enable = true;
  time.timeZone = "America/Bogota";
 
# Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    keyMap = "es";
    #useXkbConfig = true; # use xkbOptions in tty.
  };

  # Enable the XFCE Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages = [ pkgs.gnome.cheese 
  pkgs.gnome-photos 
  pkgs.gnome.gnome-music 
  pkgs.gnome.gnome-terminal 
  pkgs.gnome.gedit 
  pkgs.epiphany 
  pkgs.evince 
  pkgs.gnome.gnome-characters 
  pkgs.gnome.totem 
  pkgs.gnome.tali 
  pkgs.gnome.iagno 
  pkgs.gnome.hitori 
  pkgs.gnome.atomix 
  pkgs.gnome-tour  
  pkgs.gnome.geary ];

  # Enable XMonad and everything that it needs to run my config
  services.xserver.windowManager.xmonad = { 
		enable = true;
		enableContribAndExtras = true;
		extraPackages = haskellPackages : [
			haskellPackages.xmonad-contrib
			haskellPackages.xmonad-extras
			haskellPackages.xmonad
            		haskellPackages.ghc
		];
 		};

  # Configure X11 things
  services.xserver.layout = "latam";
  services.xserver = {
  enable = true;
    libinput = {
      enable = true;
      mouse = {
        accelProfile = "flat";
      };
  };
};

  # Enable CUPS to print documents.
  # services.printing.enable = true;
  
  # Bluetooth
  hardware.bluetooth.enable = false;
  
  # Pipewire
  security.rtkit.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
};
  
  # Virtualbox
   virtualisation.virtualbox.host.enable = true;
   users.extraGroups.vboxusers.members = [ "user-with-access-to-virtualbox" ];

  # Accounts
  users.users.dk43 = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" "video" "audio" "docker" ];
  };

  #Packages
  nixpkgs.config.allowUnfree = true;
 
  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
    neofetch
    kitty
    pavucontrol
    gimp
    brave
    docker
    vscode
    rofi
    foot
    tmux
    python3Full
    wineWowPackages.staging
    light
    pamixer
    lxappearance
    polybar
    flameshot
    feh
    htop
    btop
    picom-next
    kdenlive
    obs-studio
    dunst

    #Gnome
    gnomeExtensions.unite
    gnome.gnome-tweaks
  ];

 # List services that you want to enable:
  
  #Brightness
  programs.light.enable = true;

  # Media codecs for fastest video playback
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };

  # Undervolt
  services.undervolt.enable = true;
  services.undervolt.analogioOffset = -60;
  services.undervolt.coreOffset = -50;
  services.undervolt.gpuOffset = -50;
  services.undervolt.p1.limit = 255;
  services.undervolt.p1.window = 90000;
  services.undervolt.p2.limit = 255;
  services.undervolt.p2.window = 90000;

  # Flatpak
  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    #extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    gtkUsePortal = true;
  };

  # Gnome settings daemon
  services.udev.packages = with pkgs; [ gnome3.gnome-settings-daemon ];

  # Power Profiles Daemon
  services.power-profiles-daemon.enable = true;
  
  # SSH
  services.openssh.enable = true;






  ################################################################################
  ############ DON'T TOUCH THIS THING DUMB ASS ###################################
  ################################################################################




  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}

