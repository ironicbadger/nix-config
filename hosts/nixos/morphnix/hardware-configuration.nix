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

  fileSystems."/nix" =
    { device = "rpool/nix";
      fsType = "zfs";
    };

  fileSystems."/var" =
    { device = "rpool/var";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/21CA-6FD6";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  fileSystems."/boot2" =
    { device = "/dev/disk/by-uuid/21FB-38F9";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices = [ ];

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
## rust - primary data pool (mirrored)
# mirror0 - ata-WDC_WD200EDGZ-11B9PA0_2GJXH0XT
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
    { device = "/dev/disk/by-id/ata-WDC_WD180EDGZ-11B9PA0_2GH0M6HS-part1";
      fsType = "xfs";
    };

  fileSystems."/mnt/disks/disk3" =
    { device = "/dev/disk/by-id/ata-ST16000NT001-3LV101_ZRS09BS4-part1";
      fsType = "xfs";
    };

  fileSystems."/mnt/disks/disk4" =
    { device = "/dev/disk/by-id/ata-WDC_WD140EDGZ-11B1PA0_Y6GX1KWC-part1";
      fsType = "xfs";
    };

  # candidate for removal once data is migrated
  fileSystems."/mnt/disks/disk5" =
    { device = "/dev/disk/by-id/ata-WDC_WD120EDAZ-11F3RA0_5PK9EAHE-part1";
      fsType = "xfs";
    };

  networking.useDHCP = lib.mkDefault true;
  networking.hostId = "36833652";
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno2.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
