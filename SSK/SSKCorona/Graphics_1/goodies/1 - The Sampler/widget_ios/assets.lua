--
-- created with TexturePacker (http://www.texturepacker.com)
--
-- $TexturePacker:SmartUpdate:04d4480a92899a69d62a7efad7666879$
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
            -- progressView_leftFill
            x=140,
            y=199,
            width=12,
            height=10,

        },
        {
            -- progressView_middleFill
            x=101,
            y=199,
            width=35,
            height=10,

        },
        {
            -- progressView_outerFrame
            x=3,
            y=75,
            width=182,
            height=10,

        },
        {
            -- progressView_rightFill
            x=189,
            y=75,
            width=12,
            height=10,

        },
        {
            -- searchField_bar
            x=3,
            y=3,
            width=207,
            height=33,

        },
        {
            -- searchField_remove
            x=199,
            y=124,
            width=19,
            height=19,

        },
        {
            -- segmentedControl_divider
            x=244,
            y=41,
            width=1,
            height=29,

        },
        {
            -- segmentedControl_left
            x=234,
            y=177,
            width=11,
            height=29,

        },
        {
            -- segmentedControl_leftOn
            x=234,
            y=144,
            width=11,
            height=29,

        },
        {
            -- segmentedControl_middle
            x=223,
            y=111,
            width=11,
            height=29,

        },
        {
            -- segmentedControl_middleOn
            x=219,
            y=180,
            width=11,
            height=29,

        },
        {
            -- segmentedControl_right
            x=219,
            y=147,
            width=11,
            height=29,

        },
        {
            -- segmentedControl_rightOn
            x=223,
            y=78,
            width=11,
            height=29,

        },
        {
            -- spinner_spinner
            x=101,
            y=155,
            width=40,
            height=40,

        },
        {
            -- stepper_minusActive
            x=101,
            y=124,
            width=94,
            height=27,

        },
        {
            -- stepper_noMinus
            x=3,
            y=182,
            width=94,
            height=27,

        },
        {
            -- stepper_noPlus
            x=3,
            y=151,
            width=94,
            height=27,

        },
        {
            -- stepper_nonActive
            x=3,
            y=120,
            width=94,
            height=27,

        },
        {
            -- stepper_plusActive
            x=3,
            y=89,
            width=94,
            height=27,

        },
        {
            -- switch_background
            x=3,
            y=40,
            width=165,
            height=31,

        },
        {
            -- switch_checkboxDefault
            x=182,
            y=155,
            width=33,
            height=33,

        },
        {
            -- switch_checkboxSelected
            x=207,
            y=41,
            width=33,
            height=33,

        },
        {
            -- switch_handle
            x=188,
            y=89,
            width=31,
            height=31,

        },
        {
            -- switch_handleOver
            x=172,
            y=40,
            width=31,
            height=31,

        },
        {
            -- switch_overlay
            x=101,
            y=89,
            width=83,
            height=31,

        },
        {
            -- switch_radioButtonDefault
            x=145,
            y=155,
            width=33,
            height=34,

        },
        {
            -- switch_radioButtonSelected
            x=214,
            y=3,
            width=33,
            height=34,

        },
    },
    
    sheetContentWidth = 250,
    sheetContentHeight = 212
}

SheetInfo.frameIndex =
{

    ["progressView_leftFill"] = 1,
    ["progressView_middleFill"] = 2,
    ["progressView_outerFrame"] = 3,
    ["progressView_rightFill"] = 4,
    ["searchField_bar"] = 5,
    ["searchField_remove"] = 6,
    ["segmentedControl_divider"] = 7,
    ["segmentedControl_left"] = 8,
    ["segmentedControl_leftOn"] = 9,
    ["segmentedControl_middle"] = 10,
    ["segmentedControl_middleOn"] = 11,
    ["segmentedControl_right"] = 12,
    ["segmentedControl_rightOn"] = 13,
    ["spinner_spinner"] = 14,
    ["stepper_minusActive"] = 15,
    ["stepper_noMinus"] = 16,
    ["stepper_noPlus"] = 17,
    ["stepper_nonActive"] = 18,
    ["stepper_plusActive"] = 19,
    ["switch_background"] = 20,
    ["switch_checkboxDefault"] = 21,
    ["switch_checkboxSelected"] = 22,
    ["switch_handle"] = 23,
    ["switch_handleOver"] = 24,
    ["switch_overlay"] = 25,
    ["switch_radioButtonDefault"] = 26,
    ["switch_radioButtonSelected"] = 27,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
