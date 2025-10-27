#!/bin/sh

Describe 'trim'
  It 'exists and is executable'
    The path 'bin/trim' should be file
    The path 'bin/trim' should be executable
  End

  It 'shows usage on stderr when no input'
    When run sh -c 'bin/trim'
    The status should be failure
    The stderr should include "Usage:"
    The stderr should include "Remove leading and trailing whitespace"
  End

  It 'shows usage on stderr with -h'
    When run sh -c 'bin/trim -h'
    The status should be success
    The stderr should include "Usage:"
    The stderr should include "Remove leading and trailing whitespace"
  End

  It 'shows usage on stderr with --help'
    When run sh -c 'bin/trim --help'
    The status should be success
    The stderr should include "Usage:"
    The stderr should include "Remove leading and trailing whitespace"
  End

  It 'removes leading spaces'
    When run sh -c 'echo "  hello" | bin/trim'
    The output should equal "hello"
    The status should be success
  End

  It 'removes trailing spaces'
    When run sh -c 'echo "hello  " | bin/trim'
    The output should equal "hello"
    The status should be success
  End

  It 'removes both leading and trailing spaces'
    When run sh -c 'echo "  hello  " | bin/trim'
    The output should equal "hello"
    The status should be success
  End

  It 'removes leading tabs'
    When run sh -c 'printf "\t\thello\n" | bin/trim'
    The output should equal "hello"
    The status should be success
  End

  It 'removes trailing tabs'
    When run sh -c 'printf "hello\t\t\n" | bin/trim'
    The output should equal "hello"
    The status should be success
  End

  It 'removes both leading and trailing whitespace (spaces and tabs)'
    When run sh -c 'printf "  \thello\t  \n" | bin/trim'
    The output should equal "hello"
    The status should be success
  End

  It 'removes carriage return (CR) whitespace'
    When run sh -c 'printf "\r\thello\r  \n" | bin/trim'
    The output should equal "hello"
    The status should be success
  End

  It 'removes form feed whitespace'
    When run sh -c 'printf "\f hello \f\n" | bin/trim'
    The output should equal "hello"
    The status should be success
  End

  It 'removes vertical tab whitespace'
    When run sh -c 'printf "\v hello \v\n" | bin/trim'
    The output should equal "hello"
    The status should be success
  End

  It 'removes mixed whitespace types (space, tab, CR, LF, VT, FF)'
    When run sh -c 'printf "  \t\r\v\f hello \f\v\r\t  \n" | bin/trim'
    The output should equal "hello"
    The status should be success
  End

  It 'handles lines with only whitespace'
    When run sh -c 'echo "     " | bin/trim'
    The output should equal ""
    The status should be success
  End

  It 'preserves empty lines'
    When run sh -c 'echo "" | bin/trim'
    The output should equal ""
    The status should be success
  End

  It 'preserves intermediate whitespace within text'
    When run sh -c 'echo "  hello   world  " | bin/trim'
    The output should equal "hello   world"
    The status should be success
  End

  It 'processes each line independently'
    When run sh -c 'printf "  line1  \n  line2  \n  line3  \n" | bin/trim'
    The output should equal "line1
line2
line3"
    The status should be success
  End

  It 'works with file input via stdin'
    When run sh -c "tmpfile=$(mktemp) && printf '  test  \n  input  ' > \"\$tmpfile\" && bin/trim < \"\$tmpfile\"; result=\$?; rm -f \"\$tmpfile\"; exit \$result"
    The output should equal "test
input"
    The status should be success
  End

  It 'works in pipelines with other tools'
    When run sh -c 'echo "  hello world  " | bin/trim | wc -c'
    The output should match pattern "*12*"
    The status should be success
  End

  It 'handles lines with special characters and whitespace'
    When run sh -c 'echo "  test@example.com  " | bin/trim'
    The output should equal "test@example.com"
    The status should be success
  End

  It 'prevents command injection attempts'
    When run sh -c 'echo "  ; rm -rf /  " | bin/trim'
    The output should equal "; rm -rf /"
    The status should be success
  End

  It 'handles binary data safely'
    When run sh -c 'printf "  hello  \n" | bin/trim'
    The output should equal "hello"
    The status should be success
  End

  It 'handles very long lines without memory issues'
    # shellcheck disable=SC2016
    When run sh -c 'printf "  %.*s  \n" 10000 "$(yes a | head -10000 | tr -d "\n")" | bin/trim > /dev/null; echo $?'
    The output should equal "0"
    The status should be success
  End

  It 'handles shell metacharacters safely'
    When run sh -c 'echo "  && || | > < \$ ( ) { }  " | bin/trim'
    The output should equal "&& || | > < \$ ( ) { }"
    The status should be success
  End

  It 'handles quotes and backticks safely'
    # shellcheck disable=SC2016
    When run sh -c 'echo "  \"hello\" \`world\`  " | bin/trim'
    The output should equal "\"hello\" \`world\`"
    The status should be success
  End
End

