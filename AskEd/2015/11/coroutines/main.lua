
-- http://www.wellho.net/resources/ex.php4?item=u114/coro

--[[
This program shows how a coroutine routine works - by
starting a function running, then suspending it at
a yield to continue later
]]

local function gimmeval()
	me = 1243
	while (me > 1234) do
		coroutine.yield()
		me = me - 1
		print ("duh") -- says it's in the coroutine
	end
end

print ("Simple co-routine")
instream = coroutine.create(gimmeval)
while coroutine.status(instream) ~= "dead" do
	-- kick coroutine and let it run until
	-- it suspends or dies
	coroutine.resume(instream)
	print (me, "Here - at ")
end