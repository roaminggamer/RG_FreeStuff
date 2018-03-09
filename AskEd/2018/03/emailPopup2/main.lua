io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
-- Using SSK to make my life easier (buttons, etc.)
-- =====================================================
require "ssk2.loadSSK"
_G.ssk.init( )
-- =====================================================

local thanksLabel = display.newText( 'THANK YOU', centerX, top + 50, native.systemFont, 20 )
thanksLabel.alpha = 0

local msgY = top + 150
local canShowPopupLabel = display.newText( 'CAN SHOW POPUP? ==> ', centerX, msgY, native.systemFont, 20  )
canShowPopupLabel.text = canShowPopupLabel.text .. tostring(native.canShowPopup("mail"))
msgY = msgY + 50

local onSentResume
onSentResume = function( event )
	local tmp = display.newText( event.type .. " @ " .. tostring(system.getTimer()), centerX, msgY, native.systemFont, 20  )
	msgY = msgY + 50
	--
	if( event.type == "applicationResume" ) then
		thanksLabel.alpha = 1
		transition.to( thanksLabel, { alpha = 0, delay = 2000, time = 1000 } )
		native.setKeyboardFocus( nil )
	end
end
--
timer.performWithDelay( 500, function() Runtime:addEventListener( "system", onSentResume ) end )


local function onSend( event )
	if( not native.canShowPopup( "mail" ) ) then return end
	--
	local options =
	{
		to = { "roaminggamer@gmail.com" },
		--cc = { "jane.smith@example.com" },
		subject = "Resume After Send Test",
		body = "This is a test of resume events after sending email.",
	}
	local result = native.showPopup("mail", options)

end

ssk.easyIFC:presetPush( nil, "default", centerX, top + 100, 200, 40, "SEND EMAIL", onSend )



