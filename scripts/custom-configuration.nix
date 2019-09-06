{ config, pkgs, lib, ... }:

# let

# in

{
  # Place here any custom configuration specific to your organisation (locale, ...)
  # if you want it to be part of the packer base image to be used with vagrant.

  # if the sandbox is left on (default), any calls to composer / npm / go functions
  # that need to fetch remote sources will fail
  nix.useSandbox = false;

  # allow packages with unfree licenses
  nixpkgs.config.allowUnfree = true;

  # Vagrant needs to mount the shared folders with the dev group
  users.groups.dev = {
    gid = 2001;
  };
  users.users.dev = {
    uid = 2001;
    group = "dev";
    isNormalUser = true;
  };

  # Add as many config from the engagor-configuration.nix file in engagor
  # only config that doesn't depend on the overlays though..
  # This will make a local build less intensive
  nixpkgs.config.packageOverrides = pkgs: {
    # override nginx modules
    nginx = pkgs.nginx.override {
      modules = [
        pkgs.nginxModules.rtmp
        pkgs.nginxModules.dav
        pkgs.nginxModules.moreheaders
        pkgs.nginxModules.lua
        pkgs.nginxModules.echo
      ];
    };

    php.config.xls = pkgs.php.config.override {
      cld = true;
      xsl = true;
    };
  };


  # ElasticSearch / Redis optimalisations
  boot.kernel.sysctl = {
    "fs.file-max" = "518144";
    "net.core.somaxconn" = "10240";
    "vm.max_map_count" = "262144";
    "vm.overcommit_memory" = "1";
    "vm.swappiness" = "1";
    "net.ipv4.tcp_timestamps" = "0";
    "net.ipv6.conf.all.disable_ipv6" = "1";
    "net.ipv6.conf.default.disable_ipv6" = "1";
    "net.ipv6.conf.lo.disable_ipv6" = "1";
  };

  environment.systemPackages = with pkgs; [
    apparmor-parser
    autobuild
    autoconf
    automake
    boost
    bundler
    certbot
    consul
    dnsmasq
    docker
    fontforge
    gcc
    gitAndTools.git-crypt
    gitMinimal
    glibc
    gnumake
    go
    go-bindata
    go_bootstrap
    govers
    htop
    imagemagick
    inetutils
    iotop
    leveldb
    libtool
    libjpeg
    libpng
    libseccomp
    libxslt
    logrotate
    mariadb
    memcached
    nasm
    nodejs
    optipng
    pkgconfig
    python
    redis
    redis
    rssh
    ruby
    sqlite
    strace
    sysstat
    systemd
    tmux
    unzip
    wget
    wkhtmltopdf
    woff2
    yarn
    zlib
  ];

  security.audit.enable = true;

  # only enable services, configuration is done in vagrant provisioning step
  services.consul.enable = true;
  services.logrotate.enable = true;
  services.mysql.enable = true;
  services.mysql.package = pkgs.mariadb;
  services.nginx.enable = true;
  services.openssh.enable = true;
  services.postfix.enable = true;
  services.rabbitmq.enable = true;
  services.xserver.enable = false;

  sound.enable = false;

}
