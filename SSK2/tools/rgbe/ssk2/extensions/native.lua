-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- native.* - Extension(s)
-- =============================================================
--   Last Updated: 29 NOV 2016
-- Last Validated: 29 NOV 2016
-- =============================================================

function native.newScaledTextField( centerX, centerY, width, desiredFontSize )

    local fontSize = desiredFontSize or 0

    -- Create a text object, measure its height, and then remove it
    local textToMeasure = display.newText( "X", 0, 0, native.systemFont, fontSize )
    local textHeight = textToMeasure.contentHeight
    textToMeasure:removeSelf()
    textToMeasure = nil

    local scaledFontSize = fontSize / display.contentScaleY
    local textMargin = 10 * display.contentScaleY  -- convert 20 pixels to content coordinates

    -- Calculate the text input field's font size and vertical margin, per-platform
    local platformName = system.getInfo( "platformName" )
    if ( platformName == "iPhone OS" ) then
        local modelName = system.getInfo( "model" )
        if ( modelName == "iPad" ) or ( modelName == "iPad Simulator" ) then
            scaledFontSize = scaledFontSize / ( display.pixelWidth / 768 )
            textMargin = textMargin * ( display.pixelWidth / 768 )
        else
            scaledFontSize = scaledFontSize / ( display.pixelWidth / 320 )
            textMargin = textMargin * ( display.pixelWidth / 320 )
        end
    elseif ( platformName == "Android" ) then
        scaledFontSize = scaledFontSize / ( system.getInfo( "androidDisplayApproximateDpi" ) / 160 )
        textMargin = textMargin * ( system.getInfo( "androidDisplayApproximateDpi" ) / 160 )
    end

    -- Create a text field that fits the font size from above
    local textField = native.newTextField(
        centerX,
        centerY,
        width,
        textHeight + textMargin
    )
    textField.size = scaledFontSize
    return textField, scaledFontSize
end

native.getScaledFontSize = function( textField )

    local fontSize = 10

    local textMargin = 10 * display.contentScaleY  -- convert 20 pixels to content coordinates

    local platformName = system.getInfo( "platformName" )
    if ( platformName == "iPhone OS" ) then
        local modelName = system.getInfo( "model" )
        if ( modelName == "iPad" ) or ( modelName == "iPad Simulator" ) then
            textMargin = textMargin * ( display.pixelWidth / 768 )
        else
            textMargin = textMargin * ( display.pixelWidth / 320 )
        end
    elseif ( platformName == "Android" ) then
        textMargin = textMargin * ( system.getInfo( "androidDisplayApproximateDpi" ) / 160 )
    end

    -- Calculate a font size that will best fit the given text field's height
    local textToMeasure = display.newText( "X", 0, 0, native.systemFont, fontSize )
    fontSize = fontSize * ( ( textField.contentHeight - textMargin ) / textToMeasure.contentHeight )
    textToMeasure:removeSelf()
    textToMeasure = nil

    -- Update the given text field's font size to best fit its current height
    -- Note that we must convert the font size above for the text field's native units and scale
    local nativeScaledFontSize = fontSize / display.contentScaleY
    if ( platformName == "iPhone OS" ) then
        local modelName = system.getInfo( "model" )
        if ( modelName == "iPad" ) or ( modelName == "iPad Simulator" ) then
            nativeScaledFontSize = nativeScaledFontSize / ( display.pixelWidth / 768 )
        else
            nativeScaledFontSize = nativeScaledFontSize / ( display.pixelWidth / 320 )
        end
    elseif ( platformName == "Android" ) then
        nativeScaledFontSize = nativeScaledFontSize / ( system.getInfo( "androidDisplayApproximateDpi" ) / 160 )
    end
    return nativeScaledFontSize
end
