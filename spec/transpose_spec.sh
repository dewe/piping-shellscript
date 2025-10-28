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
End

