{ config, lib, ... }:

with lib;

let
  cfg = config.nix.optimise;
in

{

  ###### interface

  options = {

    nix.optimise = {

      enable = mkOption {
        default = true;
        type = types.bool;
        description = ''
          Whether to enable the Nix store optimiser.
        '';
      };

      automatic = mkOption {
        default = false;
        type = types.bool;
        description = "Automatically run the nix store optimiser at a specific time.";
      };

      dates = mkOption {
        default = ["03:45"];
        type = types.listOf types.str;
        description = ''
          Specification (in the format described by
          <citerefentry><refentrytitle>systemd.time</refentrytitle>
          <manvolnum>7</manvolnum></citerefentry>) of the time at
          which the optimiser will run.
        '';
      };
    };
  };


  ###### implementation

  config = mkIf cfg.enable {

    systemd.services.nix-optimise =
      { description = "Nix Store Optimiser";
        # No point running it inside a nixos-container. It should be on the host instead.
        unitConfig.ConditionVirtualization = "!container";
        serviceConfig.ExecStart = "${config.nix.package}/bin/nix-store --optimise";
        startAt = optionals cfg.automatic cfg.dates;
      };

  };

}
