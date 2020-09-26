-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
local lfs         = require "lfs"
local json        = require "json"

local strGSub     = string.gsub
local strSub      = string.sub
local strFormat   = string.format
local strFind     = string.find

local easyIFC     = ssk.easyIFC

local RGFiles

local tests = {}

local function onExplore( event )
   local target = event.target
   print( target.myPath )
   print( "Exploring " .. tostring( RGFiles.util.repairPath( target.myPath ) ) )
   RGFiles.desktop.explore( RGFiles.util.repairPath( target.myPath ) )   
end


--
-- folderRoots() -- 
--
function tests.folderRoots( group, startY )
   group = group or display.currentStage
   startY = startY or 0
   print("Running RGFiles - folderRoots( )")

   local function doPathButton( myPathName, myPath, y )
      local label1 = easyIFC:quickLabel( group, "Folder Roots Test : " .. myPathName, left + 10, 0, ssk.__gameFont, 16, _W_, 0 )
      local label2 = easyIFC:quickLabel( group, "  => " .. myPath, left + 10, 0, ssk.__gameFont, 22, _W_, 0 )
      if( label2.contentWidth > (fullw + 20)) then
         local scale = (fullw-20)/label2.contentWidth
         label2:scale(scale,scale)
      end

      local button = easyIFC:presetPush( group, "default", centerX, y + 30, fullw - 10, 60, "", onExplore )
      button.myPath = myPath
      label1:toFront()
      label2:toFront()
      label1.y = button.y - 12
      label2.y = button.y + 12
      if( RGFiles.util.exists( myPath ) ) then
         label2:setFillColor(0,1,0)
      else
         label2:setFillColor(1,0,0)
      end

      if( _G.onDevice ) then button:disable()  end

      return button
   end

   local button
   button = doPathButton( "system.DocumentsDirectory", RGFiles.util.repairPath( RGFiles.documents.getRoot(), true ), startY)
   if( not _G.onAndroid ) then
      button = doPathButton( "system.ResourceDirectory", RGFiles.util.repairPath( RGFiles.resource.getRoot(), true ), startY + 65 )
   end
   if( _G.onDesktop or _G.onSimulator ) then
      button = doPathButton( "My Documents Folder", RGFiles.util.repairPath( RGFiles.desktop.getMyDocumentsRoot(), true ), startY + 130 )
      button = doPathButton( "Desktop Folder", RGFiles.util.repairPath( RGFiles.desktop.getDesktopRoot(), true ), startY + 195 )
      if( _G.onWin ) then
         button = doPathButton( "X:\\", RGFiles.util.repairPath( RGFiles.desktop.getDrivePath("X:/"), true ), startY + 260 )
      else
      end
   end

   return button.y + button.contentHeight/2
end


