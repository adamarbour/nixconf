# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A NixOS flake configuration repo (personal, multi-machine) built on `flake-parts`. It defines system
configurations for two machines (`hellespont`, `hyphasis`) out of composable, named NixOS modules.

## Commands

```sh
# enter the dev shell (also auto-loaded by direnv via .envrc -> `use flake`)
nix develop

# build/switch a configuration (nh wraps nixos-rebuild, flake pinned to /home/adam/Projects/nixconf)
nh os switch
nh os build

# or directly
sudo nixos-rebuild switch --flake .#hellespont
sudo nixos-rebuild switch --flake .#hyphasis

# check flake evaluates / update inputs
nix flake check
nix flake update
```

There is no test suite, linter, or CI config in this repo — correctness is validated by `nix flake check`
and by building/switching a configuration. The `justfile` at the repo root currently exists but is empty.

## Architecture

**Flake-parts + auto-import.** `flake.nix` recursively imports every `*.nix` file under `nix/` (any file not
prefixed with `_`) via `lib.fileset` and feeds them into `flake-parts.lib.mkFlake`. There is no manual
module list to maintain — adding a new `.nix` file anywhere under `nix/` is enough for it to be picked up,
as long as it produces valid flake-parts output (`flake.modules.nixos.*`, `perSystem`, etc.).

**Named NixOS modules, assembled by convention.** Every reusable piece of config is registered under
`flake.modules.nixos.<name>` (enabled by the `flake-parts.flakeModules.modules` import in
`nix/flake/parts.nix`), then referenced elsewhere as `self.modules.nixos.<name>`. Machines compose their
system out of these named modules rather than importing files by path:

```nix
flake.modules.nixos.hellespont = { pkgs, ... }: {
  imports = [
    self.modules.nixos.desktop
    self.modules.nixos.gaming
    self.modules.nixos.hw-tpm
    self.modules.nixos.cpu-amd
    self.modules.nixos.gpu-amd
    ...
  ];
};
```

Important consequence: **the same module name can be (and is) defined in multiple files, and they get
deep-merged.** For example `flake.modules.nixos.base` has fragments in `nix/nixos/base.nix`,
`nix/nixos/base/nix.nix`, `nix/nixos/base/substituters.nix`, etc. — all merge into one `base` module. When
adding a setting to an existing profile, prefer adding a fragment to the file that already matches the
concern (e.g. substituter changes go in `nix/nixos/base/substituters.nix`) rather than assuming there's a
single canonical file per module name.

**Profile layering.** Profiles build on each other:
`base` -> `graphical` -> `desktop` / `laptop`; `server` -> `base`; `gaming` -> `hw-controllers`.
A machine module (e.g. `hellespont`) then layers hardware modules (`hw-tpm`, `cpu-amd`, `gpu-amd`, ...) and
software modules (`boot-systemd`, `boot-grub`, `boot-secure`) on top, and sets any machine-specific options
directly (kernel choice, DE, firewall, etc.).

**Directory -> module name mapping:**
- `nix/nixos/base.nix` + `nix/nixos/base/*.nix` -> `flake.modules.nixos.base` (nix settings, networking,
  locale, security, ssh, tailscale, etc. — the floor every machine builds on)
- `nix/nixos/graphical.nix`, `nix/nixos/desktop.nix`, `nix/nixos/laptop.nix`, `nix/nixos/server.nix`,
  `nix/nixos/gaming.nix` -> top-level profiles (`graphical`, `desktop`, `laptop`, `server`, `gaming`)
- `nix/nixos/hardware/*.nix` -> per-component hardware modules, several variants per file selected by
  name (e.g. `cpu.nix` defines both `cpu-intel` and `cpu-amd`; `gpu.nix` defines `gpu-intel`, `gpu-amd`,
  `gpu-nvidia`)
- `nix/nixos/boot/*.nix` -> boot-loader choices, mutually exclusive (`boot-systemd`, `boot-grub`,
  `boot-secure` for lanzaboote/secure boot) — machines pick exactly one
- `nix/nixos/services/`, `nix/nixos/programs/` -> service/program modules
- `nix/users/adam.nix` -> `user-adam` module (user account + hjem-managed home files)
- `nix/machines/<name>/{configuration,hardware,filesystem}.nix` -> per-machine `flake.modules.nixos.<name>`
  fragments (the machine's own module, hardware scan results, disk/filesystem layout) plus the
  `flake.nixosConfigurations` entry for that machine via `inputs.self.lib.mkNixos`
- `nix/flake/lib.nix` -> `mkNixos system name`, the helper that turns a named module into a real
  `nixosSystem`/`nixosConfigurations.<name>` entry
- `nix/wrappedPackages/*.nix` -> `flake.wrappers.<name>`, package wrappers via `nix-wrapper-modules`
  (e.g. `git` wrapper sets commit identity, `nh` wrapper pins `NH_FLAKE` to this repo's path)

**Adding a new machine.** Create `nix/machines/<name>/{configuration,hardware,filesystem}.nix` following the
existing pattern: define `flake.modules.nixos.<name>` composed from existing profile/hardware modules, plus
`flake.nixosConfigurations = inputs.self.lib.mkNixos "<system>" "<name>";` in `configuration.nix`.

**Secrets:** `sops-nix` is present in the dev shell tooling (`sops`, `age`, `ssh-to-age`) but no `*.sops.yaml`
or secrets module exists in the repo yet.
