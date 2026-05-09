let
  builderAddress = "10.42.1.102";
  templateName = "nixos-tmpl";
  laptopKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA/1OeveuCOTtrUkcuQwEzR2w+qY95jstpZYNSJZ0x5e alex@nauvis";
in
{
  proxmox = {
    host = "10.42.1.91";
    node = "m90q-1";
    user = "root";
  };

  template = rec {
    destinationStorage = "ceph-nvme3";
    uploadDir = "/var/lib/vz/dump";

    golden = {
      name = templateName;
      vmid = 9000;
    };

    last = {
      name = "${templateName}-last";
      vmid = 9001;
    };

    build = {
      name = "nixos-template-build-temp";
      vmid = 9002;
    };

    smokeTest = {
      name = "nixos-template-smoke-test";
      vmid = 9099;
      cores = 2;
      memoryMiB = 2048;
    };

    # Compatibility aliases for older local helper expressions.
    name = golden.name;
    vmid = golden.vmid;
  };

  vm = {
    name = "proxmox-builder";
    vmid = 9010;
    cores = 12;
    memoryMiB = 40960;
    diskGiB = 120;
    diskBus = "virtio0";
    storage = "local";
    bridge = "vmbr0";
  };

  build = {
    # QEMU can spike memory hard when compiled at full host parallelism.
    maxJobs = 1;
    cores = 8;
  };

  network = {
    address = builderAddress;
    prefixLength = 21;
    gateway = "10.42.0.254";
    nameserver = "10.42.0.53";
  };

  bootstrap = {
    user = "debian";
    cloudInitStorage = "local";
    imageCacheDir = "/var/lib/vz/template/cache";
    imageFile = "debian-12-genericcloud-amd64-20260502-2466.qcow2";
    imageUrl = "https://cloud.debian.org/images/cloud/bookworm/20260502-2466/debian-12-genericcloud-amd64-20260502-2466.qcow2";
    imageSha512 = "70ca7caa3711e7ad373a3e936149655901cbeefc56cb8ff5afb1c29d06a9d072dfc37afc842fd3249342b84e2a413993130cc22f800dedcf600218f4c7687c61";
  };

  ssh = {
    alias = "proxmox-builder";
    hostName = builderAddress;
    user = "root";
    port = 22;
    publicKey = laptopKey;
  };

  breakglass = {
    # Console-only fallback for Proxmox VMs. SSH password auth remains disabled.
    alexPasswordHash = "$y$j9T$SanURpI3H6hoUbSKUkhgP.$fEYbCeil7fKwTrwovLjZjnrHfjW.cEiCzyTSbjxRDpA";
  };
}
