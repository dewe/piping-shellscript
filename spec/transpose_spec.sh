#!/bin/sh

Describe 'transpose'
  It 'shows help message'
    When run script bin/transpose --help
    The status should be success
    The stderr should include "Usage:"
    The stderr should include "transpose"
  End

  It 'handles empty input gracefully'
    When run sh -c 'bin/transpose < /dev/null'
    The status should be success
    The output should equal ""
  End

  It 'transposes single line'
    Data "hello"
    When run script bin/transpose
    The output should equal "h
e
l
l
o"
    The status should be success
  End

  It 'transposes two lines'
    Data
    #|hello
    #|world
    End
    When run script bin/transpose
    The output should equal "hw
eo
lr
ll
od"
    The status should be success
  End

  It 'transposes three lines with different lengths'
    Data
    #|hello
    #|sunny
    #|world
    End
    When run script bin/transpose
    The output should equal "hsw
euo
lnr
lnl
oyd"
    The status should be success
  End

  It 'transposes lines with unequal length'
    Data
    #|a
    #|bb
    #|ccc
    End
    When run script bin/transpose
    The output should equal "abc
 bc
  c"
    The status should be success
  End

  It 'handles empty lines'
    Data
    #|hello
    #|
    #|world
    End
    When run script bin/transpose
    The output should equal "h w
e o
l r
l l
o d"
    The status should be success
  End

  It 'works with file input'
    When run sh -c 'printf "one\ntwo\n" | bin/transpose'
    The output should equal "ot
nw
eo"
    The status should be success
  End

  It 'works in pipeline'
    When run sh -c 'printf "ab\ncd\n" | bin/transpose | tr "[:lower:]" "[:upper:]"'
    The output should equal "AC
BD"
    The status should be success
  End

  It 'handles single character lines'
    Data
    #|a
    #|b
    #|c
    End
    When run script bin/transpose
    The output should equal "abc"
    The status should be success
  End

  It 'handles multiple empty lines between words'
    Data
    #|hello
    #|
    #|beautiful
    #|
    #|world
    End
    When run script bin/transpose
    The output should equal "h b w
e e o
l a r
l u l
o t d
  i
  f
  u
  l"
    The status should be success
  End

  It 'handles lines of different lengths without empty lines'
    Data
    #|hello
    #|beautiful
    #|world
    End
    When run script bin/transpose
    The output should equal "hbw
eeo
lar
lul
otd
 i
 f
 u
 l"
    The status should be success
  End

  It 'handles ANSI color codes correctly'
    # When transposing colored text, the ANSI escape sequences should not be
    # counted as characters. The color from each input line should be preserved
    # vertically in the output (first line's color -> first column's color).
    When run sh -c 'printf "\033[34mhello\033[0m\n\033[31mworld\033[0m\n" | bin/transpose'
    The output should equal "$(printf '%s%s\n%s%s\n%s%s\n%s%s\n%s%s' \
      "$(printf '\033[34mh\033[0m')" "$(printf '\033[31mw\033[0m')" \
      "$(printf '\033[34me\033[0m')" "$(printf '\033[31mo\033[0m')" \
      "$(printf '\033[34ml\033[0m')" "$(printf '\033[31mr\033[0m')" \
      "$(printf '\033[34ml\033[0m')" "$(printf '\033[31ml\033[0m')" \
      "$(printf '\033[34mo\033[0m')" "$(printf '\033[31md\033[0m')")"
    The status should be success
  End

  It 'works with color script in pipeline'
    # Integration test: color + transpose should preserve colors vertically
    # shellcheck disable=SC2016
    When run sh -c 'printf "hello\nworld\n" | while IFS= read -r line; do echo "$line" | bin/color blue; done | bin/transpose'
    The line 1 of output should start with "$(printf "\033[34m")"
    The line 2 of output should start with "$(printf "\033[34m")"
    The status should be success
  End

  It 'handles double transpose of colored text'
    # Double transposing colored text should return the original structure:
    # Colored lines -> transpose -> colored columns -> transpose -> colored lines
    # The visual output should match the input (colors should be preserved)
    When run sh -c 'printf "a\nbb\nccc\n" | bin/color blue | bin/transpose | bin/transpose'
    # First line should be: blue "a" + reset + space + space (no extra color codes)
    The line 1 of output should equal "$(printf "\033[34ma\033[0m")"
    # Second line should be: blue "bb" + reset
    The line 2 of output should equal "$(printf "\033[34mbb\033[0m")"
    # Third line should be: blue "ccc" + reset
    The line 3 of output should equal "$(printf "\033[34mccc\033[0m")"
    The status should be success
  End
End

