local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            x=1,
            y=1,
            width=20,
            height=20,

        },

        {
            x=21,
            y=1,
            width=20,
            height=20,

        },

        {
            x=41,
            y=1,
            width=20,
            height=20,

        },

        {
            x=61,
            y=1,
            width=20,
            height=20,

        },

        {
            x=81,
            y=1,
            width=20,
            height=20,

        },
    },
    
    sheetContentWidth = 100,
    sheetContentHeight = 21
}

SheetInfo.frameIndex =
{

    ["frame1"] = 1,
    ["frame2"] = 2,
    ["frame3"] = 3,
    ["frame4"] = 4,
    ["frame5"] = 5,    

}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
