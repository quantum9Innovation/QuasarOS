quasar: {
  kbd = ''
    (defcfg
      input  (device-file "/dev/input/by-id/${quasar.kmonad.keyboard}")
      output (uinput-sink "kmonad output")
      fallthrough true
      allow-cmd false
    )

    (deflayer qwerty
      # swap caps and esc
      caps  esc
      esc   caps
    )'';
}
