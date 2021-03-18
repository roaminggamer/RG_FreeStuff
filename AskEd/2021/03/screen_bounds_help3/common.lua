-- Extracted from SSK and modified for this example.
-- https://github.com/roaminggamer/SSKCorona
--
common = {}

function common.round(val, n)
  if (n) then
    return math.floor( (val * 10^n) + 0.5) / (10^n)
  else
    return math.floor(val+0.5)
  end
end

function common.calc_globals()
    _G.w            = display.contentWidth
    _G.h            = display.contentHeight
    _G.centerX      = display.contentCenterX
    _G.centerY      = display.contentCenterY
    _G.fullw        = display.actualContentWidth 
    _G.fullh        = display.actualContentHeight
    _G.unusedWidth  = _G.fullw - _G.w
    _G.unusedHeight = _G.fullh - _G.h
    _G.left         = common.round(0 - _G.unusedWidth/2)
    _G.top          = common.round(0 - _G.unusedHeight/2)
    _G.right        = common.round(_G.w + _G.unusedWidth/2)
    _G.bottom       = common.round(_G.h + _G.unusedHeight/2)

    _G.onSimulator = system.getInfo( "environment" ) == "simulator"
    _G.oniOS = ( system.getInfo("platformName") == "iPhone OS") 
    _G.onAndroid = ( system.getInfo("platformName") == "Android") 
    _G.onOSX = ( system.getInfo("platformName") == "Mac OS X")
    _G.onWin = ( system.getInfo("platformName") == "Win")
end


if( _G.onAndroid ) then
    function common.captureBackButton( noCB, yesCB )
        -- Called immediately after scene has moved onscreen:
        local alert
        local function onComplete( event )
            if "clicked" == event.action then
                local i = event.index
                if 1 == i then
                    if( noCB ) then noCB() end
                    native.cancelAlert( alert )
                    alert = nil
                elseif 2 == i then
                    if( yesCB ) then yesCB() end
                    native.requestExit()
                end
            end
        end
        local function onKeyEvent( event )

            local phase = event.phase
            local keyName = event.keyName

            if( keyName == "volumeUp" or keyName == "volumeDown") then
                return false 
            elseif( (keyName == "back") and (phase == "down") ) then 
                alert = native.showAlert( "EXIT", "ARE YOU SURE?", { "NO", "YES" }, onComplete )
            end
            return true
        end
        Runtime:addEventListener( "key", onKeyEvent );
    end

    function common.captureVolumeButtons( block, volUp, volDown )
        block = (block == nil) and true or false
        local function onKeyEvent( event )
            local phase = event.phase
            local keyName = event.keyName
            if( keyName == "volumeUp" ) then
                if(volUp) then volUp() end
                return block 
            elseif( keyName == "volumeDown") then
                if(volDown) then volDown() end
                return block 
            end
            return true
        end
        Runtime:addEventListener( "key", onKeyEvent );
    end

    function common.easyAndroidUIVisibility( profile )
        profile = profile or "immersiveSticky"
        -- Android Settings
        --
        local androidVersion = string.sub( system.getInfo( "platformVersion" ), 1, 3)
        if( androidVersion and tonumber(androidVersion) >= 4.4 ) then
          native.setProperty( "androidSystemUiVisibility", profile )
        elseif( androidVersion ) then
          native.setProperty( "androidSystemUiVisibility", "lowProfile" )
        end
    end
else
    function common.captureBackButton() return end
    function common.captureVolumeButtons() return end
    function common.easyAndroidUIVisibility() return end
end

common.calc_globals()

return common