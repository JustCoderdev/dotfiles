#!/usr/bin/env bash

gcc -xc -std=c89 -ansi -pedantic-errors -pedantic \
	-Wall -Wextra -Werror -Wshadow -Wpointer-arith \
	-Wcast-qual -Wcast-align -Wstrict-prototypes \
	-Wmissing-prototypes -Wconversion -g -lm \
	-Wno-unused-variable "backlight.c" -o "backlight"

chmod +x "backlight"

