{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    main-user.enable = lib.mkEnableOption "enable user module";

    main-user.userName = lib.mkOption {
      default = "englishlayup";
      description = ''
        username
      '';
    };
  };
  config = lib.mkIf config.main-user.enable {
    users.users.${config.main-user.userName} = {
      isNormalUser = true;
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      packages = with pkgs; [
        neovim
        fish
      ];
      shell = pkgs.fish;
    };
  };
}
