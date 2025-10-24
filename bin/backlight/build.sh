#!/nix/store/ih68ar79msmj0496pgld4r3vqfr7bbin-bash-5.2p37/bin/bash

gcc -xc -std=c89 -ansi -pedantic-errors -pedantic \
	-Wall -Wextra -Werror -Wshadow -Wpointer-arith \
	-Wcast-qual -Wcast-align -Wstrict-prototypes \
	-Wmissing-prototypes -Wconversion -g -lm \
	-Wno-unused-variable "backlight.c" -o "backlight"

chmod +x "backlight"

