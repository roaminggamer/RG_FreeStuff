--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:455f0d9f0471c4a712d86afe014fbad6:55895142410462fdf5a540d30b0bf9e4:d4d456a43110a3d381fddc952f62108e$
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
            -- z1
            x=80,
            y=62,
            width=35,
            height=46,

            sourceX = 4,
            sourceY = 79,
            sourceWidth = 128,
            sourceHeight = 128
        },
        {
            -- z2
            x=80,
            y=2,
            width=46,
            height=58,

            sourceX = 29,
            sourceY = 47,
            sourceWidth = 128,
            sourceHeight = 128
        },
        {
            -- z3
            x=2,
            y=2,
            width=76,
            height=97,

            sourceX = 51,
            sourceY = 1,
            sourceWidth = 128,
            sourceHeight = 128
        },
    },
    
    sheetContentWidth = 128,
    sheetContentHeight = 110
}

SheetInfo.frameIndex =
{

    ["z1"] = 1,
    ["z2"] = 2,
    ["z3"] = 3,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
