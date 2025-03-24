{ config, lib, pkgs, modulesPath, ... }:

{
  # imports =
  #   [ (modulesPath + "/installer/scan/not-detected.nix")
  #   ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "mpt3sas" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  powerManagement.cpuFreqGovernor = "powersave";

  fileSystems."/" =
    { device = "rpool/root";
      fsType = "zfs";
    };

  fileSystems."/home" =
    { device = "rpool/home";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/2AD5-541F";
      fsType = "vfat";
    };

  swapDevices = [];

## zfs disks
############
## rpool - boot mirror
# ata-Samsung_SSD_870_EVO_1TB_S6PTNM0TA60489X
# ata-Samsung_SSD_870_EVO_1TB_S6PTNZ0T331139A
#
## nvme-appdata - mirrored nvme ssds for appdata
# nvme-Samsung_SSD_970_EVO_Plus_2TB_S59CNJ0N604556L
# nvme-Samsung_SSD_990_PRO_2TB_S7KHNJ0WC22256R
#
## ssd4tb - downloads and other iops heavy workloads
# ata-CT4000MX500SSD1_2332E86B4A28
# ata-CT4000MX500SSD1_2332E86B4BAA
# ata-CT4000MX500SSD1_2332E86B49E0
#
## bigrust18 - primary data pool
# mirror0 - ata-WDC_WD180EDGZ-11B9PA0_2GH0M6HS
# mirror0 - ata-WDC_WD200EDGZ-11B9PA0_2GJXH0XT
# mirror1 - ata-WDC_WD180EDGZ-11B9PA0_3ZGA70DZ
# mirror1 - ata-ST20000NM007D-3DJ103_ZVT5JTWC

# media storage disks etc
  fileSystems."/mnt/jbod" =
    { device = "/mnt/disks/disk*";
      fsType = "mergerfs";
      options = ["defaults" "minfreespace=250G" "fsname=mergerfs-jbod"];
    };

  fileSystems."/mnt/disks/disk1" =
    { device = "/dev/disk/by-id/ata-WDC_WD180EDGZ-11B9PA0_2TGGDS5Z-part1";
      fsType = "xfs";
    };

  fileSystems."/mnt/disks/disk2" =
    { device = "/dev/disk/by-id/ata-ST16000NT001-3LV101_ZRS09BS4-part1";
      fsType = "xfs";
    };

  fileSystems."/mnt/disks/disk3" =
    { device = "/dev/disk/by-id/ata-WDC_WD140EDGZ-11B1PA0_Y6GX1KWC-part1";
      fsType = "ext4";
    };

  fileSystems."/mnt/disks/disk4" =
    { device = "/dev/disk/by-id/ata-WDC_WD120EDAZ-11F3RA0_5PK9EAHE-part1";
      fsType = "xfs";
    };

  # removed 2025-03-21
  # fileSystems."/mnt/disks/disk3" =
  #   { device = "/dev/disk/by-id/ata-WDC_WD120EDAZ-11F3RA0_5PJJ0K4F-part1";
  #     fsType = "xfs";
  #   };

  # removed 2025-03-24
  # fileSystems."/mnt/disks/disk4" =
  #   { device = "/dev/disk/by-id/ata-WDC_WD120EMAZ-11BLFA0_5PGENVSD-part1";
  #     fsType = "xfs";
  #   };



  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  networking.hostId = "7f8ded12";
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno2.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
