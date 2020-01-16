xrandr --output VGA-1 --rotate right --right-of HDMI-1 &
fcitx &
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
exec i3
