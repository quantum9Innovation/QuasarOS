wlr-randr: screen_off: sleep: {
  script = ''hdmi_present=$(${wlr-randr} | grep -q "HDMI" && echo true || echo false); if [ "$hdmi_present" = "true" ]; then ${screen_off}; else ${sleep}; fi;'';
}
