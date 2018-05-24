io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
-- =====================================================
-- =====================================================

--https://docs.coronalabs.com/plugin/bit/index.html
local bit = require( "plugin.bit" )


--http://bitop.luajit.org/api.html
local function printx(x)
  print("0x"..bit.tohex(x))
end

print(0xffffffff)                --> 4294967295 (*)
print(bit.tobit(0xffffffff))     --> -1
printx(bit.tobit(0xffffffff))    --> 0xffffffff
print(bit.tobit(0xffffffff + 1)) --> 0
print(bit.tobit(2^40 + 1234))    --> 1234