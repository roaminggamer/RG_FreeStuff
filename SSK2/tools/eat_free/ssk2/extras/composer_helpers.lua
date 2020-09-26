-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
-- =============================================================

local drawAboutContent
local function create_content( layers, settings )
    local content = settings.content
    for i = 1, #content do
        local cur = content[i]

        local tmp
        if( cur.type == "newImageRect" ) then            
            tmp = ssk.display.newImageRect( layers[cur.layer], cur.x, cur.y, cur.src, cur.visualParams, cur.bodyParams )
        elseif( cur.type == "label" ) then            
            tmp = ssk.easyIFC:quickLabel( layers[cur.layer], cur.text, cur.x, cur.y, cur.font, cur.fontSize, cur.fontColor, cur.anchorX, cur.anchorY )
        elseif( cur.type == "presetPush" ) then
            tmp = ssk.easyIFC:presetPush( layers[cur.layer], cur.preset, cur.x, cur.y, cur.w, cur.h, cur.text, cur.onRelease, cur.overrides )
        elseif( cur.type == "presetToggle" ) then
            tmp = ssk.easyIFC:presetToggle( layers[cur.layer], cur.preset, cur.x, cur.y, cur.w, cur.h, cur.text, cur.onRelease, cur.overrides )
        elseif( cur.type == "about" ) then
            drawAboutContent( layers[cur.layer], cur.about, cur.yStart, cur.yEnd, cur.textColor )
        end

        if( cur.onCreated ) then
            cur.onCreated( tmp )
        end
    end

end

-- Helper to draw contents of about table in a scroller.
--
-- Tip: Right now, it is not that sophisticated, but you can easily adjust the 
-- data format and make it more complex and enable more interesting layout rules.
drawAboutContent = function( group, about, yStart, yEnd, textColor )
    local widget        = require "widget"
    local scroller = widget.newScrollView(
        {
            x                 = left,
            y                 = yStart,
            width             = fullw,
            height            = yEnd - yStart,
            hideBackground    = true
        } )
    scroller.anchorX = 0
    scroller.anchorY = 0
    group:insert(scroller)

    local tmp = display.newLine( group, left, yStart, right, yStart )
    tmp.strokeWidth = 3
    tmp:setStrokeColor(unpack(textColor))

    local tmp = display.newLine( group, left, yEnd, right, yEnd )
    tmp.strokeWidth = 3
    tmp:setStrokeColor(unpack(textColor))

    local curY = 20
    local buffer = 30

    for i = 1, #about do
        local tmp = about[i]
        if( tmp.text ) then
            local options = 
                {
                    text = tmp.text,
                    x = 20,
                    y = curY,
                    width = fullw - 40,
                    -- font = _G.fontN,
                    fontSize = 24,
                } 
            local myText = display.newText( options )
            myText.anchorX = 0
            myText.anchorY = 0
            myText:setFillColor( unpack(_W_) )
            scroller:insert( myText )

            curY = curY + myText.contentHeight + buffer

        elseif( tmp.image ) then
            local image
            if( tmp.width ) then
                image = display.newImageRect( tmp.image, tmp.width, tmp.height )
            else
                image = display.newImage( tmp.image,0,0 )
            end
            --
            image.xScale = 2
            image.yScale = 2
            --
            if( image.contentWidth > (fullw-40) ) then
                local scale = (fullw-40)/image.contentWidth
                image:scale( scale, scale )
            end
            --
            image.anchorY = 0
            --
            scroller:insert(image)
            --
            image.y = curY
            image.x = fullw/2
            --
            curY = curY + image.contentHeight + buffer
        end
    end
    -- buffer block
    local block = display.newRect( 0, 0, 40, 40 )
    scroller:insert( block )
    block.x = 100
    block.y = curY + 100
    block.isVisible = false
end

-- =============================================================
-- =============================================================
local public = {}
_G.ssk = _G.ssk or {}
_G.ssk.composer_helpers = public

function public.create( sceneName, settings )
    local composer      = require "composer"    
    local scene         = composer.newScene()
    composer.loadedScenes[sceneName] = scene
    --
    local layers
    local game
    --
    function scene:create( event )
        local sceneGroup = self.view
        -- timer.performWithDelay( 3000, onHome )
        if( settings.create_method == "create" ) then
            display.remove(layers)
            layers = ssk.display.quickLayers( sceneGroup, unpack(settings.layers) )
            create_content( layers, settings )
            if( settings.runGame ) then
                game = require "scripts.game"
                game.create( layers.game, event.params or {} )
            end
        end
        if( settings.create ) then settings.create( self, event, settings, layers ) end
    end

    function scene:willShow( event )
        local sceneGroup = self.view
        if( settings.create_method == "willShow" ) then
            display.remove(layers)
            layers = ssk.display.quickLayers( sceneGroup, unpack(settings.layers) )
            create_content( layers, settings )
            if( settings.runGame ) then
                game = require "scripts.game"
                game.create( layers.game, event.params or {} )
            end
        end
        if( settings.willShow ) then settings.willShow( self, event, settings, layers ) end
    end

    if( settings.onDidShow ) then
        function scene:didShow( event )
            if( settings.didShow ) then settings.didShow( self, event, settings, layers ) end
        end
    end

    if( settings.onWillHide ) then
        function scene:willHide( event )
            if( settings.willHide ) then settings.willHide( self, event, settings, layers ) end
        end
    end

    function scene:didHide( event )
        if( settings.didHide ) then settings.didHide( self, event, settings, layers ) end
        if( settings.destroy_method == "didHide" ) then
            if( game and game.destroy ) then
                game.destroy()
                game = nil
            end
            display.remove(layers)
            layers = nil
        end
    end

    function scene:destroy( event )
        if( settings.destroy ) then settings.destroy( self, event, settings, layers ) end
        if( game and game.destroy ) then
            game.destroy()
            game = nil
        end
        display.remove(layers)
        layers = nil
    end

    ----------------------------------------------------------------------
    --          Custom Scene Functions/Methods
    ----------------------------------------------------------------------
    onHome = function( event )
        local params = {}
        composer.gotoScene( "frame.scenes.home", { time = 500, effect = "crossFade", params = params } )
    end

  ---------------------------------------------------------------------------------
  -- Custom Dispatch Parser -- DO NOT EDIT THIS
  ---------------------------------------------------------------------------------
    function scene.commonHandler( event )
        local willDid  = event.phase
        local name     = willDid and willDid .. event.name:gsub("^%l", string.upper) or event.name
        if( scene[name] ) then scene[name](scene,event) end
    end
    scene:addEventListener( "create",   scene.commonHandler )
    scene:addEventListener( "show",     scene.commonHandler )
    scene:addEventListener( "hide",     scene.commonHandler )
    scene:addEventListener( "destroy",  scene.commonHandler )
    return scene
end

return public