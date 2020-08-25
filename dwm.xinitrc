xrandr && xrandr --output VGA1 --rotate right --right-of HDMI1 && xrandr --addmode VGA1 1680x1050 && xrandr --output VGA1 --mode 1680x1050 &
xrdb .Xresources
fcitx &
lightscreen - &
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
xset s off
xset b off
xset -b
slstatus &
exec dwm
