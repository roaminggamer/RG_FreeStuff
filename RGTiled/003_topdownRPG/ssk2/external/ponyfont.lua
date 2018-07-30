--[[
The MIT License (MIT)

Copyright (c) 2016 Ponywolf

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]
-- ============================================================================
-- A bitmap font loader/render for CoronaSDK (ponyfont 0.3)
-- ============================================================================
local M = {}
M.cache = {} -- cache for loaded fonts
_G.ssk = _G.ssk or {}
_G.ssk.ponyFont = M


-- If you use UTF-8 characters, you will need to add this plugin to your
-- build settings
-- https://docs.coronalabs.com/plugin/utf8/index.html

--local utf8 = require("plugin.utf8") -- or require("lua-utf8") via luarocks 
local utf8

function M.enableUTF8()
  utf8 = require("plugin.utf8")
end

-- property update events by Jonathan Beebe
-- https://coronalabs.com/blog/2012/05/01/tutorial-property-callbacks/

local function addPropertyUpdate(obj)
  local t = {}
  t.raw = obj

  local mt = {
    __index = function(_,k)
      if k == "raw" then
        return rawget(t, "raw")
      end

      -- pass method and property requests to the display object
      if type(obj[k]) == 'function' then
        return function(...) arg[1] = obj; obj[k](unpack(arg)) end
      else
        return obj[k]
      end
    end,

    __newindex = function(tb,k,v)
      -- dispatch event before property update
      local event = {
        name = "propertyUpdate",
        target=tb,
        key=k,
        value=v
      }
      obj:dispatchEvent(event)

      -- update the property on the display object
      obj[k] = v
    end
  }
  setmetatable(t, mt)
  return t
end

local function parseFilename(filename)
  return string.match(filename,"(.-)([^\\/]-%.?([^%.\\/]*))$")
end

local function extract(s, p)
  return string.match(s, p), string.gsub(s, p, '', 1)
end

function M.newText(options)
  options = options or {}

  -- Modified .fnt loading code from bmf.lua
  -- Contacted author and he released under CC0

  local function loadFont(name)

    -- load the fnt
    local path, filename, ext = parseFilename(name)
    local font = { info = {}, spritesheets = {}, sprites = {}, chars = {}, kernings = {} }
    local contents = io.lines(system.pathForFile(path .. filename, system.ResourceDirectory))
    for line in contents do
      local t = {}
      local tag
      tag, line = extract(line, '^%s*([%a_]+)%s*')
      while string.len(line) > 0 do
        local k, v
        k, line = extract(line, '^([%a_]+)=')
        if not k then break end
        v, line = extract(line, '^"([^"]*)"%s*')
        if not v then
          v, line = extract(line, '^([^%s]*)%s*')
        end
        if not v then break end
        t[k] = v
      end
      if tag == 'info' or tag == 'common' then
        for k, v in pairs(t) do font.info[k] = v end
      elseif tag == 'page' then
        font.spritesheets[1 + t.id] = { file = t.file, frames = {} }
      elseif tag == 'char' then
        if( tonumber(t.id) > 255 and utf8 )then
          t.letter = utf8.char(t.id)        
        else
          t.letter = string.char(t.id)
        end
        font.chars[t.letter] = {}
        for k, v in pairs(t) do font.chars[t.letter][k] = v end
        if 0 + font.chars[t.letter].width > 0 and 0 + font.chars[t.letter].height > 0 then
          font.spritesheets[1 + t.page].frames[#font.spritesheets[1 + t.page].frames + 1] = {
            x = 0 + t.x,
            y = 0 + t.y,
            width = 0 + t.width,
            height = 0 + t.height,
          }
          font.sprites[t.letter] = {
            spritesheet = 1 + t.page,
            frame = #font.spritesheets[1 + t.page].frames
          }
        end
      elseif tag == 'kerning' then
        font.kernings[string.char(t.first) .. string.char(t.second)] = 0 + t.amount
      end
    end
    for k, v in pairs(font.spritesheets) do
      font.spritesheets[k].sheet = graphics.newImageSheet(path .. v.file, v)
    end
    for k, v in pairs(font.sprites) do
      font.sprites[k].frame = v.frame
    end
    return font
  end

  -- create displayGroup instance
  local instance = options.parent and display.newGroup(options.parent) or display.newGroup()

  -- load font if not in cache
  local fontFile = options.font or "default"
  if not M.cache[fontFile] then
    M.cache[fontFile] = loadFont(fontFile)
  end  
  instance.bitmapFont = M.cache[fontFile]

  -- Brand-spanking new render code with scaling to fontSize,
  -- word wrapping to width and general performance and 
  -- readability updates

  function instance:anchor()
    local w,h = self._width or self.width, self.height
    local x,y = self.anchorX or 0.5, self.anchorY or 0.5
    for i = self.numChildren, 1, -1 do
      if self[i]._x and self[i]._y then
        self[i].x = self[i]._x
        self[i].y = self[i]._y
        self[i]:translate(-w * x, -h * y)
      end
    end
  end

  function instance:justify(align)
    if not self._width then return false end
    -- grab first letter
    local letter = self[1]
    if not letter then return false end

    -- default
    align = self.align or "left"
    local x, last, lastX, w = 0, 1, letter.x, self._width or self.width

    -- push stuff around
    for i = 1, self.numChildren do
      if self[i]._x and self[i]._y then        
        x = self[i].x + self[i].width
        if (x < lastX) or (i == self.numChildren) then -- wrapped
          -- diff is based on assigned width
          local diff = w - lastX
          if align == "right" then 
            diff = diff - w/2
          elseif align == "center" then 
            diff = (diff * 0.5) - w/4 
          else
            diff = 0
          end
          for j = last, i-((i == self.numChildren) and 0 or 1) do
            self[j]:translate(diff,0)
            self[i].xScale = self[i]._xScale
            self[i].yScale = self[i]._yScale              
          end
          last = i
        end
        lastX = x - self[i].width/2
      end
    end
  end

  function instance:render()
    local text = self.text
    local font = self.bitmapFont
    local info = font.info
    local scale = self.fontSize / info.size

    -- clear previous text
    for i = self.numChildren, 1, -1 do 
      display.remove(self[i])
    end

    -- locals
    local x, y = 0, 0
    local last = ''
    local lastWord = 0

    local function kern(x, pair)
      if font.kernings[pair] then
        x = x + font.kernings[pair]
      end
      return x
    end

    if text then
      for letter in string.gmatch(text..'\n', '(.)') do
        if letter == '\n' then -- newline
          x = 0; y = y + info.lineHeight
        elseif font.chars[letter] then
          if tonumber(font.chars[letter].width) > 0 and tonumber(font.chars[letter].height) > 0 then
            local glyph = display.newImage(font.spritesheets[font.sprites[letter].spritesheet].sheet, font.sprites[letter].frame)
            x = kern(x, last .. letter)
            glyph.anchorX, glyph.anchorY = 0, 0            
            glyph.xScale = scale
            glyph.yScale = scale            
            glyph.x = scale * (font.chars[letter].xoffset + x)
            glyph.y = scale * (font.chars[letter].yoffset + y)
            glyph._x = glyph.x -- orginal offset from self's x
            glyph._y = glyph.y -- orginal offset from self's y 
            glyph._xScale = glyph.xScale
            glyph._yScale = glyph.yScale   
            glyph.chr = letter
            last = letter
            lastWord = lastWord + 1
            self:insert(glyph)          
          elseif letter==' ' then
            --print (lastWord)
            lastWord = 0 -- save x of last word
          end
          x = x + font.chars[letter].xadvance
          if self._width and (x * scale) > self._width then
            x = 0; y = y + info.lineHeight
            for i = self.numChildren - lastWord + 1, self.numChildren do
              local glyph = self[i]
              local wrapped = glyph.chr
              x = kern(x, last .. wrapped)
              glyph.x = scale * (font.chars[wrapped].xoffset + x)
              glyph.y = scale * (font.chars[wrapped].yoffset + y)
              glyph.xScale = scale
              glyph.yScale = scale
              glyph._x = glyph.x -- orginal offset from self's x
              glyph._y = glyph.y -- orginal offset from self's y 
              x = x + font.chars[wrapped].xadvance
              last = wrapped
            end
          end
        end
      end
    end
    self:anchor()    
    self:justify()    
  end

  instance = addPropertyUpdate(instance)
  function instance:propertyUpdate(event)
    if event.key == "text" then
      self.text = event.value
      self:render()    
    elseif event.key == "anchorX" then
      self.anchorX = event.value
      self:anchor()
    elseif event.key == "anchorY" then
      self.anchorY = event.value
      self:anchor()    
    elseif event.key == "align" then
      self.align = event.value
      self:justify()      
    elseif event.key == "fontSize" then
      self.fontSize = event.value
      self:render()       
    elseif event.key == "width" then
      self._width = event.value
      self:render()     
    elseif event.key == "x" then
      self._x = event.value
      self.x = self._x
    elseif event.key == "y" then
      self._y = event.value
      self.y = self._y
    end
  end

  function instance:finalize(event)
    self:removeEventListener("propertyUpdate")
  end

  -- set options
  instance.align = options.align or "left"
  instance.fontSize = options.fontSize or 24
  instance.x = options.x or 0
  instance.y = options.y or 0
  instance._x, instance._y = instance.x, instance.y
  instance._width = options.width
  instance.text = options.text
  instance:render()

  -- add listeners
  instance:addEventListener("propertyUpdate")
  instance:addEventListener("finalize")

  return instance

end

return M