--
-- foldersTest() -- 
--
function tests.foldersTest( group, startY, testFoldername )
   group = group or display.currentStage
   startY = startY or 0
   testFoldername = testFoldername or "pinkUnicorns"

   print("Running RGFiles - foldersTest( )")

   local function doPathButton( myPathName, baseFoldername , y )

      local curNum = 1

      local foldername  = baseFoldername .. "_" .. curNum


      local label1 = easyIFC:quickLabel( group, "Folders Test : " .. myPathName, left + 10, 0, ssk.__gameFont, 16, _W_, 0 )
      local label2 = easyIFC:quickLabel( group, "  => " .. foldername, left + 10, 0, ssk.__gameFont, 22, _W_, 0 )
      if( label2.contentWidth > (fullw + 20)) then
         local scale = (fullw-20)/label2.contentWidth
         label2:scale(scale,scale)
      end

      local button = easyIFC:presetPush( group, "default", centerX, y + 30, fullw - 10, 60, "", onExplore )
      button.myPath = foldername
      label1:toFront()
      label2:toFront()
      label1.y = button.y - 12
      label2.y = button.y + 12
      function label2.enterFrame( self )
         if( RGFiles.util.exists( foldername ) ) then
            self:setFillColor(0,1,0)
         else
            self:setFillColor(1,0,0)
         end
      end 
      listen( "enterFrame", label2 )

      local function onMake()
         RGFiles.util.mkFolder( RGFiles.util.repairPath( foldername ) )
      end
      local function onRemove()
         RGFiles.util.rmFolder( RGFiles.util.repairPath( foldername ) )
      end

      local function onMove()
         if( curNum == 1 ) then
            curNum = 2
         else
            curNum = 1            
         end
         local newFoldername = baseFoldername .. "_" .. curNum 
         RGFiles.util.mvFolder( RGFiles.util.repairPath( foldername ), RGFiles.util.repairPath( newFoldername )  )
         foldername = newFoldername
         label2.text = " => " .. foldername

         button.myPath = foldername
      end

      local function onCopy()
         RGFiles.util.cpFolder( RGFiles.util.repairPath( foldername ), 
                                RGFiles.util.repairPath( foldername ) .. "_COPY",
                                true )
      end


      local mkButton = easyIFC:presetPush( group, "default", 
                                           button.x + button.contentWidth/2 - 350, button.y - 15,
                                           80, 20, "make", onMake, 
                                           { unselRectFillColor   = { 0.25,  0.75,  0.25, 1},
                                             selRectFillColor  = {0, 1, 0, 1}, } )

      local mkButton = easyIFC:presetPush( group, "default", 
                                           button.x + button.contentWidth/2 - 250, button.y - 15,
                                           80, 20, "remove", onRemove, 
                                           { unselRectFillColor   = { 0.75,  0.25,  0.25, 1},
                                             selRectFillColor  = {1, 0, 0, 1}, } )

      local mkButton = easyIFC:presetPush( group, "default", 
                                           button.x + button.contentWidth/2 - 150, button.y - 15,
                                           80, 20, "move", onMove, 
                                           { unselRectFillColor   = { 0.25,  0.75,  0.75, 1},
                                             selRectFillColor  = {0, 1, 1, 1}, } )

      local cpButton = easyIFC:presetPush( group, "default", 
                                           button.x + button.contentWidth/2 - 50, button.y - 15,
                                           80, 20, "copy", onCopy, 
                                           { unselRectFillColor   = { 0.75,  0.75,  0.25, 1},
                                             selRectFillColor  = {1, 1, 0, 1}, } )


      if( _G.onDevice ) then button:disable()  end

      return button
   end

   local button   
   local folder = RGFiles.util.repairPath( RGFiles.documents.getPath( testFoldername ), true )   
   button = doPathButton( "system.DocumentsDirectory", folder, startY )

   if( not _G.onAndroid ) then
      local folder = RGFiles.util.repairPath( RGFiles.resource.getPath( testFoldername ), true )   
      button = doPathButton( "system.ResourceDirectory", folder, startY + 65 )
   end

   if( _G.onDesktop or _G.onSimulator ) then
      local folder = RGFiles.util.repairPath( RGFiles.desktop.getMyDocumentsPath( testFoldername ), true )   
      button = doPathButton( "system.ResourceDirectory", folder, startY + 130 )

      local folder = RGFiles.util.repairPath( RGFiles.desktop.getDesktopPath( testFoldername ), true )   
      button = doPathButton( "system.ResourceDirectory", folder, startY + 195 )

      if( _G.onWin ) then
         local folder = RGFiles.util.repairPath( RGFiles.desktop.getDrivePath( "X:/" .. testFoldername ), true )   
         button = doPathButton( "system.ResourceDirectory", folder, startY + 260 )
      else
      end
   end
   
   return button.y + button.contentHeight/2
end


