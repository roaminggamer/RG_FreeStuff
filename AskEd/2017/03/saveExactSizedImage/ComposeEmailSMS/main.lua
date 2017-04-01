-- Project: ComposeEmailSMS
--
-- Date: November 16, 2016
--
-- Version: 1.1
--
-- File name: main.lua
--
-- Author: Corona Labs, Inc.
--
-- Abstract: Native E-mail and SMS client's compose feature is shown, pre-populated with
-- text, recipients, and attachments (E-mail).
--
-- Demonstrates: native.canShowPopup() and native.showPopup() APIs
--
-- Target devices: iOS and Android devices (or Xcode simulator)
--
-- Limitations: Requires build for device (and data access to send email/sms message).
--
-- Update History:
--	1.0		January 17, 2012		Initial version
--	1.1		November 16, 2016		Added native.canShowPopup() checks before trying to show the popups
--
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2010-2016 Corona Labs Inc. All Rights Reserved.
--
-- Supports Graphics 2.0
---------------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight

-- Require the widget library
local widget = require( "widget" )

local emailImage = display.newImage( "email.png", centerX, 156 )

-- BUTTON LISTENERS ---------------------------------------------------------------------

-- Email --------------------------------------------------------------------------------

local function showEmailNotSupportedAlert()
	print( "Email not supported/setup on this device" )
	native.showAlert( "Alert!",
		"Email not supported/setup on this device.", { "OK" }
	)
end

-- onRelease listener for 'sendEmail' button
local function onSendEmail( event )
	if native.canShowPopup( "mail" ) then
		print ("Can show email popup")
		-- compose an HTML email with two attachments
		-- NOTE: options table (and all child properties) are optional
		local options =
		{
		   to = { "john.doe@example.com", "jane.doe@example.com" },
		   cc = { "john.smith@example.com", "jane.smith@example.com" },
		   subject = "My High Score",
		   isBodyHtml = true,
		   body = "<html><body>I scored over <b>9000</b>!!! Can you do better?</body></html>",
		   attachment =
		   {
			  { baseDir=system.ResourceDirectory, filename="email.png", type="image" },
			  { baseDir=system.ResourceDirectory, filename="coronalogo.png", type="image" },
		   },
		}
		local result = native.showPopup("mail", options)
		
		if not result then
			showEmailNotSupportedAlert()
		end
	else
		showEmailNotSupportedAlert()
	end
end

-- SMS ----------------------------------------------------------------------------------

local function showSMSNotSupportedAlert()
	print( "SMS Not supported/setup on this device" )
	native.showAlert( "Alert!",
		"SMS not supported/setup on this device.", { "OK" }
	)
end

-- onRelease listener for 'sendSMS' button
local function onSendSMS( event )
	if native.canShowPopup( "sms" ) then
		print ("Can show SMS popup")
		-- compose an SMS message (doesn't support attachments)
		-- NOTE: options table (and all child properties) are optional
		local options =
		{
		   to = { "16505551212", "15125550189" },
		   body = "I scored over 9000!!! Can you do better?"
		}
		local result = native.showPopup("sms", options)

		if not result then
			showSMSNotSupportedAlert()
		end
	else
		showSMSNotSupportedAlert()
	end
end

-- CREATE BUTTONS -----------------------------------------------------------------------

local sendEmail = widget.newButton
{
	left = 0, 
	top = 0,
	width = 298,
	height = 56,
	label = "Compose Email",
	onRelease = onSendEmail
}

-- center horizontally on the screen
sendEmail.x = centerX
sendEmail.y = _H - 156

local sendSMS = widget.newButton
{
	left = 0, 
	top = 0,
	width = 298,
	height = 56,
	label = "Compose SMS",
	onRelease = onSendSMS
}

-- center horizontally on the screen
sendSMS.x = centerX
sendSMS.y = _H - 100
