#!/bin/sh

Describe 'plural_sv'
  # Create fake curl script that reads from fixtures
  BeforeAll 'setup_fake_curl'

  setup_fake_curl() {
    MOCK_DIR=$(mktemp -d)
    export SPEC_MOCK_DIR="$MOCK_DIR"
    mkdir -p "$MOCK_DIR"
    
    # Create fake curl that reads from fixtures
    # Handle curl arguments: -s, --max-time, and URL
    cat > "$MOCK_DIR/curl" << 'MOCKEOF'
#!/bin/sh
# Skip flags like -s, --max-time
url=""
for arg in "$@"; do
  if [ "${arg#http}" != "$arg" ] || [ "${arg#https}" != "$arg" ]; then
    url="$arg"
    break
  fi
done

word=$(echo "$url" | sed 's|.*wiki/||')
if [ -f "spec/fixtures/$word.html" ]; then
  cat "spec/fixtures/$word.html"
else
  return 1
fi
MOCKEOF
    chmod +x "$MOCK_DIR/curl"
    export PATH="$MOCK_DIR:$PATH"
  }

  AfterAll 'cleanup_fake_curl'

  cleanup_fake_curl() {
    [ -n "$SPEC_MOCK_DIR" ] && rm -rf "$SPEC_MOCK_DIR"
  }

  It 'exists and is executable'
    The path 'bin/plural_sv' should be file
    The path 'bin/plural_sv' should be executable
  End

  It 'shows usage on stderr when no input'
    When run sh -c 'bin/plural_sv'
    The status should be failure
    The stderr should include "Usage:"
    The stderr should include "plural_sv"
  End

  It 'shows usage on stderr with -h'
    When run sh -c 'bin/plural_sv -h'
    The status should be success
    The stderr should include "Usage:"
    The stderr should include "plural_sv"
  End

  It 'shows usage on stderr with --help'
    When run sh -c 'bin/plural_sv --help'
    The status should be success
    The stderr should include "Usage:"
    The stderr should include "plural_sv"
  End

  # Basic functionality with fake curl (reads from fixtures)
  It 'pluralizes Swedish noun kvinna to kvinnor'
    When run sh -c 'echo "kvinna" | bin/plural_sv'
    The output should equal "kvinnor"
    The status should be success
  End

  It 'handles neuter noun hus (stays the same)'
    When run sh -c 'echo "hus" | bin/plural_sv'
    The output should equal "hus"
    The status should be success
  End

  It 'handles empty input gracefully'
    When run sh -c 'echo "" | bin/plural_sv'
    The output should equal ""
    The status should be success
  End

  It 'processes each line independently'
    When run sh -c 'printf "kvinna\nhus\näpple" | bin/plural_sv'
    The output should equal "kvinnor
hus
äpplen"
    The status should be success
  End

  It 'works in pipelines with other tools'
    When run sh -c 'echo "kvinna" | bin/plural_sv | wc -c'
    The output should match pattern "*8*"
    The status should be success
  End

  It 'works with file input via stdin'
    When run sh -c "tmpfile=$(mktemp) && printf 'kvinna\nhus' > \"\$tmpfile\" && bin/plural_sv < \"\$tmpfile\"; result=\$?; rm -f \"\$tmpfile\"; exit \$result"
    The output should equal "kvinnor
hus"
    The status should be success
  End

  Describe 'security'
    It 'allows valid Swedish words'
      When run sh -c 'echo "kvinna" | bin/plural_sv'
      The status should be success
      The output should equal "kvinnor"
    End

    It 'blocks malicious characters but allows safe fallback'
      When run sh -c 'printf "test;rm" | bin/plural_sv 2>/dev/null'
      The status should be failure
    End
  End
End


