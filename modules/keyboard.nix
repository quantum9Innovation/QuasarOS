quasar: {
  kbd = ''
    (defcfg
      input  (device-file "/dev/input/by-id/${quasar.kmonad.keyboard}")
      output (uinput-sink "kmonad output")
      fallthrough true
      allow-cmd false
    )

    (defsrc
      esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11   f12 home end  del
      grv  1    2    3    4    5    6    7    8    9    0    -     =        bspc
      tab  q    w    e    r    t    y    u    i    o    p    [     ]        ret
      caps a    s    d    f    g    h    j    k    l    ;    '     `        ret
      lsft \    z    x    c    v    b    n    m    ,    .    /              rsft
           lctl lmet lalt           spc            ralt prnt rctl           up
                                                                       left down rght
    )

    (deflayer qwerty
      caps  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11   f12 home end  del
      grv  1    2    3    4    5    6    7    8    9    0    -     =        bspc
      tab  q    w    e    r    t    y    u    i    o    p    [     ]        ret
      esc a    s    d    f    g    h    j    k    l    ;    '     `         ret
      lsft \    z    x    c    v    b    n    m    ,    .    /              rsft
           lctl lmet lalt           spc            ralt prnt rctl           up
                                                                       left down rght
    )'';
}
