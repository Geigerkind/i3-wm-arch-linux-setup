#!/bin/env sh

pkill polybar

sleep 1;

polybar monitor1 &
polybar monitor2 &
