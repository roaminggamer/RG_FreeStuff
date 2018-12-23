--
-- created with TexturePacker - https://www.codeandweb.com/texturepacker
--
-- $TexturePacker:SmartUpdate:aa2628f8f52d6a80f1b551996730dd36:54e5ea7bc53490c8adc916fdc75dccbb:b2f580ea7c37465eac371f095cbaf8c7$
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
            -- p2_jump
            x=1,
            y=193,
            width=66,
            height=94,

        },
        {
            -- p2_walk01
            x=145,
            y=1,
            width=68,
            height=94,

            sourceX = 2,
            sourceY = 0,
            sourceWidth = 70,
            sourceHeight = 94
        },
        {
            -- p2_walk02
            x=141,
            y=193,
            width=68,
            height=92,

            sourceX = 2,
            sourceY = 0,
            sourceWidth = 70,
            sourceHeight = 94
        },
        {
            -- p2_walk03
            x=145,
            y=287,
            width=68,
            height=92,

            sourceX = 2,
            sourceY = 0,
            sourceWidth = 70,
            sourceHeight = 94
        },
        {
            -- p2_walk04
            x=1,
            y=289,
            width=70,
            height=90,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 70,
            sourceHeight = 94
        },
        {
            -- p2_walk05
            x=69,
            y=193,
            width=70,
            height=92,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 70,
            sourceHeight = 94
        },
        {
            -- p2_walk06
            x=73,
            y=287,
            width=70,
            height=92,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 70,
            sourceHeight = 94
        },
        {
            -- p2_walk07
            x=1,
            y=1,
            width=70,
            height=94,

        },
        {
            -- p2_walk08
            x=73,
            y=1,
            width=70,
            height=94,

        },
        {
            -- p2_walk09
            x=1,
            y=97,
            width=70,
            height=94,

        },
        {
            -- p2_walk10
            x=73,
            y=97,
            width=70,
            height=94,

        },
        {
            -- p2_walk11
            x=145,
            y=97,
            width=68,
            height=94,

            sourceX = 1,
            sourceY = 0,
            sourceWidth = 70,
            sourceHeight = 94
        },
    },

    sheetContentWidth = 214,
    sheetContentHeight = 380
}

SheetInfo.frameIndex =
{

    ["p2_jump"] = 1,
    ["p2_walk01"] = 2,
    ["p2_walk02"] = 3,
    ["p2_walk03"] = 4,
    ["p2_walk04"] = 5,
    ["p2_walk05"] = 6,
    ["p2_walk06"] = 7,
    ["p2_walk07"] = 8,
    ["p2_walk08"] = 9,
    ["p2_walk09"] = 10,
    ["p2_walk10"] = 11,
    ["p2_walk11"] = 12,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
