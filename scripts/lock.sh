#!/bin/sh

B='#00000000'  # blank
C='#ffffff22'  # clear ish
D='#138aee'  # default
T='#ffffff'  # text
W='#45ee12'  # wrong
V='#45ee12'  # verifying
#!/bin/sh
set -e

i3lockmore \
	-e \
	--nofork \
    --dpms 10 \
	--image-fill $HOME/Wallpaper/keyboard_meetup_poster.png \
	--insidever-color=$C   \
	--ringver-color=$V     \
	\
	--insidewrong-color=$C \
	--ringwrong-color=$W   \
	\
	--inside-color=$B      \
	--ring-color=$D        \
	--line-color=$B        \
	--separator-color=$D   \
	\
	--verif-color=$T        \
	--wrong-color=$T        \
	--time-color=$T        \
	--date-color=$T        \
	--layout-color=$T      \
	--keyhl-color=$W       \
	--bshl-color=$W        \
	\
	--screen 1            \
	--blur 5              \
	--clock               \
	--indicator           \
	# --timestr="%H:%M:%S"  \
	# --datestr="%A, %m %Y" \
	--veriftext="..." \
	--wrongtext="Nah" \

xset -dpms
