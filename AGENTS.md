# Repository guidance

## Purpose and structure

This repository is Adam Arbour's flake-parts-based NixOS fleet configuration.

- `flake.nix` declares inputs and recursively imports every `*.nix` file under `nix/`, except files whose basename starts with `_`.
- `nix/flake/` defines flake plumbing, checks, the development shell, formatting, and helper functions.
- `nix/modules/` contains composable NixOS modules grouped into common defaults, features, hardware, policy, profiles, programs, services, and virtualisation.
- `nix/hosts/<name>/configuration.nix` composes each host; `disko.nix` and `hardware.nix` hold host-specific disk and hardware configuration.
- `nix/hosts/_fleet.nix` is manually imported fleet metadata, primarily for Nebula.
- `nix/users/` defines users and their hjem configuration.
- `nix/wrappers/` defines wrapped applications exposed as flake packages.
- `secrets/*.yaml` contains SOPS-encrypted secrets. `.sops.yaml` defines creation rules.

All hosts are constructed with `self.lib.mkNixos`, which imports the host module and the shared `base` module. The current hosts are:

- `atlas`: x86_64 server, GRUB/networkd, ext4 on `/dev/vda`, Nebula lighthouse/relay.
- `hellespont`: x86_64 AMD desktop, Plasma, CachyOS kernel, encrypted Btrfs with impermanence layout.
- `hyphasis`: x86_64 Intel/NVIDIA laptop, Plasma, CachyOS kernel, encrypted Btrfs with impermanence layout.

## Conventions

- Follow the existing flake-parts module style: files contribute through `flake.modules.nixos`, `flake.wrappers`, or another flake output rather than being imported directly, unless their name begins with `_`.
- Shared module names are intentionally merged across files (for example `common`, `my-programs`, and `my-services`).
- Prefer reusable options/modules over putting shared behavior into host files.
- Put machine-specific composition and overrides in the relevant host directory.
- Use `lib.mkDefault` for policy defaults that hosts should be able to override; reserve `mkForce` for intentional hard requirements.
- Preserve the existing option namespaces (`my.programs`, `my.services`, `nixSecrets`, and `persistence`).
- Format Nix with the repository's treefmt/nixfmt configuration. Do not hand-format against it.
- Do not change release branches, `system.stateVersion`, hardware identifiers, network addresses, or `flake.lock` incidentally.

## Validation

Run the narrowest useful checks while iterating, then the full check for completed changes:

```sh
nix fmt
nix fmt -- --ci
nix flake check --no-write-lock-file
```

Inside the direnv/dev shell, `check` runs `nix flake check` and `hooks` runs all configured hooks. The checks include treefmt, deadnix, statix, and repository hygiene hooks.

To evaluate one host without building or activating it:

```sh
nix eval --raw .#nixosConfigurations.<host>.config.system.build.toplevel.drvPath --no-write-lock-file
```

`nix flake check` currently emits expected warnings for custom flake outputs and an unused hjem import on `atlas`; distinguish these from new errors or warnings.

## Safety

- Never decrypt, print, or expose secret values. Do not modify encrypted secret files unless the task explicitly requires it.
- Treat `nix/hosts/*/disko.nix` as destructive infrastructure. Verify disk IDs, partitioning, encryption, subvolumes, and mount points carefully.
- Do not run activation, deployment, installation, disk formatting, secret rotation, or certificate-signing commands unless Adam explicitly asks.
- Builds and evaluations are safe; host activation is not.
- Preserve unrelated working-tree changes and inspect `git status` before and after edits.
- Do not commit, push, or update flake inputs unless requested.

## Working style

- Be concise and action-oriented.
- Inspect the relevant module composition before editing; behavior is often spread across merged module fragments.
- State assumptions when hardware, networking, persistence, or secret behavior is unclear.
- After making changes, summarize modified paths and validation performed, including any checks that could not be run.
