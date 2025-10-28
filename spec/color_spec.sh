#!/bin/sh

Describe 'color'
  It 'exists and is executable'
    The path 'bin/color' should be file
    The path 'bin/color' should be executable
  End

  It 'shows usage on stderr when no input'
    When run sh -c 'bin/color'
    The status should be failure
    The stderr should include "Usage:"
    The stderr should include "color"
  End

  It 'shows usage on stderr with -h'
    When run sh -c 'bin/color -h'
    The status should be success
    The stderr should include "Usage:"
    The stderr should include "color"
  End

  It 'shows usage on stderr with --help'
    When run sh -c 'bin/color --help'
    The status should be success
    The stderr should include "Usage:"
    The stderr should include "color"
  End

  It 'shows error for invalid color'
    When run sh -c 'echo "test" | bin/color invalid'
    The status should be failure
    The stderr should include "invalid"
  End

  It 'colors text red'
    When run sh -c 'echo "test" | bin/color red'
    The output should include "test"
    The output should include "[31"  # ANSI red escape code
    The status should be success
  End

  It 'colors text green'
    When run sh -c 'echo "test" | bin/color green'
    The output should include "test"
    The output should include "[32"  # ANSI green escape code
    The status should be success
  End

  It 'colors text yellow'
    When run sh -c 'echo "test" | bin/color yellow'
    The output should include "test"
    The output should include "[33"  # ANSI yellow escape code
    The status should be success
  End

  It 'colors text blue'
    When run sh -c 'echo "test" | bin/color blue'
    The output should include "test"
    The output should include "[34"  # ANSI blue escape code
    The status should be success
  End

  It 'colors text magenta'
    When run sh -c 'echo "test" | bin/color magenta'
    The output should include "test"
    The output should include "[35"  # ANSI magenta escape code
    The status should be success
  End

  It 'colors text cyan'
    When run sh -c 'echo "test" | bin/color cyan'
    The output should include "test"
    The output should include "[36"  # ANSI cyan escape code
    The status should be success
  End

  It 'colors text white'
    When run sh -c 'echo "test" | bin/color white'
    The output should include "test"
    The output should include "[37"  # ANSI white escape code
    The status should be success
  End

  It 'colors text black'
    When run sh -c 'echo "test" | bin/color black'
    The output should include "test"
    The output should include "[90"  # ANSI black escape code
    The status should be success
  End

  It 'processes each line independently'
    When run sh -c 'printf "line1\nline2\nline3" | bin/color red'
    The output should include "line1"
    The output should include "line2"
    The output should include "line3"
    The status should be success
  End

  It 'handles empty input gracefully'
    When run sh -c 'echo "" | bin/color red'
    The output should equal ""
    The status should be success
  End

  It 'preserves empty lines'
    When run sh -c 'printf "line1\n\nline2" | bin/color red'
    The output should include "line1"
    The output should include "line2"
    The status should be success
  End

  It 'works in pipelines with other tools'
    When run sh -c 'echo "test" | bin/color red | grep -q "test"; echo $?'
    The output should equal "0"
    The status should be success
  End

  It 'works with file input via stdin'
    When run sh -c "tmpfile=$(mktemp) && printf 'line1\nline2' > \"\$tmpfile\" && bin/color red < \"\$tmpfile\"; result=\$?; rm -f \"\$tmpfile\"; exit \$result"
    The output should include "line1"
    The output should include "line2"
    The status should be success
  End

  It 'handles special characters in text'
    When run sh -c 'echo "test@example.com" | bin/color red'
    The output should include "test@example.com"
    The status should be success
  End

  It 'handles text with shell metacharacters safely'
    When run sh -c 'echo "&& || | > < \$ ( ) { }" | bin/color red'
    The output should include "&&"
    The status should be success
  End

  It 'handles multiline text correctly'
    When run sh -c 'printf "first line\nsecond line\nthird line" | bin/color red'
    The output should include "first line"
    The output should include "second line"
    The output should include "third line"
    The status should be success
  End

  It 'resets color after output'
    When run sh -c 'echo "test" | bin/color red | hexdump -C'
    The output should include "30 6d"
    The status should be success
  End

  It 'handles case-insensitive color names'
    When run sh -c 'echo "test" | bin/color RED'
    The output should include "test"
    The output should include "[31"  # ANSI red escape code
    The status should be success
  End

  It 'handles mixed case color names'
    When run sh -c 'echo "test" | bin/color ReD'
    The output should include "test"
    The output should include "[31"  # ANSI red escape code
    The status should be success
  End

  It 'generates different random colors across multiple calls'
    # shellcheck disable=SC2016
    When run sh -c '
      output=$(for i in 1 2; do echo "x" | bin/color random; done)
      unique_colors=$(printf "%s\n" "$output" | grep -o "\[3[0-9]m\|\[9[0-9]m" | sort -u | wc -l | tr -d " ")
      [ "$unique_colors" -eq 2 ]
    '
    The status should be success
  End

  It 'never outputs two consecutive equal color codes with random'
    # shellcheck disable=SC2016
    When run sh -c '
      printf "line1\nline2\nline3\nline4\nline5" | bin/color random > /tmp/color_output
      colors=$(grep -oE "\[[39][0-7]m" /tmp/color_output | sed "s/\[//;s/m//")
      result=0
      last_color=""
      for color in $colors; do
        if [ "$color" = "$last_color" ]; then
          result=1
          break
        fi
        last_color="$color"
      done
      rm -f /tmp/color_output
      exit $result
    '
    The status should be success
  End
End

