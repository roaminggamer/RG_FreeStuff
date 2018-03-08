io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
-- Using SSK to make my life easier (buttons, etc.)
-- =====================================================
require "ssk2.loadSSK"
_G.ssk.init( )
-- =====================================================

local thanksLabel = display.newText( 'THANK YOU', centerX, centerY - 150 )
thanksLabel.alpha = 0


local function onSend( event )
	if( not native.canShowPopup( "mail" ) ) then return end
	--
	local onSentResume
	onSentResume = function( event )
		table.dump(event)
		if( event.type == "applicationResume" ) then
			thanksLabel.alpha = 1
			transition.to( thanksLabel, { alpha = 0, delay = 2000, time = 1000 } )
			Runtime:removeEventListener( "system", onSentResume )
			native.setKeyboardFocus( nil )
		end
	end
	--
	Runtime:addEventListener( "system", onSentResume )
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

ssk.easyIFC:presetPush( nil, "default", centerX, centerY, 200, 40, "SEND EMAIL", onSend )



