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
common.w 			= display.contentWidth
common.h 			= display.contentHeight
common.centerX 		= display.contentCenterX
common.centerY 		= display.contentCenterY
common.fullw		= display.actualContentWidth 
common.fullh		= display.actualContentHeight
common.unusedWidth	= common.fullw - common.w
common.unusedHeight	= common.fullh - common.h
common.left			= common.round(0 - common.unusedWidth/2)
common.top 			= common.round(0 - common.unusedHeight/2)
common.right 		= common.round(common.w + common.unusedWidth/2)
common.bottom 		= common.round(common.h + common.unusedHeight/2)

common.onSimulator = system.getInfo( "environment" ) == "simulator"
common.oniOS = ( system.getInfo("platformName") == "iPhone OS") 
common.onAndroid = ( system.getInfo("platformName") == "Android") 
common.onOSX = ( system.getInfo("platformName") == "Mac OS X")
common.onWin = ( system.getInfo("platformName") == "Win")



if( common.onAndroid ) then
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

return common