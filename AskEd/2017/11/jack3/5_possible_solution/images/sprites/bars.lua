--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:4accb0b42766fa4787e9def8e521f4bb:075486941ebc2cc4e52c87e1b7f48c22:be32ff39920d5c2ee850e87eb9cc2ba6$
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
            -- adventureexpbacking-ui
            x=3,
            y=351,
            width=243,
            height=111,

        },
        {
            -- adventureexpfillcolor-ui
            x=345,
            y=3,
            width=171,
            height=36,

        },
        {
            -- adventurenrgbacking-ui
            x=249,
            y=405,
            width=243,
            height=111,

        },
        {
            -- adventurenrgfillcolor-ui
            x=345,
            y=42,
            width=171,
            height=36,

        },
        {
            -- homeexpbacking-ui
            x=3,
            y=228,
            width=321,
            height=120,

        },
        {
            -- homeexpfillcolor-ui
            x=3,
            y=519,
            width=246,
            height=39,

        },
        {
            -- homenrgbacking-ui
            x=3,
            y=105,
            width=324,
            height=120,

        },
        {
            -- homenrgfillcolor-ui
            x=252,
            y=519,
            width=246,
            height=39,

        },
        {
            -- lifebacking-ui
            x=345,
            y=81,
            width=132,
            height=36,

        },
        {
            -- lifefillcolor-ui
            x=327,
            y=252,
            width=123,
            height=24,

        },
        {
            -- runnerexpbacking-ui
            x=330,
            y=120,
            width=231,
            height=45,

        },
        {
            -- runnerexpfillcolor-ui
            x=330,
            y=168,
            width=231,
            height=45,

        },
        {
            -- runnerlifebacking-ui
            x=330,
            y=216,
            width=129,
            height=33,

        },
        {
            -- runnerlifefillcolor-ui
            x=3,
            y=465,
            width=129,
            height=33,

        },
        {
            -- runnerskillbacking-ui
            x=3,
            y=3,
            width=339,
            height=99,

        },
        {
            -- runnerskillfillcolor-ui
            x=249,
            y=351,
            width=294,
            height=51,

        },
    },
    
    sheetContentWidth = 565,
    sheetContentHeight = 565
}

SheetInfo.frameIndex =
{

    ["adventureexpbacking-ui"] = 1,
    ["adventureexpfillcolor-ui"] = 2,
    ["adventurenrgbacking-ui"] = 3,
    ["adventurenrgfillcolor-ui"] = 4,
    ["homeexpbacking-ui"] = 5,
    ["homeexpfillcolor-ui"] = 6,
    ["homenrgbacking-ui"] = 7,
    ["homenrgfillcolor-ui"] = 8,
    ["lifebacking-ui"] = 9,
    ["lifefillcolor-ui"] = 10,
    ["runnerexpbacking-ui"] = 11,
    ["runnerexpfillcolor-ui"] = 12,
    ["runnerlifebacking-ui"] = 13,
    ["runnerlifefillcolor-ui"] = 14,
    ["runnerskillbacking-ui"] = 15,
    ["runnerskillfillcolor-ui"] = 16,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
