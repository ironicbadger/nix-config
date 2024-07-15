{ config, lib, pkgs, modulesPath, ... }:
{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

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
    #[ { device = "/dev/disk/by-uuid/1b81359f-61fa-4345-9dfa-da68ffe68212"; }
    #  { device = "/dev/disk/by-uuid/95104585-1624-411b-809e-a6c5bc39793e"; }
    #];

# zfs disks
# "/dev/disk/by-id/ata-WDC_WD180EDGZ-11B9PA0_2GH0M6HS-part1"
# "/dev/disk/by-id/ata-WDC_WD180EDGZ-11B9PA0_2TGGDS5Z-part1";
# "/dev/disk/by-id/ata-WDC_WD180EDGZ-11B9PA0_3ZGA70DZ-part1";

  fileSystems."/mnt/jbod" =
    { device = "/mnt/disks/disk*";
      fsType = "mergerfs";
      options = ["defaults" "minfreespace=250G" "fsname=mergerfs-jbod"];
    };

  fileSystems."/mnt/disks/disk1" =
    { device = "/dev/disk/by-id/ata-WDC_WD140EDGZ-11B1PA0_Y6GX1KWC-part1";
      fsType = "ext4";
    };

  fileSystems."/mnt/disks/disk2" =
    { device = "/dev/disk/by-id/ata-WDC_WD120EDAZ-11F3RA0_5PJJ0K4F-part1";
      fsType = "xfs";
    };

  fileSystems."/mnt/disks/disk3" =
    { device = "/dev/disk/by-id/ata-WDC_WD120EDAZ-11F3RA0_5PK9EAHE-part1";
      fsType = "xfs";
    };

  fileSystems."/mnt/disks/disk4" =
    { device = "/dev/disk/by-id/ata-WDC_WD120EMAZ-11BLFA0_5PGENVSD-part1";
      fsType = "xfs";
    };

  fileSystems."/mnt/disks/disk5" =
    { device = "/dev/disk/by-id/ata-ST10000DM0004-2GR11L_ZJV5CF96-part1";
      fsType = "xfs";
    };

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
