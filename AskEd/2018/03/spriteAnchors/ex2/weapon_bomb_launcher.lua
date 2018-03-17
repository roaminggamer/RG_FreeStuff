--
-- created with TexturePacker - https://www.codeandweb.com/texturepacker
--
-- $TexturePacker:SmartUpdate:fc3ee4783821362aaceae2229b52f049:50a1f130b9ad0ce9ccd73a877a1474f8:5e7e60b0de3c3b1ca0fc93f3142d01aa$
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
            -- base
            x=298,
            y=195,
            width=37,
            height=36,

        },
        {
            -- bullet
            x=337,
            y=195,
            width=30,
            height=20,

        },
        {
            -- projectile
            x=127,
            y=209,
            width=15,
            height=15,

        },
        {
            -- tower_crush_grenade_launcher_projectile0001
            x=409,
            y=136,
            width=64,
            height=64,

            sourceX = 28,
            sourceY = 29,
            sourceWidth = 126,
            sourceHeight = 124
        },
        {
            -- tower_crush_grenade_launcher_projectile0002
            x=375,
            y=316,
            width=86,
            height=86,

            sourceX = 17,
            sourceY = 18,
            sourceWidth = 126,
            sourceHeight = 124
        },
        {
            -- tower_crush_grenade_launcher_projectile0003
            x=136,
            y=430,
            width=110,
            height=109,

            sourceX = 6,
            sourceY = 6,
            sourceWidth = 126,
            sourceHeight = 124
        },
        {
            -- tower_crush_grenade_launcher_projectile0004
            x=375,
            y=202,
            width=115,
            height=112,

            sourceX = 5,
            sourceY = 5,
            sourceWidth = 126,
            sourceHeight = 124
        },
        {
            -- tower_crush_grenade_launcher_projectile0005
            x=127,
            y=236,
            width=122,
            height=121,

            sourceX = 2,
            sourceY = 2,
            sourceWidth = 126,
            sourceHeight = 124
        },
        {
            -- tower_crush_grenade_launcher_projectile0006
            x=1,
            y=334,
            width=124,
            height=122,

            sourceX = 0,
            sourceY = 1,
            sourceWidth = 126,
            sourceHeight = 124
        },
        {
            -- tower_crush_grenade_launcher_projectile0007
            x=251,
            y=236,
            width=122,
            height=120,

            sourceX = 2,
            sourceY = 2,
            sourceWidth = 126,
            sourceHeight = 124
        },
        {
            -- tower_crush_grenade_launcher_projectile0008
            x=251,
            y=358,
            width=122,
            height=120,

            sourceX = 2,
            sourceY = 2,
            sourceWidth = 126,
            sourceHeight = 124
        },
        {
            -- tower_crush_grenade_launcher_projectile0009
            x=1,
            y=209,
            width=124,
            height=123,

            sourceX = 1,
            sourceY = 1,
            sourceWidth = 126,
            sourceHeight = 124
        },
        {
            -- tower_crush_grenade_launcher_shot0001
            x=375,
            y=404,
            width=103,
            height=55,

            sourceX = 5,
            sourceY = 42,
            sourceWidth = 168,
            sourceHeight = 121
        },
        {
            -- tower_crush_grenade_launcher_shot0002
            x=375,
            y=461,
            width=104,
            height=55,

            sourceX = 4,
            sourceY = 42,
            sourceWidth = 168,
            sourceHeight = 121
        },
        {
            -- tower_crush_grenade_launcher_shot0003
            x=302,
            y=136,
            width=105,
            height=57,

            sourceX = 3,
            sourceY = 41,
            sourceWidth = 168,
            sourceHeight = 121
        },
        {
            -- tower_crush_grenade_launcher_shot0004
            x=248,
            y=480,
            width=105,
            height=58,

            sourceX = 3,
            sourceY = 40,
            sourceWidth = 168,
            sourceHeight = 121
        },
        {
            -- tower_crush_grenade_launcher_shot0005
            x=127,
            y=359,
            width=112,
            height=69,

            sourceX = 4,
            sourceY = 31,
            sourceWidth = 168,
            sourceHeight = 121
        },
        {
            -- tower_crush_grenade_launcher_shot0006
            x=1,
            y=458,
            width=133,
            height=76,

            sourceX = 3,
            sourceY = 27,
            sourceWidth = 168,
            sourceHeight = 121
        },
        {
            -- tower_crush_grenade_launcher_shot0007
            x=309,
            y=1,
            width=151,
            height=68,

            sourceX = 4,
            sourceY = 33,
            sourceWidth = 168,
            sourceHeight = 121
        },
        {
            -- tower_crush_grenade_launcher_shot0008
            x=309,
            y=71,
            width=146,
            height=63,

            sourceX = 5,
            sourceY = 36,
            sourceWidth = 168,
            sourceHeight = 121
        },
        {
            -- tower_crush_grenade_launcher_shot0009
            x=159,
            y=92,
            width=141,
            height=65,

            sourceX = 6,
            sourceY = 32,
            sourceWidth = 168,
            sourceHeight = 121
        },
        {
            -- tower_crush_grenade_launcher_shot0010
            x=155,
            y=159,
            width=141,
            height=75,

            sourceX = 6,
            sourceY = 28,
            sourceWidth = 168,
            sourceHeight = 121
        },
        {
            -- tower_crush_grenade_launcher_shot0011
            x=159,
            y=1,
            width=148,
            height=89,

            sourceX = 5,
            sourceY = 20,
            sourceWidth = 168,
            sourceHeight = 121
        },
        {
            -- tower_crush_grenade_launcher_shot0012
            x=1,
            y=110,
            width=152,
            height=97,

            sourceX = 5,
            sourceY = 15,
            sourceWidth = 168,
            sourceHeight = 121
        },
        {
            -- tower_crush_grenade_launcher_shot0013
            x=1,
            y=1,
            width=156,
            height=107,

            sourceX = 5,
            sourceY = 9,
            sourceWidth = 168,
            sourceHeight = 121
        },
    },

    sheetContentWidth = 491,
    sheetContentHeight = 540
}

