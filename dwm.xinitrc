export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
xrandr --output DP-2 --rotate left
setxkbmap us
xrdb .Xresources
lightscreen - &
fcitx5 &
xset s off
xset b off
xset -b
slstatus &
unclutter &
exec dwm
