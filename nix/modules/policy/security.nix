{
  flake.modules.nixos.policy-security-baseline = {
    security.allowUserNamespaces = true;

    boot.kernel.sysctl = {
      # Hide kernel pointers and logs from unprivileged users.
      "kernel.kptr_restrict" = 2;
      "kernel.dmesg_restrict" = 1;

      # Prevent arbitrary ptrace of unrelated processes while still
      # allowing normal debugging of child processes.
      "kernel.yama.ptrace_scope" = 1;

      # Restrict unprivileged BPF.
      "kernel.unprivileged_bpf_disabled" = 1;
      "net.core.bpf_jit_harden" = 2;

      # Restrict kernel performance information.
      "kernel.perf_event_paranoid" = 2;

      # Disable magic SysRq for normal operation.
      "kernel.sysrq" = 0;

      # Filesystem hardening.
      "fs.protected_hardlinks" = 1;
      "fs.protected_symlinks" = 1;
      "fs.protected_fifos" = 2;
      "fs.protected_regular" = 2;

      # Don't accept ICMP redirects/source routing.
      "net.ipv4.conf.all.accept_redirects" = 0;
      "net.ipv4.conf.default.accept_redirects" = 0;
      "net.ipv4.conf.all.send_redirects" = 0;
      "net.ipv4.conf.default.send_redirects" = 0;
      "net.ipv4.conf.all.accept_source_route" = 0;
      "net.ipv4.conf.default.accept_source_route" = 0;

      "net.ipv6.conf.all.accept_redirects" = 0;
      "net.ipv6.conf.default.accept_redirects" = 0;
    };
  };
}
