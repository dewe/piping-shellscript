#!/bin/sh

Describe 'wrap'
  It 'shows help message'
    When run script bin/wrap --help
    The status should be success
    The stderr should include "Usage:"
    The stderr should include "wrap"
  End

  It 'handles empty input gracefully'
    When run sh -c 'bin/wrap 10 < /dev/null'
    The status should be success
    The output should equal ""
  End

  It 'wraps single line at width 10'
    Data "hello world"
    When run script bin/wrap 10
    The output should equal "hello
world"
    The status should be success
  End

  It 'wraps long line at width 5'
    Data "hello world"
    When run script bin/wrap 5
    The output should equal "hello
world"
    The status should be success
  End

  It 'does not wrap line shorter than width'
    Data "hello"
    When run script bin/wrap 10
    The output should equal "hello"
    The status should be success
  End

  It 'wraps multiple lines'
    Data
    #|hello world
    #|foo bar baz
    End
    When run script bin/wrap 8
    The output should equal "hello
world
foo bar
baz"
    The status should be success
  End

  It 'handles single word longer than width'
    Data "supercalifragilisticexpialidocious"
    When run script bin/wrap 10
    The output should equal "supercalifragilisticexpialidocious"
    The status should be success
  End

  It 'wraps at word boundaries'
    Data "the quick brown fox"
    When run script bin/wrap 12
    The output should equal "the quick
brown fox"
    The status should be success
  End

  It 'handles empty lines'
    Data
    #|hello world
    #|
    #|foo bar
    End
    When run script bin/wrap 8
    The output should equal "hello
world

foo bar"
    The status should be success
  End

  It 'works with file input'
    When run sh -c 'printf "one two three four\n" | bin/wrap 10'
    The output should equal "one two
three four"
    The status should be success
  End

  It 'works in pipeline'
    When run sh -c 'echo "hello world foo bar" | bin/wrap 10 | tr "[:lower:]" "[:upper:]"'
    The output should equal "HELLO
WORLD FOO
BAR"
    The status should be success
  End

  It 'preserves multiple spaces between words'
    Data "hello  world"
    When run script bin/wrap 20
    The output should equal "hello  world"
    The status should be success
  End

  It 'preserves multiple spaces when wrapping'
    Data "hello  world  foo"
    When run script bin/wrap 12
    The output should equal "hello  world
foo"
    The status should be success
  End

  It 'preserves leading spaces'
    Data "  hello world"
    When run script bin/wrap 20
    The output should equal "  hello world"
    The status should be success
  End

  It 'preserves trailing spaces'
    Data "hello world  "
    When run script bin/wrap 20
    The output should equal "hello world  "
    The status should be success
  End

  It 'requires width argument'
    Data "hello"
    When run script bin/wrap
    The status should be failure
    The stderr should include "Usage:"
  End

  It 'requires numeric width'
    Data "hello"
    When run script bin/wrap abc
    The status should be failure
    The stderr should include "Error:"
  End

  It 'requires positive width'
    Data "hello"
    When run script bin/wrap 0
    The status should be failure
    The stderr should include "Error:"
  End

  It 'ensures no output line exceeds specified width'
    Data "the quick brown fox jumps over the lazy dog"
    When run script bin/wrap 15
    The status should be success
    The line 1 of output should equal "the quick brown"
    The line 2 of output should equal "fox jumps over"
    The line 3 of output should equal "the lazy dog"
  End

  It 'verifies all lines are within width limit'
    # Test that wrapping at width 10 produces no lines longer than 10 chars
    When run sh -c 'echo "hello world foo bar baz" | bin/wrap 10 | awk "length > 10 { print \"Line too long: \" \$0; exit 1 }"'
    The status should be success
  End

  It 'verifies width constraint with wrappable text'
    Data
    #|the quick brown fox jumps
    #|over the lazy dog runs
    #|hello world today
    End
    When run sh -c 'bin/wrap 12 | awk "length > 12 { print \"Line too long: \" \$0; exit 1 }"'
    The status should be success
  End

  It 'allows single words longer than width to pass through'
    # Words that cannot be broken are allowed to exceed width
    Data "supercalifragilisticexpialidocious"
    When run script bin/wrap 10
    The output should equal "supercalifragilisticexpialidocious"
    The status should be success
  End
End

