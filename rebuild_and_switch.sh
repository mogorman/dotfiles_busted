#!/usr/bin/env bash
UNSAVED_CHANGES=$(git diff-index --name-only HEAD --)
if [ -n "${UNSAVED_CHANGES}" ]; then
	echo "commit your changes first mog"
elif [ $(git rev-parse HEAD) != $(git rev-parse @{u}) ]; then
	echo "push your changes too mog!"
else
	sudo NIXOS_LABEL="$(nix-info -m|grep channels\(root|cut -f2 -d'"'|cut -f2 -d'-'|cut -f1 -d',')_$(git rev-parse --short HEAD)" nixos-rebuild switch
fi
