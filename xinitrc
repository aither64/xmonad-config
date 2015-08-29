. /home/aither/.bashrc

[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

xsetroot -cursor_name left_ptr

setxkbmap -option grp:switch,grp:alt_shift_toggle us,cz_qwerty                                                       
xmodmap ~/.Xmodmap

xhost si:localuser:browser si:localuser:android si:localuser:steam si:localuser:gaming

redshift -l 50:15 -t 5500:4200 &
trayer-srg --edge top --align right --SetDockType true --SetPartialStrut true \
       --expand true --width 10 --transparent true --tint 0x191970 --height 17 &

firefox &
thunderbird &
pidgin &
gmpc &
xfce4-volumed &
haveclip &

exec xmonad

