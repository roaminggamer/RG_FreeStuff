-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
local files = ssk.files

local header = 
[[
-- =============================================================
-- !!!         THIS FILE IS GENERATED DO NOT EDIT            !!!
-- =============================================================
--
local mgr         = require mgr_path
base_params
]]

local base_params = 
[[
-- =============================================================
-- ======= BASE PARAMS
-- =============================================================
local base_params = {}
]]


local template = 
[[-- ============================
-- ======= prefix1bname1 Button
-- ============================
local params params_clone
params.w                 = bwidth
params.h                 = bheight
params.unselImgSrc       = "img_pathbimage_unsel"
params.selImgSrc         = "img_pathbimage_sel"
params.toggledImgSrc     = "img_pathbimage_toggled"
params.lockedImgSrc      = "img_pathbimage_locked"

mgr:addButtonPreset( "prefix2bname2", params )]]



-- =============================================================
-- Module Begins
-- =============================================================
local utils = {}



function utils.generateButtonPresets( params , debugEn )
   params = params or {}
   local base = params.base
   local mgr = params.mgr or "ssk2.core.interfaces.buttons"
   local images = params.images or "images/buttons/"
   local prefix = params.prefix
   local saveFile = params.saveFile or "scripts/presets_gen"
   --
   local path = ssk.files.resource.getPath(images)
   local allFiles = ssk.files.util.findAllFiles(path)

   --
   local template = template
   local header = header
   --
   header = string.gsub( header, "mgr_path", "'" .. mgr .. "'" )
   template = string.gsub( template, "img_path", images )


   if( base ) then 
      local base_params = base_params
      for k,v in pairs( base ) do
         -- string
         if( type(v) == "string" ) then
            base_params = base_params .. "base_params." .. k .. " = " .. "'" .. v .. "'" .. "\n"

         -- boolean
         elseif( type(v) == "boolean" ) then
            --base_params = base_params .. k .. " = " .. (v and "true" or "false" )
            base_params = base_params .. "base_params." .. k .. " = " .. tostring(v) .. "\n"

         -- number
         elseif( type(v) == "number" ) then
            base_params = base_params .. "base_params." .. k .. " = " .. tostring(v) .. "\n"

         -- table
         elseif( type(v) == "table" ) then
            base_params = base_params .. "base_params." .. k .. " = " .. "{ "
            for i = 1, #v do
               base_params = base_params .. tonumber(v[i])
               if( i < #v ) then
                  base_params = base_params .. ", "
               end
            end
            base_params = base_params .. " }\n"

         end
      end
      header = string.gsub( header, "base_params", "\n" .. base_params )

      template = string.gsub( template, "params_clone", "= table.shallowCopy( base_params )" )

   else
      header = string.gsub( header, "base_params", "" )

      template = string.gsub( template, "params_clone", "= {}" )
   end

   --
   for k,v in pairs(allFiles) do
      if( not string.match( v, "%.png" ) and not string.match( v, "%.jpg" ) ) then
         allFiles[k] = nil
      end
   end
   --   
   if( debugEn ) then
      table.dump(allFiles)
   end

   --
   local processed = {}

   -- Process filenames
   for k,v in pairs( allFiles ) do
      local rec = {}
      processed[#processed+1] = rec
      --
      local filename    = v
      local parts       = string.split( filename, "%." )
      local ext         = parts[#parts]
      local prefix      = parts[1]
      local parts       = string.split( prefix, "_" )
      rec.filename      = filename
      rec.ext           = ext
      rec.type          = ( #parts == 1 ) and "basic" or parts[2]
      rec.name          = parts[1]
   end
   --
   --table.print_r( processed )

   local function findNameByType( name, btype )
      for i = 1,#processed do
         local rec = processed[i]
         if( rec.name == name and rec.type == btype ) then
            return rec
         end
      end
      return nil
   end

   local function addToggled( out, rec )
      if( findNameByType( rec.name, "toggled" ) ) then
         out = string.gsub( out, "bimage_toggled", rec.name .. "_toggled." .. rec.ext )
      end
      --
      if( string.match( out, "bimage_toggled") ) then
         local tmp = string.split(out,"\n")
         out = ""         
         for i = 1, #tmp do
            if( string.match( tmp[i], "bimage_toggled") ) then
            else
               out = out .. tmp[i]
               out = (i<#tmp) and (out .. "\n") or out
            end
         end
      end
      --
      return out
   end

   local function addLocked( out, rec )
      if( findNameByType( rec.name, "locked" ) ) then
         out = string.gsub( out, "bimage_locked", rec.name .. "_locked." .. rec.ext )
      end
      --
      if( string.match( out, "bimage_locked") ) then
         local tmp = string.split(out,"\n")
         out = ""         
         for i = 1, #tmp do
            if( string.match( tmp[i], "bimage_locked") ) then
            else
               out = out .. tmp[i]
               out = (i<#tmp) and (out .. "\n") or out
            end
         end
      end
      --
      return out
   end


   --
   -- Generate Presets File
   --
   local generated = {}
   --
   local outPath = ssk.files.resource.getPath( saveFile )
   ssk.files.util.writeFile( header, outPath )

   -- Basic Buttons
   for i = 1, #processed do
      local rec = processed[i]
      if( rec.type == "basic" and not generated[rec.name] ) then
         generated[rec.name] = true
         --
         local bwidth, bheight = ssk.misc.getImageSize ( images .. rec.filename )
         local out = template
         out = string.gsub( out, "bname1", string.upper(rec.name) )
         out = string.gsub( out, "bname2", rec.name )
         if( prefix ) then
            out = string.gsub( out, "prefix1", string.upper( prefix .. "_" ) .. "_"  )
            out = string.gsub( out, "prefix2", prefix .. "_" )
         else
            out = string.gsub( out, "prefix1", "" )
            out = string.gsub( out, "prefix2", "" )            
         end
         out = string.gsub( out, "bimage_unsel", rec.filename )
         out = string.gsub( out, "bimage_sel", rec.filename )
         out = string.gsub( out, "bwidth", bwidth )
         out = string.gsub( out, "bheight", bheight )
         out = addToggled( out, rec ) -- just to clean
         out = addLocked( out, rec ) -- just to clean
         --print(out)
         --
         ssk.files.util.appendFile( out, outPath )
         ssk.files.util.appendFile( "\n", outPath )
         ssk.files.util.appendFile( "\n", outPath )
      end
   end

   -- sel/unsel buttons
   for i = 1, #processed do
      local rec = processed[i]
      local other 
      if( rec.type == "sel" ) then
         other = findNameByType( rec.name, "unsel" )
      end
      if( other and not generated[rec.name] ) then
         generated[rec.name] = true
         --
         local bwidth, bheight = ssk.misc.getImageSize ( images .. rec.filename )
         local out = template
         out = string.gsub( out, "bname1", string.upper(rec.name) )
         out = string.gsub( out, "bname2", rec.name )
         if( prefix ) then
            out = string.gsub( out, "prefix1", string.upper( prefix .. "_" ) .. "_"  )
            out = string.gsub( out, "prefix2", prefix .. "_" )
         else
            out = string.gsub( out, "prefix1", "" )
            out = string.gsub( out, "prefix2", "" )            
         end
         out = string.gsub( out, "bimage_unsel", rec.name .. "_unsel." .. rec.ext )
         out = string.gsub( out, "bimage_sel", rec.name .. "_sel." .. rec.ext )
         out = string.gsub( out, "bwidth", bwidth )
         out = string.gsub( out, "bheight", bheight )
         out = addToggled( out, rec )
         out = addLocked( out, rec )
         --print(out)
         --
         ssk.files.util.appendFile( out, outPath )
         ssk.files.util.appendFile( "\n", outPath )
         ssk.files.util.appendFile( "\n", outPath )
      end
   end

   -- on/off buttons
   for i = 1, #processed do
      local rec = processed[i]
      local other 
      if( rec.type == "on" ) then
         other = findNameByType( rec.name, "off" )
      end
      if( other and not generated[rec.name] ) then
         generated[rec.name] = true
         --
         local bwidth, bheight = ssk.misc.getImageSize ( images .. rec.filename )
         local out = template
         out = string.gsub( out, "bname1", string.upper(rec.name) )
         out = string.gsub( out, "bname2", rec.name )
         if( prefix ) then
            out = string.gsub( out, "prefix1", string.upper( prefix .. "_" ) .. "_"  )
            out = string.gsub( out, "prefix2", prefix .. "_" )
         else
            out = string.gsub( out, "prefix1", "" )
            out = string.gsub( out, "prefix2", "" )            
         end
         out = string.gsub( out, "bimage_unsel", rec.name .. "_off." .. rec.ext )
         out = string.gsub( out, "bimage_sel", rec.name .. "_on." .. rec.ext )
         out = string.gsub( out, "bwidth", bwidth )
         out = string.gsub( out, "bheight", bheight )
         out = addToggled( out, rec )
         out = addLocked( out, rec )
         --print(out)
         --
         ssk.files.util.appendFile( out, outPath )
         ssk.files.util.appendFile( "\n", outPath )
         ssk.files.util.appendFile( "\n", outPath )
      end
   end
end


-- ==
-- (Re-) Position Buttons
-- If useTransitions is 'true', then move buttons with transition.* lib.
-- ==
utils.positionButtons = function( buttons, tween, params )
   if( not buttons or #buttons == 0 ) then return end
   --
   local buttonW  = buttons[1].contentWidth
   if( not tween ) then
      local totalBW = #buttons * buttonW
      tween = math.floor( (fullw - totalBW )/(#buttons+1) )
   end
   
   local curX     = centerX - ((#buttons * buttonW) + ((#buttons-1) * tween))/2 + buttonW/2
   for i = 1, #buttons do
      local button = buttons[i]
      if( params ) then
         local function onComplete()
            button:resetStartPosition()
         end
         params.time       = params.time or 500
         params.transition   = params.transition or easing.outBack
         params.x          = curX
         params.onComplete = onComplete
         transition.to( button, params )
      else
         button.x = curX
         button:resetStartPosition()
      end
      curX = curX + buttonW + tween
   end
end


return utils
