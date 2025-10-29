#!/bin/sh

Describe 'justify'
  It 'shows help message'
    When run script bin/justify --help
    The status should be success
    The stderr should include "Usage:"
    The stderr should include "justify"
  End

  It 'handles empty input gracefully'
    When run sh -c 'bin/justify 20 left < /dev/null'
    The status should be success
    The output should equal ""
  End

  It 'justifies left with padding'
    Data "hello"
    When run script bin/justify 20 left
    The output should equal "hello               "
    The status should be success
  End

  It 'justifies right with padding'
    Data "hello"
    When run script bin/justify 20 right
    The output should equal "               hello"
    The status should be success
  End

  It 'justifies center with even padding'
    Data "hello"
    When run script bin/justify 20 center
    The output should equal "       hello        "
    The status should be success
  End

  It 'justifies center with odd padding - extra space on right'
    Data "hi"
    When run script bin/justify 11 center
    The output should equal "    hi     "
    The status should be success
  End

  It 'leaves line unchanged when exactly equal to width'
    Data "hello world"
    When run script bin/justify 11 left
    The output should equal "hello world"
    The status should be success
  End

  It 'leaves line unchanged when longer than width'
    Data "hello world"
    When run script bin/justify 5 left
    The output should equal "hello world"
    The status should be success
  End

  It 'trims leading whitespace before justifying'
    Data "  hello"
    When run script bin/justify 20 left
    The output should equal "hello               "
    The status should be success
  End

  It 'trims trailing whitespace before justifying'
    Data "hello  "
    When run script bin/justify 20 left
    The output should equal "hello               "
    The status should be success
  End

  It 'collapses multiple spaces between words'
    Data "hello  world"
    When run script bin/justify 20 left
    The output should equal "hello world         "
    The status should be success
  End

  It 'handles empty lines'
    Data ""
    When run script bin/justify 20 left
    The output should equal ""
    The status should be success
  End

  It 'processes multiple lines'
    Data
    #|hello
    #|world
    End
    When run script bin/justify 10 right
    The output should equal "     hello
     world"
    The status should be success
  End

  It 'works with file input'
    When run sh -c 'printf "one\ntwo\n" | bin/justify 10 center'
    The line 1 of output should equal "   one    "
    The line 2 of output should equal "   two    "
    The status should be success
  End

  It 'works in pipeline with wrap'
    When run sh -c 'echo "hello world foo bar" | bin/wrap 10 | bin/justify 15 right'
    The line 1 of output should equal "          hello"
    The line 2 of output should equal "      world foo"
    The line 3 of output should equal "            bar"
    The status should be success
  End

  It 'requires width argument'
    Data "hello"
    When run script bin/justify
    The status should be failure
    The stderr should include "Usage:"
  End

  It 'requires alignment argument'
    Data "hello"
    When run script bin/justify 20
    The status should be failure
    The stderr should include "Usage:"
  End

  It 'requires numeric width'
    Data "hello"
    When run script bin/justify abc left
    The status should be failure
    The stderr should include "Error:"
  End

  It 'requires positive width'
    Data "hello"
    When run script bin/justify 0 left
    The status should be failure
    The stderr should include "Error:"
  End

  It 'requires valid alignment'
    Data "hello"
    When run script bin/justify 20 middle
    The status should be failure
    The stderr should include "Error:"
  End

  It 'accepts case-insensitive alignment'
    Data "hello"
    When run script bin/justify 20 LEFT
    The output should equal "hello               "
    The status should be success
  End

  It 'handles single character'
    Data "x"
    When run script bin/justify 5 center
    The output should equal "  x  "
    The status should be success
  End
End

