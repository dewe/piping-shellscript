#!/bin/sh

# Integration tests for plural_sv script - tests against real Wiktionary API
# These tests require network access

Describe 'plural_sv (integration)'
  It 'fetches real plural from Wiktionary for kvinna'
    When run sh -c 'echo "kvinna" | bin/plural_sv'
    The output should equal "kvinnor"
    The status should be success
  End

  It 'fetches real plural from Wiktionary for hus'
    When run sh -c 'echo "hus" | bin/plural_sv'
    The output should equal "hus"
    The status should be success
  End

  It 'fetches real plural from Wiktionary for äpple'
    When run sh -c 'echo "äpple" | bin/plural_sv'
    The output should equal "äpplen"
    The status should be success
  End

  It 'returns error for non-existent words'
    When run sh -c 'echo "nonexistentwordxyz" | bin/plural_sv'
    The status should be failure
  End
End


