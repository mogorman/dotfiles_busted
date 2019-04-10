#!/usr/bin/env bash
export NIXOS_LABEL="$(nix-info -m|grep channels\(root|cut -f2 -d'"'|cut -f2 -d'-')_$(git rev-parse --short HEAD)"
nixos-rebuild switch

