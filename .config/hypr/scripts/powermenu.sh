if pgrep -x "wlogout" > /dev/null
then
    pkill -x "wlogout"
    exit 0
fi

wLayout="$HOME/.config/wlogout/layout"
wlTmplt="$HOME/.config/wlogout/style.css"

x_mon=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .width')
y_mon=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .height')
hypr_scale=$(hyprctl -j monitors | jq '.[] | select (.focused == true) | .scale' | sed 's/\.//')

export mgn=$(( y_mon * 28 / hypr_scale ))
export hvr=$(( y_mon * 23 / hypr_scale ))

export fntSize=$(( y_mon * 2 / 100 ))

export BtnCol="white"

hypr_border="$(hyprctl -j getoption decoration:rounding | jq '.int')"

export active_rad=$(( hypr_border * 5 ))
export button_rad=$(( hypr_border * 8 ))

hex_to_rgba() {
    hex=$1
    first="${hex:0:1}"

    if [ "#" = "$first" ]; then
	hex="${hex:1:6}"
    fi

    hex_r="${hex:0:2}"
    hex_g="${hex:2:2}"
    hex_b="${hex:4:2}"

    rgba_r=`echo $((0x${hex_r}))`
    rgba_g=`echo $((0x${hex_g}))`
    rgba_b=`echo $((0x${hex_b}))`

    echo "rgba( $rgba_r, $rgba_g, $rgba_b, $2 )"
}

source ~/.cache/wal/colors.sh
export mainbg=$(hex_to_rgba "$color0" "0.7")
export wbactbg=$(hex_to_rgba "$color4" "0.8")
export wbhvrbg=$(hex_to_rgba "$color10" "0.8")

wlColms=6
wlStyle="$(envsubst < $wlTmplt)"

wlogout -b "${wlColms}" -c 0 -r 0 -m 0 --layout "${wLayout}" --css <(echo "${wlStyle}") --protocol layer-shell
