{ config, pkgs, ... }:

{
  # Place here any custom configuration specific to your organisation (locale, ...)
  # if you want it to be part of the packer base image to be used with vagrant.

  # if the sandbox is left on (default), any calls to composer / npm / go functions
  # that need to fetch remote sources will fail
  nix.useSandbox = false;

  # Vagrant needs to mount the shared folders with the dev group
  users.groups.dev = {
    gid = 2001;
  };
  users.users.dev = {
    uid = 2001;
    group = "dev";
    isNormalUser = true;
  };

}
