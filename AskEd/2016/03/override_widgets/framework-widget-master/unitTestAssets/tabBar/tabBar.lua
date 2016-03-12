--
-- created with TexturePacker (http://www.texturepacker.com)
--
-- $TexturePacker:SmartUpdate:4db5b3892c99d8ca1a9e6eaddac47ce8$
--
-- local sheetInfo = require("myExportedImageSheet") -- lua file that Texture packer published
--
-- local myImageSheet = graphics.newImageSheet( "ImageSheet.png", sheetInfo:getSheet() ) -- ImageSheet.png is the image Texture packer published
--
-- local myImage1 = display.newImage( myImageSheet , sheetInfo:getFrameIndex("image_name1"))
-- local myImage2 = display.newImage( myImageSheet , sheetInfo:getFrameIndex("image_name2"))
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- tabBar_background
            x=2,
            y=2,
            width=25,
            height=50,

        },
        {
            -- tabBar_iconActive
            x=29,
            y=29,
            width=25,
            height=25,

        },
        {
            -- tabBar_iconInactive
            x=29,
            y=2,
            width=25,
            height=25,

        },
        {
            -- tabBar_tabSelectedLeftEdge
            x=26,
            y=56,
            width=10,
            height=45,

            sourceX = 0,
            sourceY = 4,
            sourceWidth = 10,
            sourceHeight = 50
        },
        {
            -- tabBar_tabSelectedMiddle
            x=14,
            y=54,
            width=10,
            height=45,

            sourceX = 0,
            sourceY = 4,
            sourceWidth = 10,
            sourceHeight = 50
        },
        {
            -- tabBar_tabSelectedRightEdge
            x=2,
            y=54,
            width=10,
            height=45,

            sourceX = 0,
            sourceY = 4,
            sourceWidth = 10,
            sourceHeight = 50
        },
    },
    
    sheetContentWidth = 64,
    sheetContentHeight = 128
}

SheetInfo.frameIndex =
{

    ["tabBar_background"] = 1,
    ["tabBar_iconActive"] = 2,
    ["tabBar_iconInactive"] = 3,
    ["tabBar_tabSelectedLeftEdge"] = 4,
    ["tabBar_tabSelectedMiddle"] = 5,
    ["tabBar_tabSelectedRightEdge"] = 6,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