SheetInfo.frameIndex =
{

    ["base"] = 1,
    ["bullet"] = 2,
    ["projectile"] = 3,
    ["tower_crush_grenade_launcher_projectile0001"] = 4,
    ["tower_crush_grenade_launcher_projectile0002"] = 5,
    ["tower_crush_grenade_launcher_projectile0003"] = 6,
    ["tower_crush_grenade_launcher_projectile0004"] = 7,
    ["tower_crush_grenade_launcher_projectile0005"] = 8,
    ["tower_crush_grenade_launcher_projectile0006"] = 9,
    ["tower_crush_grenade_launcher_projectile0007"] = 10,
    ["tower_crush_grenade_launcher_projectile0008"] = 11,
    ["tower_crush_grenade_launcher_projectile0009"] = 12,
    ["tower_crush_grenade_launcher_shot0001"] = 13,
    ["tower_crush_grenade_launcher_shot0002"] = 14,
    ["tower_crush_grenade_launcher_shot0003"] = 15,
    ["tower_crush_grenade_launcher_shot0004"] = 16,
    ["tower_crush_grenade_launcher_shot0005"] = 17,
    ["tower_crush_grenade_launcher_shot0006"] = 18,
    ["tower_crush_grenade_launcher_shot0007"] = 19,
    ["tower_crush_grenade_launcher_shot0008"] = 20,
    ["tower_crush_grenade_launcher_shot0009"] = 21,
    ["tower_crush_grenade_launcher_shot0010"] = 22,
    ["tower_crush_grenade_launcher_shot0011"] = 23,
    ["tower_crush_grenade_launcher_shot0012"] = 24,
    ["tower_crush_grenade_launcher_shot0013"] = 25,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
