--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:cc720720785ea1bc60a4e7e33627b249:1/1$
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
            -- numeral0
            x=191,
            y=2,
            width=19,
            height=19,

        },
        {
            -- numeral1
            x=170,
            y=2,
            width=19,
            height=19,

        },
        {
            -- numeral2
            x=149,
            y=2,
            width=19,
            height=19,

        },
        {
            -- numeral3
            x=128,
            y=2,
            width=19,
            height=19,

        },
        {
            -- numeral4
            x=107,
            y=2,
            width=19,
            height=19,

        },
        {
            -- numeral5
            x=86,
            y=2,
            width=19,
            height=19,

        },
        {
            -- numeral6
            x=65,
            y=2,
            width=19,
            height=19,

        },
        {
            -- numeral7
            x=44,
            y=2,
            width=19,
            height=19,

        },
        {
            -- numeral8
            x=23,
            y=2,
            width=19,
            height=19,

        },
        {
            -- numeral9
            x=2,
            y=2,
            width=19,
            height=19,

        },
    },
    
    sheetContentWidth = 212,
    sheetContentHeight = 23
}

SheetInfo.frameIndex =
{

    ["numeral0"] = 1,
    ["numeral1"] = 2,
    ["numeral2"] = 3,
    ["numeral3"] = 4,
    ["numeral4"] = 5,
    ["numeral5"] = 6,
    ["numeral6"] = 7,
    ["numeral7"] = 8,
    ["numeral8"] = 9,
    ["numeral9"] = 10,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
