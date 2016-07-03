--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:028f90d5da6754a34432c2528d598c89:1939b8fc120968f07ef33dfce689500e:f4492607ea55a754477543692c89a688$
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
            -- tile1
            x=2,
            y=2,
            width=256,
            height=256,

        },
        {
            -- tile2
            x=261,
            y=2,
            width=256,
            height=256,

        },
    },
    
    sheetContentWidth = 519,
    sheetContentHeight = 260
}

SheetInfo.frameIndex =
{

    ["tile1"] = 1,
    ["tile2"] = 2,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
