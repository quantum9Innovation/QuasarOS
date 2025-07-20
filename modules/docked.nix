wlr-randr: screen_off: sleep: {
  script = ''
    hdmi_present=$(${wlr-randr} | grep -q "HDMI" && echo true || echo false)
    if [ "$hdmi_present" = "true" ]; then
      # HDMI is connected, perform actions for docked mode (only turn off screen)
      ${screen_off}
    else
      # HDMI is not connected, perform actions for undocked mode
      ${sleep}
    fi
  '';
}
