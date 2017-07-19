--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:9bf63aaf18e6d0035f4da5051129a2bd:e2fbef42aa8291fde6401654aa244a6f:622d83fb3b06462a4077bb5c69c03731$
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
            -- Climb__000
            x=360,
            y=1,
            width=43,
            height=67,

        },
        {
            -- Climb__001
            x=360,
            y=70,
            width=43,
            height=67,

        },
        {
            -- Climb__002
            x=274,
            y=71,
            width=43,
            height=67,

        },
        {
            -- Climb__003
            x=319,
            y=139,
            width=43,
            height=67,

        },
        {
            -- Climb__004
            x=364,
            y=139,
            width=43,
            height=67,

        },
        {
            -- Climb__005
            x=409,
            y=139,
            width=41,
            height=67,

            sourceX = 2,
            sourceY = 0,
            sourceWidth = 43,
            sourceHeight = 67
        },
        {
            -- Climb__006
            x=219,
            y=140,
            width=43,
            height=67,

        },
        {
            -- Climb__007
            x=264,
            y=140,
            width=43,
            height=67,

        },
        {
            -- Climb__008
            x=405,
            y=1,
            width=43,
            height=67,

        },
        {
            -- Climb__009
            x=405,
            y=70,
            width=43,
            height=67,

        },
        {
            -- Dead__000
            x=1,
            y=123,
            width=51,
            height=69,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 79,
            sourceHeight = 83
        },
        {
            -- Dead__001
            x=119,
            y=58,
            width=43,
            height=77,

            sourceX = 1,
            sourceY = 0,
            sourceWidth = 79,
            sourceHeight = 83
        },
        {
            -- Dead__002
            x=66,
            y=44,
            width=51,
            height=79,

            sourceX = 1,
            sourceY = 1,
            sourceWidth = 79,
            sourceHeight = 83
        },
        {
            -- Dead__003
            x=1,
            y=44,
            width=63,
            height=77,

            sourceX = 0,
            sourceY = 6,
            sourceWidth = 79,
            sourceHeight = 83
        },
        {
            -- Dead__004
            x=234,
            y=1,
            width=69,
            height=67,

            sourceX = 1,
            sourceY = 15,
            sourceWidth = 79,
            sourceHeight = 83
        },
        {
            -- Dead__005
            x=159,
            y=1,
            width=73,
            height=55,

            sourceX = 2,
            sourceY = 22,
            sourceWidth = 79,
            sourceHeight = 83
        },
        {
            -- Dead__006
            x=1,
            y=1,
            width=77,
            height=41,

            sourceX = 2,
            sourceY = 30,
            sourceWidth = 79,
            sourceHeight = 83
        },
        {
            -- Dead__007
            x=80,
            y=1,
            width=77,
            height=41,

            sourceX = 2,
            sourceY = 30,
            sourceWidth = 79,
            sourceHeight = 83
        },
        {
            -- Dead__008
            x=80,
            y=1,
            width=77,
            height=41,

            sourceX = 2,
            sourceY = 30,
            sourceWidth = 79,
            sourceHeight = 83
        },
        {
            -- Dead__009
            x=80,
            y=1,
            width=77,
            height=41,

            sourceX = 2,
            sourceY = 30,
            sourceWidth = 79,
            sourceHeight = 83
        },
        {
            -- Idle__000
            x=54,
            y=125,
            width=53,
            height=68,

        },
        {
            -- Idle__001
            x=164,
            y=58,
            width=53,
            height=68,

        },
        {
            -- Idle__002
            x=305,
            y=1,
            width=53,
            height=68,

        },
        {
            -- Idle__003
            x=219,
            y=70,
            width=53,
            height=68,

        },
        {
            -- Idle__004
            x=164,
            y=128,
            width=53,
            height=68,

        },
        {
            -- Idle__005
            x=109,
            y=137,
            width=53,
            height=68,

        },
        {
            -- Idle__006
            x=164,
            y=128,
            width=53,
            height=68,

        },
        {
            -- Idle__007
            x=219,
            y=70,
            width=53,
            height=68,

        },
        {
            -- Idle__008
            x=305,
            y=1,
            width=53,
            height=68,

        },
        {
            -- Idle__009
            x=164,
            y=58,
            width=53,
            height=68,

        },
    },
    
    sheetContentWidth = 451,
    sheetContentHeight = 208
}

SheetInfo.frameIndex =
{

    ["Climb__000"] = 1,
    ["Climb__001"] = 2,
    ["Climb__002"] = 3,
    ["Climb__003"] = 4,
    ["Climb__004"] = 5,
    ["Climb__005"] = 6,
    ["Climb__006"] = 7,
    ["Climb__007"] = 8,
    ["Climb__008"] = 9,
    ["Climb__009"] = 10,
    ["Dead__000"] = 11,
    ["Dead__001"] = 12,
    ["Dead__002"] = 13,
    ["Dead__003"] = 14,
    ["Dead__004"] = 15,
    ["Dead__005"] = 16,
    ["Dead__006"] = 17,
    ["Dead__007"] = 18,
    ["Dead__008"] = 19,
    ["Dead__009"] = 20,
    ["Idle__000"] = 21,
    ["Idle__001"] = 22,
    ["Idle__002"] = 23,
    ["Idle__003"] = 24,
    ["Idle__004"] = 25,
    ["Idle__005"] = 26,
    ["Idle__006"] = 27,
    ["Idle__007"] = 28,
    ["Idle__008"] = 29,
    ["Idle__009"] = 30,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
