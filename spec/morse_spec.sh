#!/bin/sh

Describe 'morse'
  It 'exists and is executable'
    The path 'bin/morse' should be file
    The path 'bin/morse' should be executable
  End

  It 'shows usage on stderr when no input'
    When run sh -c 'bin/morse'
    The status should be failure
    The stderr should include "Usage:"
    The stderr should include "Convert text to Morse code"
  End

  It 'shows usage on stderr with -h'
    When run sh -c 'bin/morse -h'
    The status should be success
    The stderr should include "Usage:"
    The stderr should include "Convert text to Morse code"
  End

  It 'shows usage on stderr with --help'
    When run sh -c 'bin/morse --help'
    The status should be success
    The stderr should include "Usage:"
    The stderr should include "Convert text to Morse code"
  End

  It 'converts letters to Morse code preserving order'
    When run sh -c 'echo "SOS" | bin/morse'
    The output should equal "... --- ..."
    The status should be success
  End

  It 'is case-insensitive'
    When run sh -c 'echo "sos" | bin/morse'
    The output should equal "... --- ..."
    The status should be success
  End

  It 'separates words with slashes'
    When run sh -c 'echo "Hello World" | bin/morse'
    The output should equal ".... . .-.. .-.. --- / .-- --- .-. .-.. -.."
    The status should be success
  End

  It 'encodes digits and punctuation'
    When run sh -c 'echo "Wait, 2?" | bin/morse'
    The output should equal ".-- .- .. - --..-- / ..--- ..--.."
    The status should be success
  End

  It 'marks unknown characters with question mark'
    When run sh -c 'echo "Hi#" | bin/morse'
    The output should equal ".... .. ?"
    The status should be success
  End

  It 'processes multiple lines independently'
    When run sh -c 'printf "SOS\nHELP" | bin/morse'
    The output should equal "... --- ...
.... . .-.. .--."
    The status should be success
  End

  It 'handles empty input line'
    When run sh -c 'printf "\n" | bin/morse'
    The output should equal ""
    The status should be success
  End

  It 'works in pipelines with other tools'
    When run sh -c 'echo "SOS" | bin/morse | wc -c'
    The output should match pattern "*12*"
    The status should be success
  End

  It 'accepts file input via stdin redirection'
    When run sh -c "tmpfile=$(mktemp) && printf 'SOS\nHELP' > \"\$tmpfile\" && bin/morse < \"\$tmpfile\"; result=\$?; rm -f \"\$tmpfile\"; exit \$result"
    The output should equal "... --- ...
.... . .-.. .--."
    The status should be success
  End

  It 'encodes Nordic characters (lowercase) å ä ö ø æ'
    When run sh -c 'echo "å ä ö ø æ" | bin/morse'
    The output should equal ".--.- / .-.- / ---. / ---. / .-.-"
    The status should be success
  End

  It 'encodes Nordic characters (uppercase) Å Ä Ö Ø Æ'
    When run sh -c 'echo "Å Ä Ö Ø Æ" | bin/morse'
    The output should equal ".--.- / .-.- / ---. / ---. / .-.-"
    The status should be success
  End
  
  Context 'decode mode (-d|--decode)'
    It 'decodes a single letter'
      When run sh -c "echo '...' | bin/morse -d"
      The output should equal "S"
      The status should be success
    End

    It 'decodes a single word'
      When run sh -c "echo '.... . .-.. .-.. ---' | bin/morse -d"
      The output should equal "HELLO"
      The status should be success
    End

    It 'supports word separator using /'
      When run sh -c "echo '... --- ... / ... --- ...' | bin/morse -d"
      The output should equal "SOS SOS"
      The status should be success
    End

    It 'round-trips through encode then decode'
      When run sh -c "echo 'Hello, World!' | bin/morse | bin/morse -d"
      The output should equal "HELLO, WORLD!"
      The status should be success
    End

    It 'marks unknown sequences with question mark'
      When run sh -c "echo '..-. -.-.-' | bin/morse -d"
      The output should equal "F?"
      The status should be success
    End

    It 'processes multiple lines independently'
      When run sh -c 'printf "... --- ...\n.... . .-.. .-.. ---" | bin/morse -d'
      The output should equal "SOS
HELLO"
      The status should be success
    End

    It 'handles empty input line'
      When run sh -c "printf '\n' | bin/morse -d"
      The output should equal ""
      The status should be success
    End

    It 'tolerates extra whitespace between tokens and around /'
      When run sh -c "printf '...   ---  ...  /    ....\t.\t.-..\t.-..\t---\n' | bin/morse -d"
      The output should equal "SOS HELLO"
      The status should be success
    End

    It 'accepts file input via stdin redirection'
      When run sh -c "tmpfile=$(mktemp) && printf '... --- ...\n.... . .-.. .-.. ---' > \"\$tmpfile\" && bin/morse -d < \"\$tmpfile\"; result=\$?; rm -f \"\$tmpfile\"; exit \$result"
      The output should equal "SOS
HELLO"
      The status should be success
    End
  End
End

