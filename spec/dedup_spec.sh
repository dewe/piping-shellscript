#!/bin/sh

Describe 'dedup'
  It 'exists and is executable'
    The path 'bin/dedup' should be file
    The path 'bin/dedup' should be executable
  End

  It 'shows usage on stderr when no input'
    When run sh -c 'bin/dedup'
    The status should be failure
    The stderr should include "Usage:"
    The stderr should include "dedup"
  End

  It 'shows usage on stderr with -h'
    When run sh -c 'bin/dedup -h'
    The status should be success
    The stderr should include "Usage:"
    The stderr should include "dedup"
  End

  It 'shows usage on stderr with --help'
    When run sh -c 'bin/dedup --help'
    The status should be success
    The stderr should include "Usage:"
    The stderr should include "dedup"
  End

  It 'removes duplicate lines'
    When run sh -c 'printf "apple\nbanana\napple\norange" | bin/dedup'
    The output should equal "apple
banana
orange"
    The status should be success
  End

  It 'preserves first occurrence of duplicates'
    When run sh -c 'printf "apple\nbanana\napple\napple\nbanana" | bin/dedup'
    The output should equal "apple
banana"
    The status should be success
  End

  It 'handles empty input gracefully'
    When run sh -c 'echo "" | bin/dedup'
    The output should equal ""
    The status should be success
  End

  It 'handles all identical lines'
    When run sh -c 'printf "apple\napple\napple" | bin/dedup'
    The output should equal "apple"
    The status should be success
  End

  It 'processes multiple unique lines'
    When run sh -c 'printf "line1\nline2\nline3" | bin/dedup'
    The output should equal "line1
line2
line3"
    The status should be success
  End

  It 'handles mixed duplicates throughout'
    When run sh -c 'printf "a\nb\na\nc\nb\na" | bin/dedup'
    The output should equal "a
b
c"
    The status should be success
  End

  It 'handles special characters in lines'
    When run sh -c 'printf "hello@world\nhello@world\ntest#123" | bin/dedup'
    The output should equal "hello@world
test#123"
    The status should be success
  End

  It 'handles empty lines'
    When run sh -c 'printf "a\n\nb\n\na" | bin/dedup'
    The output should equal "a

b"
    The status should be success
  End

  It 'preserves order of first occurrences'
    When run sh -c 'printf "c\nb\na\na\nb\nc" | bin/dedup'
    The output should equal "c
b
a"
    The status should be success
  End

  It 'works in pipelines with other tools'
    When run sh -c 'printf "a\na\nb\na" | bin/dedup | wc -l'
    The output should match pattern "*2*"
    The status should be success
  End

  It 'works with file input via stdin'
    When run sh -c "tmpfile=$(mktemp) && printf 'line1\nline2\nline1' > \"\$tmpfile\" && bin/dedup < \"\$tmpfile\"; result=\$?; rm -f \"\$tmpfile\"; exit \$result"
    The output should equal "line1
line2"
    The status should be success
  End

  It 'handles large number of duplicates'
    When run sh -c 'printf "a\nb\na\nb\na\nb\na\nb" | bin/dedup'
    The output should equal "a
b"
    The status should be success
  End
End

