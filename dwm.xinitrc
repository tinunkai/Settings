xrandr --output VGA-1 --rotate right --right-of HDMI-1 &
fcitx &
lightscreen &
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
xset s off
xset b off
slstatus &
exec dwm
