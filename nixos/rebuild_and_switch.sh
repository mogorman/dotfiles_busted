#!/usr/bin/env bash
UNSAVED_CHANGES=$(git diff-index --name-only HEAD --)
if [ -n "${UNSAVED_CHANGES}" ]; then
	echo "commit your changes first mog"
else
	export NIXOS_LABEL="$(nix-info -m|grep channels\(root|cut -f2 -d'"'|cut -f2 -d'-')_$(git rev-parse --short HEAD)"
	nixos-rebuild switch
fi
