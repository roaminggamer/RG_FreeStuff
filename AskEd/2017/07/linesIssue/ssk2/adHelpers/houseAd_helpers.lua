-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2017 (All Rights Reserved)
-- =============================================================
-- houseAdHelpers.lua
-- =============================================================
--[[

   Includes these functions:

   houseAdHelpers.add( params ) - Add an ad definition to our list of ads.
   houseAdHelpers.shuffle( [ adType ] ) - Randomize list(s) of ads.
   houseAdHelpers.show( adType [, params ] ) - Show an ad with optional params.
   houseAdHelpers.hide( ) - Hide any showing ads

--]]
-- =============================================================

--[[


ssk.display.newRect(nil, centerX, centerY, { w = fullw, h = fullh, fill = _GREY_ } )

local function onTouch( obj )
   table.dump( obj.info )
end
local function onTouch2( obj )
   print("BOOM")
end

local houseAdHelpers = ssk.adHelpers.houseAd
table.dump(houseAdHelpers)
houseAdHelpers.add( { adType = "banner", position = "bottom", filename = "images/house/banner1.jpg", onTouch = onTouch, info = { iosID = 1, androidID = 2 } } )
houseAdHelpers.add( { adType = "banner", position = "bottom", filename = "images/house/banner2.png", showParams = { position = "top" } } )
houseAdHelpers.add( { adType = "banner", position = "bottom", filename = "images/house/banner3.jpg" } )

houseAdHelpers.add( { adType = "interstitial", filename = "images/house/interstitials/somethingblue.png", onTouch = onTouch, info = { iosID = 1, androidID = 2 } } )
--houseAdHelpers.add( { adType = "interstitial", filename = "images/house/interstitial1.jpg", onTouch = onTouch, info = { iosID = 1, androidID = 2 } } )
--houseAdHelpers.add( { adType = "interstitial", filename = "images/house/interstitial2.jpg", onTouch = onTouch, info = { iosID = "aaaaaaaaaaa", androidID = 543543543543 } } )


houseAdHelpers.shuffle( "both" )

--houseAdHelpers.show( "banner", { position = "top", fitWidth = true, onTouch  } )
--timer.performWithDelay( 1000, function() houseAdHelpers.show( "banner", { } ) end, -1 )

local ad = houseAdHelpers.show( "interstitial", { onTouch = onTouch2, 
                                 --scale = 1.5,
                                 --flyIn = { sox = -fullw, delay = 500, time = 1000 },
                                 closeButton = {  
                                    filename = "images/house/close.png", 
                                    position = 3,
                                    offset = 5,
                                    --size = 64,
                                    baseDir = system.ResourceDirectory,
                                    fill = hexcolor("#ff452d") } } )

--timer.performWithDelay( 1000, function() houseAdHelpers.show( "interstitial", { fitWidth = (mRand(1,2)==1), fitHeight = (mRand(1,2)==1) } ) end, -1 )

--nextFrame( function() houseAdHelpers.hide() end, 1500 )

--]]

-- =============================================================
local debugLevel = 0
local function dPrint( level, ... )
   if( level <= debugLevel ) then
      print( unpack( arg ) )
   end
end

local houseAdHelpers = {}


function houseAdHelpers.setDebugLevel( newLevel )
   debugLevel = newLevel or 0 
end


local currentAd

local bannerAds = {}
local interstitialAds = {}
local lastBanner = 0
local lastInterstitial = 0

-- ==
--    House Ad Helper
-- ==
local function listener( self, event ) 
   if( event.phase ~= "ended" ) then return true end
end

