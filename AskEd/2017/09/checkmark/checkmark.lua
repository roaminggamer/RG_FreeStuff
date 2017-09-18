--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:1b5533bc8c5cf06183c3511ddaa8181c:4734d9c2e54fd208c5671558bdeafd8d:01e07018274d55cd9dcaa6031f6be6c3$
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
            -- frame_00_delay-0.3s
            x=1,
            y=1,
            width=220,
            height=220,

        },
        {
            -- frame_01_delay-0.1s
            x=1,
            y=223,
            width=220,
            height=220,

        },
        {
            -- frame_02_delay-0.1s
            x=223,
            y=1,
            width=220,
            height=220,

        },
        {
            -- frame_03_delay-0.1s
            x=223,
            y=223,
            width=220,
            height=220,

        },
        {
            -- frame_04_delay-0.1s
            x=445,
            y=1,
            width=220,
            height=220,

        },
        {
            -- frame_05_delay-0.1s
            x=445,
            y=223,
            width=220,
            height=220,

        },
        {
            -- frame_06_delay-0.1s
            x=667,
            y=1,
            width=220,
            height=220,

        },
        {
            -- frame_07_delay-0.1s
            x=667,
            y=223,
            width=220,
            height=220,

        },
        {
            -- frame_08_delay-0.1s
            x=889,
            y=1,
            width=220,
            height=220,

        },
        {
            -- frame_09_delay-2s
            x=889,
            y=223,
            width=220,
            height=220,

        },
    },
    
    sheetContentWidth = 1110,
    sheetContentHeight = 444
}

SheetInfo.frameIndex =
{

    ["frame_00_delay-0.3s"] = 1,
    ["frame_01_delay-0.1s"] = 2,
    ["frame_02_delay-0.1s"] = 3,
    ["frame_03_delay-0.1s"] = 4,
    ["frame_04_delay-0.1s"] = 5,
    ["frame_05_delay-0.1s"] = 6,
    ["frame_06_delay-0.1s"] = 7,
    ["frame_07_delay-0.1s"] = 8,
    ["frame_08_delay-0.1s"] = 9,
    ["frame_09_delay-2s"] = 10,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
