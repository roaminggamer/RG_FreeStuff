local util = {}


-- Easy alert popup
--
-- title - Name on popup.
-- msg - message in popup.
-- buttons - table of tables like this:
-- { { "button 1", opt_func1 }, { "button 2", opt_func2 }, ...}
--
util.easyAlert = function( title, msg, buttons )
	buttons = buttons or { {"OK"} }
	local function onComplete( event )
		local action = event.action
		local index = event.index
		if( action == "clicked" ) then
			local func = buttons[index][2]
			if( func ) then func() end 
	    end
	    --native.cancelAlert()
	end

	local names = {}
	for i = 1, #buttons do
		names[i] = buttons[i][1]
	end
	--print( title, msg, names, onComplete )
	local alert = native.showAlert( title, msg, names, onComplete )
	return alert
end

function util.trace( msg, depth )
   if( not debug or not debug.traceback ) then return "" end
   depth = depth or 1

   if( type(msg) == "function" ) then
      local funcInfo = debug.getinfo(msg)
      msg = "function " ..  funcInfo.source .. ":[" .. funcInfo.linedefined .. ", " .. funcInfo.lastlinedefined .. "]"
   end

   local curTime = system.getTimer()
   local ms = curTime % 1000
   local secs = math.floor(curTime / 1000)
   local mins = math.floor(secs / 60)
   local hours = math.floor(mins / 60)
   secs = secs % 60
   mins = mins % 60
   hours = hours % 24
   local sysTime = string.format("(%02d:%02d:%02d:%03d)", hours, mins, secs, ms)
   print( " = > trace " .. sysTime .. msg )
   local info = debug.traceback():split("\n")
   local count = 1
   for i, v in ipairs( info ) do
     count = count + 1
     if( count > 3 and count < (3+depth+1) ) then
         print(tostring(v))
     end
   end
   print()
end

return util