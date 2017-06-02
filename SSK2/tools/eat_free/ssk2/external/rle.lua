-- =============================================================
-- Run Length Encoding Module - Credit: Rosetta Code
-- http://rosettacode.org/wiki/Run-length_encoding#Lua
-- Note: Made some slight modifications
-- =============================================================
-- Tip: Can ONLY be used to encode/decode strings w/o numeric values embedded
local lpeg = require "lpeg"
local rle = {}
if( not _G.ssk ) then
	_G.ssk = {}
end
_G.ssk.rle = rle


local C, Ct, R, Cf, Cc = lpeg.C, lpeg.Ct, lpeg.R, lpeg.Cf, lpeg.Cc
local astable = Ct(C(1)^0)
 
function rle.compress( s )
	s = s or ""
	local t = astable:match(s)
	local ret = {}
	for i, v in ipairs(t) do
		if t[i-1] and v == t[i-1] then
			ret[#ret - 1] = ret[#ret - 1] + 1
		else
			ret[#ret + 1] = 1
			ret[#ret + 1] = v
		end
	end
	return table.concat(ret)
end


local undo = Ct((Cf(Cc"0" * C(R"09")^1, function(a, b) return 10 * a + b end) * C(R"AZ"))^0)
 
function rle.decompress(s)
	local t = undo:match(s)
	local ret = ""
	for i = 1, #t - 1, 2 do
		for _ = 1, t[i] do
			ret = ret .. t[i+1]
		end
	end
	return ret
end

return rle