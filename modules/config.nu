let fish_completer = {|spans|
    fish --command $'complete --escape "--do-complete=($spans | str join " ")"'
    | $"value(char tab)description(char newline)" + $in
    | from tsv --flexible --no-infer
    | each {|i|
        if '\' in $i.value {
            $i | merge {'value': $"\"($i.value | str replace -a '\' '')\""}
        } else {$i}
    }
}
# This completer will use fish by default
let external_completer = {|spans|
    let expanded_alias = scope aliases
    | where name == $spans.0
    | get -i 0.expansion

    let spans = if $expanded_alias != null {
        $spans
        | skip 1
        | prepend ($expanded_alias | split row ' ' | take 1)
    } else {
        $spans
    }

    match $spans.0 {
        # use zoxide completions for zoxide commands
        _ => $fish_completer
    } | do $in $spans
}

$env.config.completions.external.completer = $external_completer
