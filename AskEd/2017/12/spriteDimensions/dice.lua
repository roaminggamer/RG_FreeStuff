--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:1d7e8de00f3aa2e2fab9831113785358:5e1095b84b25f42beeb7758b40d4b3dc:7c548baa4aa0a337d24c4a8219a3d23f$
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
            -- dieRed_border1
            x=1,
            y=1,
            width=68,
            height=68,

        },
        {
            -- dieRed_border2
            x=71,
            y=1,
            width=68,
            height=68,

        },
        {
            -- dieRed_border3
            x=141,
            y=1,
            width=68,
            height=68,

        },
        {
            -- dieRed_border4
            x=211,
            y=1,
            width=68,
            height=68,

        },
        {
            -- dieRed_border5
            x=281,
            y=1,
            width=68,
            height=68,

        },
        {
            -- dieRed_border6
            x=351,
            y=1,
            width=68,
            height=68,

        },
    },
    
    sheetContentWidth = 420,
    sheetContentHeight = 70
}

SheetInfo.frameIndex =
{

    ["dieRed_border1"] = 1,
    ["dieRed_border2"] = 2,
    ["dieRed_border3"] = 3,
    ["dieRed_border4"] = 4,
    ["dieRed_border5"] = 5,
    ["dieRed_border6"] = 6,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
