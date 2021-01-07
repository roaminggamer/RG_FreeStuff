io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)

local unusedWidth     = display.actualContentWidth - display.contentWidth
local unusedHeight    = display.actualContentHeight - display.contentHeight
local left            = 0 - unusedWidth/2
local top             = 0 - unusedHeight/2
local right           = display.contentWidth + unusedWidth/2
local bottom          = display.contentHeight + unusedHeight/2

_G.appId          = "ca-app-pub-################~##########"
_G.bannerID       = "ca-app-pub-################/##########"
_G.interstitialID = "ca-app-pub-################/##########"
_G.testMode       = true

-- local function test1()
--    local admob = require( "plugin.admob" )

--    local function adListener( event )
--       for k,v in pairs( event ) do
--          print("adListener ", k, v ) -- so you see everything you get
--       end
--    end

--    admob.init( adListener, { appId = appId, testMode = testMode } )

--    timer.performWithDelay( 2000,
--       function()
--          admob.load( "banner", { adUnitId  = bannerID } )
--       end )

--    timer.performWithDelay( 4000,
--       function()
--          admob.show( "banner", {  y = "top"  } )
--       end )
-- end

-- local function test2()
--    local admob_test = require "admob_test"
--    admob_test.create()
-- end


-- -- test1()
-- test2()
