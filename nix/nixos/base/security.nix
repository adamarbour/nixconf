{
  flake.modules.nixos.base = { pkgs, lib, config, ... }: {

    boot.loader.systemd-boot.editor = lib.mkDefault false;

    boot.kernel.sysctl = {
      # Prevent boot console log leaking information
      "kernel.printk" = "3 3 3 3";
      "fs.suid_dumpable" = 0;
      # prevent pointer leaks
      "kernel.kptr_restrict" = 2;
      # restrict kernel log to CAP_SYSLOG capability
      "kernel.dmesg_restrict" = 1;
      # Note: certian container runtimes or browser sandboxes might rely on the following
      # restrict eBPF to the CAP_BPF capability
      "kernel.unprivileged_bpf_disabled" = 1;
      # should be enabled along with bpf above
      "net.core.bpf_jit_harden" = 2;
      # restrict loading TTY line disciplines to the CAP_SYS_MODULE
      "dev.tty.ldisk_autoload" = 0;
      # prevent exploit of use-after-free flaws
      "vm.unprivileged_userfaultfd" = 0;
      # kexec is used to boot another kernel during runtime and can be abused
      "kernel.kexec_load_disabled" = 1;
      # Kernel self-protection
      # SysRq exposes a lot of potentially dangerous debugging functionality to unprivileged users
      # 4 makes it so a user can only use the secure attention key. A value of 0 would disable completely
      "kernel.sysrq" = 4;
      # disable unprivileged user namespaces, Note: Docker, NH, and other apps may need this
      # "kernel.unprivileged_userns_clone" = 0; # commented out because it makes NH and other programs fail
      # restrict all usage of performance events to the CAP_PERFMON capability
      "kernel.perf_event_paranoid" = 3;

      ## TCP
      "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
      "net.ipv4.tcp_fastopen" = 3;
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.core.default_qdisc" = "cake";

      ## Userspace hardening
      "kernel.yama.ptrace_scope" = lib.mkDefault 1;  # override to 2/3 on server class hosts
      "vm.mmap_rnd_bits" = 32;
      "vm.mmap_rnd_compat_bits" = 16;
      "fs.protected_symlinks" = 1;
      "fs.protected_hardlinks" = 1;
      "fs.protected_fifos" = 2;
      "fs.protected_regular" = 2;
      "kernel.randomize_va_space" = 2;
    };

    boot.kernelParams = [
      # ignore access time (atime) updates on files, except when they coincide with updates to the ctime or mtime
      "rootflags=noatime"

      # make it harder to influence slab cache layout
      "slab_nomerge"

      # enables zeroing of memory during allocation and free time
      # helps mitigate use-after-free vulnerabilaties
      "init_on_alloc=1"
      "init_on_free=1"

      # randomizes page allocator freelist, improving security by
      # making page allocations less predictable
      "page_alloc.shuffle=1"

      # enables Kernel Page Table Isolation, which mitigates Meltdown and
      # prevents some KASLR bypasses
      "pti=on"

      # randomizes the kernel stack offset on each syscall
      # making attacks that rely on a deterministic stack layout difficult
      "randomize_kstack_offset=on"

      # disables vsyscalls, they've been replaced with vDSO
      "vsyscall=none"

      # disables debugfs, which exposes sensitive info about the kernel
      "debugfs=off"

      # certain exploits cause an "oops", this makes the kernel panic if an "oops" occurs
      "oops=panic"

      # only alows kernel modules that have been signed with a valid key to be loaded
      # making it harder to load malicious kernel modules
      # can make VirtualBox or Nvidia drivers unusable
      "module.sig_enforce=1"

      # prevents user space code excalation
      "lockdown=confidentiality"

      # enable buddy allocator free poisoning
      "page_poison=on"

      # for debugging kernel-level slab issues
      "slub_debug=FZP"

      # disable sysrq keys. sysrq is seful for debugging, but also insecure
      "sysrq_always_enabled=0" # 0 | 1 # 0 means disabled

      # linux security modules
      "lsm=landlock,lockdown,yama,integrity,apparmor,bpf,tomoyo,selinux"

      # prevent the kernel from blanking plymouth out of the fb
      "fbcon=nodefer"

      # Apply relevant CPU exploit mitigations, and disable symmetric
      # multithreading. May harm performance. See overrides.
      "mitigations=auto,nosmt"
    ];

    security = {
      # https://man.archlinux.org/man/login.defs.5
      loginDefs.settings = {
        ENCRYPT_METHOD = "SHA512";
      };

      polkit = {
        enable = true;
        # not needed for run0
        enablePkexecWrapper = false;
      };

      pam.loginLimits = [
        {
          domain = "@wheel";
          item = "nofile";
          type = "soft";
          value = "524288";
        }
        {
          domain = "@wheel";
          item = "nofile";
          type = "hard";
          value = "1048576";
        }
      ];

      protectKernelImage = true;
      lockKernelModules = false; # breaks virtd, wireguard and iptables

      # force-enable the Page Table Isolation (PTI) Linux kernel feature
      forcePageTableIsolation = true;

      # User namespaces are required for sandboxing.
      # this means you cannot set `"user.max_user_namespaces" = 0;` in sysctl
      allowUserNamespaces = true;

      # Disable unprivileged user namespaces, unless containers are enabled
      unprivilegedUsernsClone = false;

      allowSimultaneousMultithreading = true;
    };

    environment.etc = {
      # Empty /etc/securetty to prevent root login on tty.
      securetty.text = ''
      # /etc/securetty: list of terminals on which root is allowed to login.
      # See securetty(5) and login(1).
      '';

      # Set machine-id to the Kicksecure machine-id, for privacy reasons.
      # /var/lib/dbus/machine-id doesn't exist on dbus enabled NixOS systems,
      # so we don't have to worry about that.
      machine-id.text = ''
      b08dfa6083e7567a1921a715000001fb
      '';
    };

  };
}
