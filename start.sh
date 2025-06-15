#!/bin/bash
DISPLAY_IP=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}') && export DISPLAY_IP
xhost + $DISPLAY_IP
podman compose up
