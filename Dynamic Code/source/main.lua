
local functions = {}

-- First arg is 'reference' to function or the name of that function, the second argument tells the parser whether to expect a value in return
--
-- Note: I don't actually use the 'hasReturn' flag, but I did it this way to show you a way of adding 'details' about individual functions you can use later.
--
functions["print"]         = { cmdRef = "print",          hasReturn = false }
functions["create circle"] = { cmdRef = display.newCircle, hasReturn = true }
functions["set fill last"] = { cmdRef ="setFillColor" ,   hasReturn = false }


local function commandParser( commands )

	local lastRet = {}
	local last 
	local retVal 

	local cmd
	local args

	local cmdRef
	local hasReturn = false

	for i = 1, #commands do
		cmd       = commands[i].cmd
		args      = commands[i].args

		cmdRef    = functions[cmd].cmdRef
		hasReturn = functions[cmd].hasReturn

		last = lastRet[#lastRet] -- May be nil

		print( "-------------------------------------------" )
		print( i, cmd, unpack(args), cmdRef, hasReturn )	

		retVal = nil
		
		-- Print Handler
		--
		if(	cmd == "print" ) then
			cmdRef = _G[cmdRef] -- Get the print function out of the globals table
			retVal = cmdRef( unpack( args ) )

		elseif(	cmd == "create circle" ) then
			retVal = cmdRef( unpack( args ) )

		elseif(	cmd == "set fill last" ) then
			cmdRef = last[cmdRef] -- Get a reference to 'setFillColor' off of the last object we created
			retVal = cmdRef( last, unpack( args ) ) -- Call setFillColor like a function and pass last object as first argument
		
		end

		-- Store return value if found
		if(retVal) then
		   lastRet[#lastRet] = retVal
		  end	
	
	end
end


-- ===================================================================
-- === NOW LET'S USE THE ABOVE 'PARSER'
-- ===================================================================

local tableOfCommands = {}
-- cmd - command to execute
-- args - arguments to pass to command
--
tableOfCommands[1] = { cmd = "print", args = { "hello", "this is a", "test", 0xed15c001 } }
tableOfCommands[2] = { cmd = "create circle", args = { 100, 100, 20 } }
tableOfCommands[3] = { cmd = "set fill last", args = { 255, 0, 0 } }
tableOfCommands[4] = { cmd = "create circle", args = { 200, 150, 25 } }
tableOfCommands[5] = { cmd = "set fill last", args = { 255, 0, 255 } }

commandParser( tableOfCommands )