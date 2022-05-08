#! /usr/bin/env bash

DIR=$(dirname "$0")
cd "$DIR"

COMMENT=\#*

sudo -v

. ../scripts/functions.sh


find * -name "*.list" | while read fn; do
    cmd="${fn%.*}"
    set -- $cmd
    info "Installing $1 packages..."
    while read package; do
        if [[ $package == $COMMENT ]];
        then continue
        fi
        substep_info "Installing $package..."
        info "going to run $cmd $package"
	$cmd $package
    done < "$fn"
    success "Finished installing $1 packages."
done
