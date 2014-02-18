-- Called immediately after scene has moved onscreen:
local alert
local function onComplete( event )
    if "clicked" == event.action then
        local i = event.index
        if 1 == i then
            native.cancelAlert( alert )
            alert = nil
        elseif 2 == i then
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
