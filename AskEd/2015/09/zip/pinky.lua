--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:f81de8b8136f1acdf4ce610afc3b1dbe:232504d2662d58d4ecf78f07d9128d89:81f962e9e64203c79164e24550e9dbdb$
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
            -- p3_jump
            x=2,
            y=2,
            width=67,
            height=94,

        },
        {
            -- p3_stand
            x=642,
            y=2,
            width=66,
            height=92,

        },
        {
            -- p3_walk01
            x=710,
            y=2,
            width=66,
            height=92,

            sourceX = 5,
            sourceY = 1,
            sourceWidth = 72,
            sourceHeight = 97
        },
        {
            -- p3_walk02
            x=778,
            y=2,
            width=66,
            height=92,

            sourceX = 6,
            sourceY = 0,
            sourceWidth = 72,
            sourceHeight = 97
        },
        {
            -- p3_walk03
            x=278,
            y=2,
            width=72,
            height=92,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 72,
            sourceHeight = 97
        },
        {
            -- p3_walk04
            x=352,
            y=2,
            width=71,
            height=92,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 72,
            sourceHeight = 97
        },
        {
            -- p3_walk05
            x=425,
            y=2,
            width=71,
            height=92,

            sourceX = 0,
            sourceY = 2,
            sourceWidth = 72,
            sourceHeight = 97
        },
        {
            -- p3_walk06
            x=498,
            y=2,
            width=70,
            height=92,

            sourceX = 0,
            sourceY = 3,
            sourceWidth = 72,
            sourceHeight = 97
        },
        {
            -- p3_walk07
            x=570,
            y=2,
            width=70,
            height=92,

            sourceX = 0,
            sourceY = 4,
            sourceWidth = 72,
            sourceHeight = 97
        },
        {
            -- p3_walk08
            x=71,
            y=2,
            width=67,
            height=93,

            sourceX = 3,
            sourceY = 4,
            sourceWidth = 72,
            sourceHeight = 97
        },
        {
            -- p3_walk09
            x=140,
            y=2,
            width=67,
            height=93,

            sourceX = 3,
            sourceY = 4,
            sourceWidth = 72,
            sourceHeight = 97
        },
        {
            -- p3_walk10
            x=846,
            y=2,
            width=66,
            height=92,

            sourceX = 4,
            sourceY = 4,
            sourceWidth = 72,
            sourceHeight = 97
        },
        {
            -- p3_walk11
            x=209,
            y=2,
            width=67,
            height=93,

            sourceX = 4,
            sourceY = 2,
            sourceWidth = 72,
            sourceHeight = 97
        },
    },
    
    sheetContentWidth = 914,
    sheetContentHeight = 98
}

SheetInfo.frameIndex =
{

    ["p3_jump"] = 1,
    ["p3_stand"] = 2,
    ["p3_walk01"] = 3,
    ["p3_walk02"] = 4,
    ["p3_walk03"] = 5,
    ["p3_walk04"] = 6,
    ["p3_walk05"] = 7,
    ["p3_walk06"] = 8,
    ["p3_walk07"] = 9,
    ["p3_walk08"] = 10,
    ["p3_walk09"] = 11,
    ["p3_walk10"] = 12,
    ["p3_walk11"] = 13,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
