# modules/nebula/_fleet.nix
{ lib }:
let
  ulaPrefix = "fd04:e8aa:3c21::/48";
  prefixBase = lib.head (lib.splitString "/" ulaPrefix);

  lastOctet = ip: lib.toInt (lib.last (lib.splitString "." ip));
  overlayIP6For = ip: prefixBase + lib.toLower (lib.toHexString (lastOctet ip));

  hosts = {
    # LIGHTHOUSES
    atlas = {
      overlayIP = "10.254.0.1";
      lighthouse = true;
      relay = true;
      publicEndpoint = "172.245.210.47:4242";
    };

    # ROAMERS
    hyphasis.overlayIP = "10.254.0.101";
    hellespont.overlayIP = "10.254.0.102";
  };
in
{
  inherit ulaPrefix;
  hosts = lib.mapAttrs (_: h: h // { overlayIP6 = overlayIP6For h.overlayIP; }) hosts;
}
