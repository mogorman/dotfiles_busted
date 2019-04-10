#!/usr/bin/env bash
export NIXOS_LABEL_VERSION=$(git rev-parse --short HEAD); nixos-rebuild switch

