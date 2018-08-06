-- =============================================================
-- benchHarness.lua
-- =============================================================

local emailData = false
local json = require "json"

local tests 

local coronaBench = require "coronaBench"

local lastResults

_G.setLastResults = function( results )
	lastResults = results
	table.dump(lastResults.frameTimes)
end

function convertSecondsToTimer( seconds )
	local seconds = tonumber(seconds)
	local minutes = math.floor(seconds/60)
	local remainingSeconds = seconds - (minutes * 60)

	local timerVal = "" 

	if(remainingSeconds < 10) then
		timerVal =  minutes .. ":" .. "0" .. remainingSeconds
	else
		timerVal = minutes .. ":"  .. remainingSeconds
	end

	return timerVal
end


local deviceID = system.getInfo("deviceID")
local build = system.getInfo("build")
local model = system.getInfo("model")
local time = system.getTimer()
local benchFileName = "benchData_" .. build .. "_" .. model .. "_" .. string.sub(deviceID, 1, 4) .. ".txt"
print(deviceID,benchFileName)

local startRunTime = 0
local endRunTime = 0

local benchRunnerCO
local function benchRunner()

	local outputGroup = display.newGroup()

	io.writeFile( "started", "cbLastRun.txt" )

	io.writeFile( "**** BENCH DATA ***** ", benchFileName )
	startRunTime = system.getTimer()
	io.appendFile( "\nSTARTED:" .. startRunTime .. "\n***************************************", benchFileName )

	local infoValues = {}
	local infoStrings = {
		"androidAppVersionCode",
		"androidAppPackageName",
		"androidDisplayApproximateDpi",
		"androidDisplayDensityName",
		"androidDisplayWidthInInches",
		"androidDisplayHeightInInches",
		"androidDisplayXDpi",
		"androidDisplayYDpi",
		"appName",
		"appVersionString",
		"architectureInfo",
		"build",
		"deviceID",
		"environment",
		"iosAdvertisingIdentifier",
		"iosAdvertisingTrackingEnabled",
		"iosIdentifierForVendor",
		"model",
		"name",
		"platformName",
		"platformVersion",
		"maxTextureSize",
		"maxTextureUnits",
		"targetAppStore",
		"textureMemoryUsed",
	}

	for i = 1, #infoStrings do
		local tmp = infoStrings[i]
		infoValues[tmp] = system.getInfo(tmp)
		--print(i, tmp, infoValues[tmp] )		
	end

	infoValues.cbench_buildDate = 130622


	local sysInfo = json.encode( infoValues )
	io.appendFile( "\n" , benchFileName )
	io.appendFile( sysInfo, benchFileName )

	io.appendFile( "\n" .. sysInfo, "cbLastRun.txt" )



	for i = 1, #tests do
		print("\n----------------------------------------")
		print ("Starting test # ", i, tests[i] )	
		io.appendFile( "\n" .. tests[i] .. " - create", "cbLastRun.txt" )
		--ssk.debug.monitorMem()
		coronaBench:create( tests[i] )
		--print("Created...")

		io.appendFile( "\n" .. tests[i] .. " - run", "cbLastRun.txt" )
		coronaBench:run( benchRunnerCO ) 
		
		coroutine.yield() -- Let benchmark take over and wait for resume...
		
		io.appendFile( "\n" .. tests[i] .. " - accumulate", "cbLastRun.txt" )
		coronaBench:accumulate()
		
		io.appendFile( "\n" .. tests[i] .. " - getResults", "cbLastRun.txt" )
		local results = coronaBench:getResults()
		
		--EFM RESULTS REDUCTO
		results.values = nil
		results.perFrameFPS = nil
		
		if( results.avgFPS ) then print("Average FPS", results.avgFPS) end
		--table.dump(results)
		--table.print_r(results)
		--local durations = results.durations
		--print(#durations)
		
		local jresults = json.encode( results )
		
		io.appendFile( "\n" , benchFileName )
		io.appendFile( jresults, benchFileName )
		
		--table.dump( results )
		--table.dump( results.perFrameFPS )

----[[
		if( results.benchType == "ops" ) then
			local msg = results.OPSMessage .. " - " .. results.benchName
			--print( msg )
			ssk.easyIFC:quickLabel( outputGroup, msg, centerX, i * 14, nil, 10 )

		elseif( results.benchType == "mem" ) then
			local msg = results.memMsg .. " - " .. results.benchName
			--print( msg )
			ssk.easyIFC:quickLabel( outputGroup, msg, centerX, i * 14, nil, 10 )

		
		elseif( results.benchType == "fps" ) then
			local msg = "Avg FPS: " .. round(results.avgFPS)
			msg = msg .. " | Min FPS: " .. round(results.minFPS)
			msg = msg .. " | Max FPS: " .. round(results.maxFPS)
--			msg = msg .. " | Mean: " .. round(results.mean)
--			msg = msg .. " | STDEV: " .. round(100 * results.stddev/results.mean,2) .. "%"
			msg = msg .. " | " .. results.benchName
			--print( msg )
			ssk.easyIFC:quickLabel( outputGroup, msg, centerX, i * 14, nil, 10 )		
		end

--]]

		results = nil

		io.appendFile( "\n" .. tests[i] .. " - destroy", "cbLastRun.txt" )
		coronaBench:destroy()

		print ("Finished test # ", i, tests[i] )	
	end

	endRunTime = system.getTimer()
	io.appendFile( "\n***************************************\nFINISHED:" .. endRunTime, benchFileName )

	io.appendFile( "\n" .. "finished", "cbLastRun.txt" )

	
	ssk.easyIFC:quickLabel( outputGroup, "\n\nThanks for running CBench!", centerX, (#tests + 2) * 14 , nil, 18, _GREEN_ )		
	ssk.easyIFC:quickLabel( outputGroup, "\n\nBenchmark Duration: " .. convertSecondsToTimer((endRunTime - startRunTime)/1000), centerX, (#tests + 4 ) * 14 , nil, 18, _BRIGHTORANGE_ )		
	ssk.easyIFC:quickLabel( outputGroup, "\n\nTouch and Drag to Scroll Results", centerX, (#tests + 6) * 14, nil, 18,_YELLOW_ )		

	outputGroup:setReferencePoint( display.BottomCenterReferencePoint )
	outputGroup.y = h

	outputGroup.touch = function(self, event)
		if(event.phase == "began") then
			self.y0 = self.y
		elseif(event.phase == "moved") then
			self.y = self.y0 + event.y - event.yStart
		end
		return true			
	end

	Runtime:addEventListener( "touch", outputGroup )

	local benchfileData = io.readFile( benchFileName )


	local options =
	{
		to = { "roaminggamer+130622@gmail.com" },
		subject = "130622 - CBench Data",
		isBodyHtml = true,
		body = "<html><body>Report in body of e-mail. \n" ..   benchfileData ..	   "</body></html>",
		attachment =
		{
			{ baseDir=system.DocumentsDirectory, filename=benchFileName, type="text/plain" },
		},
	}

	if( emailData ) then
		print("Send e-mail")
		native.showPopup("mail", options)		
	end

end 
-- Create the bench runner co-routine
benchRunnerCO = coroutine.create( benchRunner )

--print(collectgarbage( "setpause", 8000 ))
--print(collectgarbage( "setstepmul", 10 ))

-- Start the bench runner co-routine


local public = {}


public.run = function( theTests )
	tests = theTests or {"math_misc_emptyloop"}	
	coroutine.resume( benchRunnerCO )
end

return public
	