--
-- filesTest() -- 
--
function tests.filesTest( group, startY, testFoldername, testFilename )
   group = group or display.currentStage
   startY = startY or 0
   testFoldername = testFoldername or "pinkUnicorns_1"
   testFilename = testFilename or "super1337Coders"


   print("Running RGFiles - filesTest( )")

   local function doPathButton( myPathName, folder, baseFilename , y )

      local curNum = 1

      local filename  = baseFilename .. "_" .. curNum .. ".txt"


      local label1 = easyIFC:quickLabel( group, "Files Test : " .. myPathName, left + 10, 0, ssk.__gameFont, 16, _W_, 0 )
      local label2 = easyIFC:quickLabel( group, "  => " .. filename, left + 10, 0, ssk.__gameFont, 22, _W_, 0 )
      if( label2.contentWidth > (fullw + 20)) then
         local scale = (fullw-20)/label2.contentWidth
         label2:scale(scale,scale)
      end

      local button = easyIFC:presetPush( group, "default", centerX, y + 30, fullw - 10, 60, "", onExplore )
      button.myPath = folder
      label1:toFront()
      label2:toFront()
      label1.y = button.y - 12
      label2.y = button.y + 12
      function label2.enterFrame( self )
         if( RGFiles.util.exists( filename ) ) then
            self:setFillColor(0,1,0)
         else
            self:setFillColor(1,0,0)
         end
      end 
      listen( "enterFrame", label2 )

      local function onMake()
         RGFiles.util.writeFile( "hello",  RGFiles.util.repairPath( filename ) )
      end
      local function onRemove()
         RGFiles.util.rmFile( RGFiles.util.repairPath( filename ) )
      end
      local function onMove()
         if( curNum == 1 ) then
            curNum = 2
         else
            curNum = 1            
         end
         local newFilename = baseFilename .. "_" .. curNum .. ".txt"
         RGFiles.util.mvFile( RGFiles.util.repairPath( filename ), RGFiles.util.repairPath( newFilename )  )
         filename = newFilename
         label2.text = " => " .. filename
      end


      local mkButton = easyIFC:presetPush( group, "default", 
                                           button.x + button.contentWidth/2 - 350, button.y - 15,
                                           80, 20, "make", onMake, 
                                           { unselRectFillColor   = { 0.25,  0.75,  0.25, 1},
                                             selRectFillColor  = {0, 1, 0, 1}, } )

      local mkButton = easyIFC:presetPush( group, "default", 
                                           button.x + button.contentWidth/2 - 250, button.y - 15,
                                           80, 20, "remove", onRemove, 
                                           { unselRectFillColor   = { 0.75,  0.25,  0.25, 1},
                                             selRectFillColor  = {1, 0, 0, 1}, } )

      local mkButton = easyIFC:presetPush( group, "default", 
                                           button.x + button.contentWidth/2 - 150, button.y - 15,
                                           80, 20, "move", onMove, 
                                           { unselRectFillColor   = { 0.25,  0.75,  0.75, 1},
                                             selRectFillColor  = {0, 1, 1, 1}, } )

      if( _G.onDevice ) then button:disable()  end
      return button
   end

   local button   
   local folder = RGFiles.util.repairPath( RGFiles.documents.getPath( testFoldername ), true )   
   local filename = RGFiles.util.repairPath( folder .. "/" .. testFilename, true ) 
   button = doPathButton( "system.DocumentsDirectory", folder, filename, startY )

   if( not _G.onAndroid ) then
      local folder = RGFiles.util.repairPath( RGFiles.resource.getPath( testFoldername ), true )   
      local filename = RGFiles.util.repairPath( folder .. "/" .. testFilename, true ) 
      button = doPathButton( "system.ResourceDirectory", folder, filename, startY + 65 )
   end

   if( _G.onDesktop or _G.onSimulator ) then
      local folder = RGFiles.util.repairPath( RGFiles.desktop.getMyDocumentsPath( testFoldername ), true )   
      local filename = RGFiles.util.repairPath( folder .. "/" .. testFilename, true ) 
      button = doPathButton( "system.ResourceDirectory", folder, filename, startY + 130 )

      local folder = RGFiles.util.repairPath( RGFiles.desktop.getDesktopPath( testFoldername ), true )   
      local filename = RGFiles.util.repairPath( folder .. "/" .. testFilename, true ) 
      button = doPathButton( "system.ResourceDirectory", folder, filename, startY + 195 )

      if( _G.onWin ) then
         local folder = RGFiles.util.repairPath( RGFiles.desktop.getDrivePath( "X:/" .. testFoldername ), true )   
         local filename = RGFiles.util.repairPath( folder .. "/" .. testFilename, true ) 
         button = doPathButton( "system.ResourceDirectory", folder, filename, startY + 260 )
      else
      end
   end
   
   return button.y + button.contentHeight/2
