io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
require "ssk2.loadSSK"
_G.ssk.init( { measure = true } )
-- =====================================================

local group = display.newGroup()

local back = ssk.display.newImageRect( group, centerX, centerY, "protoBackX.png", { w = 720,  h = 1386, rotation = fullw>fullh and 90 } )

local testBasicDialog
local testCustomDialog


-- =============================================================
-- Basic Dialog
-- =============================================================
testBasicDialog = function()

    local function onClose( self, onComplete )
        print( "onClose" )  
        local function onComplete( self )
            self.frame:close()
            timer.performWithDelay( 1000, testCustomDialog )
        end
        transition.to( self, { y = centerY - fullh, time = 750, transition = easing.inOutBack, onComplete = onComplete  } )

    end

    local dialog = ssk.dialogs.basic.create( group, centerX, centerY - fullh, 
                   { fill               = hexcolor("#56A5EC"), 
                     width                  = 400,
                     height                 = 300,
                     softShadow             = true,
                     softShadowOX           = 8,
                     softShadowOY           = 8,
                     softShadowBlur         = 6,
                     closeOnTouchBlocker    = true, 
                     blockerFill            = _G_,
                     blockerAlpha           = 0.55,
                     softShadowAlpha        = 0.6,
                     blockerAlphaTime       = 100,
                     onClose                = onClose,
                     style                  = style } )

    transition.to( dialog, { y = centerY, time = 750, transition = easing.inOutBack  } )
end


-- =============================================================
-- Custom Dialog
-- =============================================================
testCustomDialog = function()
    local dialog_width, dialog_height = ssk.misc.getImageSize( "dialog1.png" )

    local scale = 0.5
    dialog_width = dialog_width * scale
    dialog_height = dialog_height * scale


    local function onClose( self, onComplete )
        print( "onClose" )  
        local function onComplete( self )
            self.frame:close()
            timer.performWithDelay( 1000, testBasicDialog )
        end
        transition.to( self, { y = centerY + fullh, time = 750, transition = easing.inOutBack, onComplete = onComplete  } )

    end

    local dialog = ssk.dialogs.custom.create( group, centerX, centerY + fullh, 
                { width                 = dialog_width,
                  height                = dialog_height,
                  softShadow            = true,
                  softShadowOX          = 8,
                  softShadowOY          = 8,
                  softShadowBlur        = 6,
                  closeOnTouchBlocker   = true, 
                  blockerFill           = _PINK_,
                  blockerAlpha          = 0.5,
                  softShadowAlpha       = 0.3,
                  blockerAlphaTime      = 100,
                  onClose               = onClose,
                  trayImage             = "dialog1.png",
                  shadowImage           = "dialog1_shadow.png" } )

    transition.to( dialog, { y = centerY, time = 750, transition = easing.inOutBack  } )
end



testBasicDialog()