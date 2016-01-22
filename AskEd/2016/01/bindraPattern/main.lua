-- =============================================================
-- Ask Ed 2016
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2016 (http://roaminggamer.com/)
-- =============================================================

local function doPatt1( max )
	for i = max, 2, -1 do
		local out = ""
		for k = 1, i do
			out = out .. tostring( k )
		end
		print(out)
	end
	print(1)
	for i = 2, max do
		local out = ""
		for k = 1, i do
			out = out .. tostring( k )
		end
		print(out)
	end
end

local function doPatt2( max )
	for i = 1, max do
		local out = ""
		for k = 1, i do
			out = out .. "1"
		end
		print(out)
	end
end



doPatt1(4)

print("\n=====================================\n")

doPatt2(4)

