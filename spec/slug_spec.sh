#!/bin/sh

Describe 'slug'
  It 'exists and is executable'
    The path 'bin/slug' should be file
    The path 'bin/slug' should be executable
  End

  It 'shows usage on stderr when no input'
    When run sh -c 'bin/slug'
    The status should be failure
    The stderr should include "Usage:"
    The stderr should include "Slugify"
  End

  It 'shows usage on stderr with -h'
    When run sh -c 'bin/slug -h'
    The status should be success
    The stderr should include "Usage:"
    The stderr should include "Slugify"
  End

  It 'shows usage on stderr with --help'
    When run sh -c 'bin/slug --help'
    The status should be success
    The stderr should include "Usage:"
    The stderr should include "Slugify"
  End

  It 'converts to lowercase and replaces spaces with hyphens'
    When run sh -c 'echo "Hello World" | bin/slug'
    The output should equal "hello-world"
    The status should be success
  End

  It 'replaces special characters with hyphens'
    When run sh -c 'echo "Hello@World#Test" | bin/slug'
    The output should equal "hello-world-test"
    The status should be success
  End

  It 'collapses consecutive special characters into single hyphen'
    When run sh -c 'echo "Hello   World!!!Test" | bin/slug'
    The output should equal "hello-world-test"
    The status should be success
  End

  It 'removes leading and trailing hyphens'
    When run sh -c 'echo "!!!Hello World!!!" | bin/slug'
    The output should equal "hello-world"
    The status should be success
  End

  It 'processes each line independently'
    When run sh -c 'printf "Hello World\nTest Line\nAnother Test" | bin/slug'
    The output should equal "hello-world
test-line
another-test"
    The status should be success
  End

  It 'handles empty input gracefully'
    When run sh -c 'echo "" | bin/slug'
    The output should equal ""
    The status should be success
  End

  # Should this result in an empty string or an error?
  It 'handles input with only special characters'
    When run sh -c 'echo "!!!@@@###" | bin/slug'
    The output should equal ""
    The status should be success
  End

  It 'preserves alphanumeric characters'
    When run sh -c 'echo "Hello123World" | bin/slug'
    The output should equal "hello123world"
    The status should be success
  End

  It 'works in pipelines with other tools'
    When run sh -c 'echo "Hello World" | bin/slug | wc -c'
    The output should match pattern "*12*"
    The status should be success
  End

  It 'works with file input via stdin'
    When run sh -c "tmpfile=$(mktemp) && printf 'Test File\nInput Line' > \"\$tmpfile\" && bin/slug < \"\$tmpfile\"; result=\$?; rm -f \"\$tmpfile\"; exit \$result"
    The output should equal "test-file
input-line"
    The status should be success
  End

  It 'handles complex real-world slugification'
    When run sh -c 'echo "My Awesome Blog Post #1 (2024)!!!" | bin/slug'
    The output should equal "my-awesome-blog-post-1-2024"
    The status should be success
  End
End
