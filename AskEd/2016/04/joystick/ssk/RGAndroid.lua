-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
--                              License
-- =============================================================
--[[
    > SSK is free to use.
    > SSK is free to edit.
    > SSK is free to use in a free or commercial game.
    > SSK is free to use in a free or commercial non-game app.
    > SSK is free to use without crediting the author (credits are still appreciated).
    > SSK is free to use without crediting the project (credits are still appreciated).
    > SSK is NOT free to sell for anything.
    > SSK is NOT free to credit yourself with.
]]
-- =============================================================

-- =============================================================
-- Environment
-- =============================================================
local onSimulator = system.getInfo( "environment" ) == "simulator"
local oniOS = ( system.getInfo("platformName") == "iPhone OS") 
local onAndroid = ( system.getInfo("platformName") == "Android") 
local onOSX = ( system.getInfo("platformName") == "Mac OS X")
local onWin = ( system.getInfo("platformName") == "Win")


local android = {}
_G.ssk = _G.ssk or {}
_G.ssk.android = android

if( onAndroid ) then
    function android.captureBackButton( noCB, yesCB )
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

    function android.captureVolumeButtons( block, volUp, volDown )
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

    function android.easyAndroidUIVisibility( profile )
        profile = profile or "immersiveSticky"
        -- Android Settings
        --
        if ( system.getInfo("platformName") == "Android" ) then
            local androidVersion = string.sub( system.getInfo( "platformVersion" ), 1, 3)
            if( androidVersion and tonumber(androidVersion) >= 4.4 ) then
              native.setProperty( "androidSystemUiVisibility", profile )
            elseif( androidVersion ) then
              native.setProperty( "androidSystemUiVisibility", "lowProfile" )
            end
        end
    end
else
    function android.captureBackButton() return end
    function android.captureVolumeButtons() return end
    function android.easyAndroidUIVisibility() return end
end

return android