-- =============================================================
-- add( params ) - Add an ad definition to our list of ads.
--
-- params - Parameters list with any of these parameters:
--
-- >     adType - "banner" or "interstitial"
-- >    onTouch - Callback to call when ad is touched.
-- >   filename - Full file path and name.
-- >       base - Path base system.ResourceDirectory (default), or
--                system.DocumentsDirectory
-- > showParams - Table of pre-set show parameters
-- >       info - Table of abirtrary values, passed to touch listener if used.
--
-- =============================================================
function houseAdHelpers.add( params )
   local newAd = {}
   if( params.adType == "banner" ) then
      bannerAds[#bannerAds+1] = newAd 
   else
      interstitialAds[#interstitialAds+1] = newAd 
   end
   newAd.showCount   = 0
   newAd.onTouch     = params.onTouch
   newAd.filename    = params.filename
   newAd.base        = params.base or system.ResourceDirectory
   newAd.showParams  = params.showParams or {}
   newAd.info        = params.info or {}
end

-- =============================================================
-- shuffle( [ adType ] ) - Randomize list(s) of ads.
-- =============================================================
function houseAdHelpers.shuffle( adType )
   if( not adType or adType == "both" )  then
      table.shuffle( bannerAds )
      table.shuffle( interstitialAds )

   elseif( adType == "banner" )  then
      table.shuffle( bannerAds )

   elseif( adType == "interstitial" )  then
      table.shuffle( interstitialAds )
   end
end


-- =============================================================
-- show( adType [, params ] ) - Show an ad with optional params.
--
-- =============================================================
function houseAdHelpers.show( adType, params )
   params = params or {}

   -- Destroy any ad currently showing
   display.remove(currentAd)

   --
   -- Show Banner Ad
   --
   if( adType == "banner" and #bannerAds > 0 )  then
      
      local curAd = display.newGroup()
      currentAd = curAd
      
      function curAd.enterFrame( self )
         if( autoIgnore( "enterFrame", self ) ) then return end
         self:toFront()
      end; listen("enterFrame", curAd )
      
      function curAd.finalize( self )
         ignore("enterFrame", self)
      end; curAd:addEventListener( "finalize" )

      lastBanner = lastBanner + 1
      lastBanner = (lastBanner > #bannerAds ) and 1 or lastBanner
      local filename = bannerAds[lastBanner].filename
      local base = bannerAds[lastBanner].base
      local position = params.position or bannerAds[lastBanner].showParams.position or "bottom"
      local fitWidth = fnn(params.fitWidth, bannerAds[lastBanner].showParams.fitWidth, false)
      local fitHeight = fnn(params.fitHeight, bannerAds[lastBanner].showParams.fitHeight, false)
      dPrint( 3,  lastBanner, filename, base, position, fitWidth, fitHeight )
      local onTouch = params.onTouch or bannerAds[lastBanner].onTouch
      local info = bannerAds[lastBanner].info

      curAd.img = display.newImage( curAd, filename, base, centerX, centerY )

      if( fitWidth ) then
         local scale = fullw/curAd.img.contentWidth
         curAd.img:scale( scale, scale )
      end

      if( position == "bottom" ) then
         curAd.img.anchorY = 1
         curAd.img.x = centerX
         curAd.img.y = bottom 
      else
         curAd.img.anchorY = 0
         curAd.img.x = centerX
         curAd.img.y = top
      end

      curAd.img.info = info

      if( onTouch ) then
         local function smartTouch( self, event  )
            if( event.phase == "ended" ) then 
               onTouch( self )
            end
         end
         ssk.misc.addSmartTouch( curAd.img, { toFront = false, listener = smartTouch, retval = true } )
      end

      return curAd

   --
   -- Show Interstitial Ad
   --
   elseif( adType == "interstitial" and #interstitialAds > 0 )  then

      local curAd = display.newGroup()
      currentAd = curAd


      local blocker = ssk.display.newImageRect( curAd, centerX,centerY, "images/fillT.png",
                                                { w = fullw, h = fullh } )


      if( params.closeButton ) then
         ssk.misc.addSmartTouch( blocker, { toFront = false,  retval = true } )
      else
         local function smartTouch( self, event  )
            if( event.phase == "ended" ) then 
               houseAdHelpers.hide()
            end
         end
         ssk.misc.addSmartTouch( blocker, { toFront = false, listener = smartTouch, retval = true } )
      end
      
      function curAd.enterFrame( self )
         if( autoIgnore( "enterFrame", self ) ) then return end
         self:toFront()
      end; listen("enterFrame", curAd )
      
      function curAd.finalize( self )
         ignore("enterFrame", self)
      end; curAd:addEventListener( "finalize" )

      lastInterstitial = lastInterstitial + 1
      lastInterstitial = (lastInterstitial > #interstitialAds ) and 1 or lastInterstitial
      local filename = interstitialAds[lastInterstitial].filename
      local base = interstitialAds[lastInterstitial].base
      local fitWidth = fnn(params.fitWidth, interstitialAds[lastInterstitial].showParams.fitWidth, false)
      local fitHeight = fnn(params.fitHeight, interstitialAds[lastInterstitial].showParams.fitHeight, false)
      dPrint( 3,  lastInterstitial, filename, base, position, fitWidth, fitHeight )
      local onTouch = params.onTouch or interstitialAds[lastInterstitial].onTouch
      local info = interstitialAds[lastInterstitial].info

      curAd.img = display.newImage( curAd, filename, base, centerX, centerY )

      if( params.scale ) then
         curAd.img:scale( params.scale, params.scale )

      elseif( fitWidth and fitHeight ) then
         local scaleW = fullw/curAd.img.contentWidth
         local scaleH = fullh/curAd.img.contentHeight
         curAd.img:scale( scaleW, scaleH )
      
      elseif( fitWidth ) then
         local scaleW = fullw/curAd.img.contentWidth
         curAd.img:scale( scaleW, scaleW )
      
      elseif( fitHeight ) then
         local scaleH = fullh/curAd.img.contentHeight
         curAd.img:scale( scaleH, scaleH )
      end

      curAd.img.info = info

      if( onTouch ) then
         local function smartTouch( self, event  )
            if( event.phase == "ended" ) then 
               onTouch( self )
            end
         end
         ssk.misc.addSmartTouch( curAd.img, { toFront = false, listener = smartTouch, retval = true } )
      end

      if( params.closeButton ) then
         local pos = params.closeButton.position or 3
         local baseDir = params.closeButton.baseDir or system.ResourceDirectory
         local size = math.floor(curAd.img.contentWidth/10)
         size = (size >= 32) and size or 32
         size = (params.closeButton.size) and params.closeButton.size or size
         local cbx, cby
         if( pos == 1 ) then
            cbx = curAd.img.x
            cby = curAd.img.y            
         
         elseif( pos == 2 ) then
            cbx = curAd.img.x
            cby = curAd.img.y            
         
         elseif( pos == 4 ) then
            cbx = curAd.img.x
            cby = curAd.img.y            

         else
            cbx = curAd.img.x - curAd.img.contentWidth/2 + size/2 + (params.closeButton.offset or 0)
            cby = curAd.img.y + curAd.img.contentHeight/2 - size/2 - (params.closeButton.offset or 0) 

         end

         local button = ssk.display.newImageRect( curAd, cbx, cby, params.closeButton.filename, 
                                    { baseDir = baseDir, size = size,
                                       fill = params.closeButton.fill } )

         local function onClose( self, event  )
            --table.dump(event)
            if( event.phase == "ended" ) then 
               houseAdHelpers.hide()
            end
         end
         ssk.misc.addSmartTouch( button, { toFront = false, listener = onClose, retval = true } )

         if( params.flyIn ) then            
            button.alpha = 0
            local delay = (params.flyIn.delay or 250) + (params.flyIn.time or 0)
            transition.to( button, { alpha = 1, delay = delay, time = 100 } )
         end

      end

      if( params.flyIn ) then
         ssk.easyIFC.easyFlyIn( curAd.img, params.flyIn)
      end

      return curAd   

   end

   return false
end

-- =============================================================
-- hide( ) - Hide any showing ads
--
-- =============================================================
function houseAdHelpers.hide( )
   display.remove(currentAd)
   currentAd = nil
end



return houseAdHelpers