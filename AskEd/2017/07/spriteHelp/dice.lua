--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:fa41f96b25473c701ca7899e33953b3e:1/1$
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
            -- 1
            x=642,
            y=2,
            width=126,
            height=126,

            sourceX = 1,
            sourceY = 0,
            sourceWidth = 128,
            sourceHeight = 126
        },
        {
            -- 2
            x=514,
            y=2,
            width=126,
            height=126,

            sourceX = 1,
            sourceY = 0,
            sourceWidth = 128,
            sourceHeight = 126
        },
        {
            -- 3
            x=386,
            y=2,
            width=126,
            height=126,

            sourceX = 1,
            sourceY = 0,
            sourceWidth = 128,
            sourceHeight = 126
        },
        {
            -- 4
            x=258,
            y=2,
            width=126,
            height=126,

            sourceX = 1,
            sourceY = 0,
            sourceWidth = 128,
            sourceHeight = 126
        },
        {
            -- 5
            x=130,
            y=2,
            width=126,
            height=126,

            sourceX = 1,
            sourceY = 0,
            sourceWidth = 128,
            sourceHeight = 126
        },
        {
            -- 6
            x=2,
            y=2,
            width=126,
            height=126,

            sourceX = 1,
            sourceY = 0,
            sourceWidth = 128,
            sourceHeight = 126
        },
    },
    
    sheetContentWidth = 770,
    sheetContentHeight = 130
}

SheetInfo.frameIndex =
{

    ["1"] = 1,
    ["2"] = 2,
    ["3"] = 3,
    ["4"] = 4,
    ["5"] = 5,
    ["6"] = 6,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
