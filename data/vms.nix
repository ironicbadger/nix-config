let
  builder = import ./proxmox-builder.nix;
in
{
  defaults = {
    targetNode = builder.proxmox.node;
    storage = "ceph-nvme3";
    cores = 2;
    memoryMiB = 4096;
    ipConfig0 = "ip=dhcp";
    # ipConfig0 = "ip=10.42.1.110/21,gw=10.42.0.254";
    sshPublicKey = builder.ssh.publicKey;
  };

  vms = {
    forgejo = {
      vmid = 1101;
      cores = 2;
      memoryMiB = 2048;
      diskGiB = 100;
      storage = "ceph-nvme3";
      ipConfig0 = "ip=10.42.1.101/21,gw=10.42.0.254";
      description = "forgejo";
    };
  };
}
