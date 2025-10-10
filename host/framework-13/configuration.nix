# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./../../module/main-user.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "framework-13";
  networking.nameservers = [
    "100.100.100.100"
    "1.1.1.1"
    "1.0.0.1"
  ];
  networking.search = [ "beaver-rohu.ts.net" ];
  services.tailscale.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      options = "caps:escape"; # Remap Caps Lock to Escape
      variant = "";
    };
  };

  # Console keymap (for TTY)
  console.useXkbConfig = true; # Use X11 keymap settings for console

  # Enable screensharing with pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "-L" # print build logs
    ];
    dates = "02:00";
    randomizedDelaySec = "45min";
  };

  main-user.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Fonts
  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      nerd-fonts.meslo-lg
      inter
      roboto
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Roboto Serif" ];
        sansSerif = [
          "Inter"
          "Noto Sans"
        ];
        monospace = [ "JetBrainsMono Nerd Font" ];
      };
    };
  };

  # Fingerprint authentication
  services.fprintd.enable = true;
  security.pam.services = {
    login.fprintAuth = true;
    sudo.fprintAuth = true;
    hyprlock.fprintAuth = true;

  };
  # Polkit for authentication popups
  security.polkit.enable = true;

  services.upower.enable = true;

  services.logind = {
    lidSwitch = "suspend";
    lidSwitchExternalPower = "lock";
    powerKey = "suspend";
  };

  services.kanata = {
    enable = true;
    keyboards = {
      internalKeyboard = {
        config = ''
          (defsrc
           caps
          )
          (deflayer base
           lctl
          )
        '';
      };
    };
  };

  programs.nix-ld.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    home-manager
    # Browser
    librewolf
    brave
    # Terminal
    ghostty
    # CLI Utils
    dust
    dua
    git
    btop
    zoxide
    tldr
    wget
    curl
    tree
    unzip
    zip
    htop
    neofetch
    fd
    ripgrep
    fzf
    jq
    # Desktop Environment
    nwg-look
    waybar
    dunst # Notification daemon
    libnotify
    wofi # Application launcher
    hyprpolkitagent
    hyprpaper # Wallpaper daemon
    hyprlock # Screen locker with fingerprint support
    hypridle # Idle daemon
    # System Utils
    networkmanagerapplet
    brightnessctl
    pavucontrol
    playerctl
    wl-clipboard
    # Screenshot
    grim
    slurp
    hyprshot
    gimp3
    # Applications
    syncthing
    kdePackages.dolphin
    clipse
  ];

  environment = {
    localBinInPath = true;
  };

  programs.fish.enable = true;

  programs.bash = {
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd 'uwsm start default'";
        user = "englishlayup";
      };
    };
  };

  services.postgresql = {
    enable = true;
  };

  # Hint Electron apps to use Wayland:
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