end


-- =============================================================
-- =============================================================
function tests.attach( module )
   RGFiles = module
   module.tests = tests
end
return tests


-- =============================================================
-- TRASH   TRASH   TRASH   TRASH   TRASH   TRASH   TRASH   TRASH   
-- =============================================================
--[[
--
-- mkFoldersTest() -- 
--
function tests.mkFoldersTest( group, startY, testFoldername )
   group = group or display.currentStage
   startY = startY or 0
   testFoldername = testFoldername or "pinkUnicorns"
   print("Running RGFiles - mkFoldersTest( )")

   local function doPathButton( myPathName, myPath, y )
      local label1 = easyIFC:quickLabel( group, "Make Folders Test : " .. myPathName, left + 10, 0, ssk.__gameFont, 16, _W_, 0 )
      local label2 = easyIFC:quickLabel( group, "  => " .. myPath, left + 10, 0, ssk.__gameFont, 22, _W_, 0 )
      if( label2.contentWidth > (fullw + 20)) then
         local scale = (fullw-20)/label2.contentWidth
         label2:scale(scale,scale)
      end

      local button = easyIFC:presetPush( group, "default", centerX, y + 30, fullw - 10, 60, "", onExplore )
      button.myPath = myPath
      label1:toFront()
      label2:toFront()
      label1.y = button.y - 12
      label2.y = button.y + 12
      --nextFrame( 
         --function()
            if( RGFiles.util.exists( myPath ) ) then
               label2:setFillColor(0,1,0)
            else
               label2:setFillColor(1,0,0)
            end
         --end, 100 )

      return button
   end

   --local label1 = easyIFC:quickLabel( group, "Folder Roots:", left + 10, top + y + 0 * 30, ssk.__gameFont, 16, _W_, 0 )
   --startY = startY + 

   local button
   local dst = RGFiles.util.repairPath( RGFiles.documents.getPath( testFoldername ), true )
   RGFiles.util.mkFolder( RGFiles.util.repairPath( dst ) )
   button = doPathButton( "system.DocumentsDirectory", dst, startY )
   
   local dst = RGFiles.util.repairPath( RGFiles.resource.getPath( testFoldername ), true )
   RGFiles.util.mkFolder( RGFiles.util.repairPath( dst ) )
   button = doPathButton( "system.ResourceDirectory", dst, startY + 65 )
   
   local dst = RGFiles.util.repairPath( RGFiles.desktop.getMyDocumentsPath( testFoldername ), true )
   RGFiles.util.mkFolder( RGFiles.util.repairPath( dst ) )
   button = doPathButton( "My Documents Folder", dst, startY + 130 )
   
   local dst = RGFiles.util.repairPath( RGFiles.desktop.getDesktopPath( testFoldername ), true )
   RGFiles.util.mkFolder( RGFiles.util.repairPath( dst ) )
   button = doPathButton( "Desktop Folder", dst, startY + 195 )
   
   if( _G.onWin ) then
      local dst = RGFiles.util.repairPath( RGFiles.desktop.getDrivePath( "X:/" .. testFoldername ), true )
      RGFiles.util.mkFolder( RGFiles.util.repairPath( dst ) )
      button = doPathButton( "X:\\", dst, startY + 260 )
   end

   return button.y + button.contentHeight/2
end

--]]

