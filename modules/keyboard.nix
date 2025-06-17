quasar: {
  kbd = ''
    (defcfg
      input  (device-file "/dev/input/by-id/${quasar.kmonad.keyboard}")
      output (uinput-sink "kmonad output")
      fallthrough true
      allow-cmd false
    )

    (deflayer qwerty
      caps  esc
      esc   caps
    )'';
}
