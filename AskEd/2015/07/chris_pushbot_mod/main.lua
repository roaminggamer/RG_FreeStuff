local globals = require( "globals" )
local file = require( "mod_file" )
------------------------------------------------------------
-- PUSHBOTS INIT
------------------------------------------------------------
local pushbots = require( "mod_pushbots" )
pushbots:init( "pushbot_id_here" )
pushbots.showStatus = true
------------------------------------------------------------
local deviceToken = false

-- Try loading saved deviceToken
deviceToken = file.read( "device_token" )

print("Device Token === ", deviceToken )

-- Called when a notification event has been received.
local function onNotification(event)
	if event.type == "remoteRegistration" then
		-- This device has just been registered for push notifications.
		-- Store the Registration ID that was assigned to this application.
		deviceToken = event.token

		--store the token
		file.write( "device_token", deviceToken )

		------------------------------------------------------------
		-- PUSHBOTS REGISTRATION
		------------------------------------------------------------
		pushbots:registerDevice( deviceToken, pushbots.NIL, function(e) 
			if not e.error then
				native.showAlert( "Pushbots", e.response, { "OK" } )
				if e.code == 200 then
					pushbots:clearBadgeCount( deviceToken )
				end
			else
				native.showAlert( "Pushbots", e.error, { "OK" } )
			end
		end)
		------------------------------------------------------------

		-- Print the registration event to the log.
		print("### --- Registration Event ---")
		globals.printTable(event)

	else
		-- A push notification has just been received. Print it to the log.
		print("### --- Notification Event ---")
		globals.printTable(event)

		--get token
		deviceToken = file.read( "device_token" )

		-- Reset badge count to 0
		pushbots:clearBadgeCount( deviceToken )

		--mark opened
		pushbots:pushOpened()
	end
end

-- Set up a notification listener.
Runtime:addEventListener("notification", onNotification)

Runtime:addEventListener( "system", function (e) 
	if "applicationResume" == e.type then
		pushbots:clearBadgeCount( deviceToken )
	end
end)
-- Print this app's launch arguments to the log.
-- This allows you to view what these arguments provide
-- when this app is started by tapping a notification.
local launchArgs = ...

print("### --- Launch Arguments ---")
globals.printTable(launchArgs)

-- Reset badge count to 0

if deviceToken then
	pushbots:clearBadgeCount( deviceToken )
end

local notifications = require( "plugin.notifications" )
notifications.registerForPushNotifications()
