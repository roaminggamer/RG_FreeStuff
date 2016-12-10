local public = {}

local daysInMonth = { 31,28,31,30,31,30,31,31,30,31,30,31 }
function public.now()
	local y = tonumber(os.date("%y"))
	local m = tonumber(os.date("%m"))
	local d = tonumber(os.date("%d"))
	local h = tonumber(os.date("%H"))
	local min = tonumber(os.date("%M"))
	local s = tonumber(os.date("%S"))

	local retval 
	retval = ( 60 * 60 * 24 * 365 * (y-1) ) + d
	if( m ~= 1 ) then		
		for i = m-1, 1, -1 do
			retval = retval + (daysInMonth[i] * 24 * 60 * 60)
		end
	end

	if( h ~= 0 ) then		
		retval = retval + ((h-1) * 60 * 60)
	end
	retval = retval +  60 * min
	retval = retval + s
	return retval
end


function public.timeSince( startSeconds )
	startSeconds = startSeconds or 0
	return public.now() - startSeconds
end

return public
