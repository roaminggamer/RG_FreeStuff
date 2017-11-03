--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:8770c28adf8a746f648ccbb5d4e507eb:9fb3be9b72432606ddf33a2ac0a09341:9c519dc4da464f2a30daa98e61c4961f$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- fillbacking-ui
            x=3,
            y=3,
            width=132,
            height=36,

        },
        {
            -- fillbar3-ui
            x=3,
            y=42,
            width=123,
            height=24,

        },
    },
    
    sheetContentWidth = 140,
    sheetContentHeight = 140
}

SheetInfo.frameIndex =
{

    ["fillbacking-ui"] = 1,
    ["fillbar3-ui"] = 2,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
