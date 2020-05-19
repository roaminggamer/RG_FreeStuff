--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:c78b8bceb5258876048645da667e89ad:a6b325d632ccc90810edb948aa354b0a:b34b0297d63255ba9c743e3851f33ff8$
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
            -- Idle__000
            x=1,
            y=1,
            width=290,
            height=500,

        },
        {
            -- Idle__001
            x=1,
            y=503,
            width=290,
            height=500,

        },
        {
            -- Idle__002
            x=293,
            y=503,
            width=288,
            height=500,

            sourceX = 2,
            sourceY = 0,
            sourceWidth = 290,
            sourceHeight = 500
        },
        {
            -- Idle__003
            x=583,
            y=503,
            width=288,
            height=500,

            sourceX = 2,
            sourceY = 0,
            sourceWidth = 290,
            sourceHeight = 500
        },
        {
            -- Idle__004
            x=875,
            y=1,
            width=286,
            height=498,

            sourceX = 4,
            sourceY = 2,
            sourceWidth = 290,
            sourceHeight = 500
        },
        {
            -- Idle__005
            x=1163,
            y=1,
            width=286,
            height=498,

            sourceX = 4,
            sourceY = 2,
            sourceWidth = 290,
            sourceHeight = 500
        },
        {
            -- Idle__006
            x=1163,
            y=501,
            width=286,
            height=498,

            sourceX = 4,
            sourceY = 2,
            sourceWidth = 290,
            sourceHeight = 500
        },
        {
            -- Idle__007
            x=585,
            y=1,
            width=288,
            height=500,

            sourceX = 2,
            sourceY = 0,
            sourceWidth = 290,
            sourceHeight = 500
        },
        {
            -- Idle__008
            x=873,
            y=503,
            width=288,
            height=500,

            sourceX = 2,
            sourceY = 0,
            sourceWidth = 290,
            sourceHeight = 500
        },
        {
            -- Idle__009
            x=293,
            y=1,
            width=290,
            height=500,

        },
    },
    
    sheetContentWidth = 1450,
    sheetContentHeight = 1004
}

SheetInfo.frameIndex =
{

    ["Idle__000"] = 1,
    ["Idle__001"] = 2,
    ["Idle__002"] = 3,
    ["Idle__003"] = 4,
    ["Idle__004"] = 5,
    ["Idle__005"] = 6,
    ["Idle__006"] = 7,
    ["Idle__007"] = 8,
    ["Idle__008"] = 9,
    ["Idle__009"] = 10,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
