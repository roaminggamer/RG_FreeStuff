io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
require "ssk2.loadSSK"
_G.ssk.init( { measure = false } )
-- =====================================================
local cx     = display.contentCenterX
local cy     = display.contentCenterY
local fullw  = display.actualContentWidth
local fullh  = display.actualContentHeight
local left   = cx - fullw/2
local right  = cx + fullw/2
local top    = cy - fullh/2
local bottom = cy + fullh/2
-- =====================================================
-- YOUR CODE BELOW
-- =====================================================
local files = ssk.files

local options = 
{
    text = "",
    x = left + 40,    
    y = top + 40,
    width = fullw-80,
    font = "courier.ttf",
    fontSize = 14,
}
 local results = display.newText( options )
results.anchorX = 0
results.anchorY = 0


local tests = {}

tests[#tests+1] = 
{
   tst = "files.documents.getRoot()",
   out = files.documents.getRoot(),
}

tests[#tests+1] = 
{
   tst = "files.desktop.getDrivePath('/')",
   out = files.desktop.getDrivePath('/'),
}

local r = files.util.getFilesInFolder('/') or {}
r = table.tokenize( r, "; " ) or "failed?"
tests[#tests+1] = 
{
   tst = "files.util.getFilesInFolder('/')",
   out = r
}


local path = '/storage/emulated/0/'
local r = files.util.getFilesInFolder(path) or {}
r = table.tokenize( r, "; " ) or "failed?"
tests[#tests+1] = 
{
   tst = "files.util.getFilesInFolder('" .. path .. "')",
   out = r
}

files.util.mkFolder('/storage/emulated/0/bubba')
local path = '/storage/emulated/0'
local r = files.util.getFilesInFolder(path) or {}
r = table.tokenize( r, "; " ) or "failed?"
tests[#tests+1] = 
{
   tst = "files.util.getFilesInFolder('" .. path .. "')",
   out = r
}

tests[#tests+1] = 
{
   tst = 'files.resource.getPath("test.csv")',
   out = files.resource.getPath("test.csv")
}


local src = files.resource.getPath("test.csv")
local dst = '/storage/emulated/0/bubba/test.csv'
files.util.cpFile( src, dst )



local path = '/storage/emulated/0/bubba'
local r = files.util.getFilesInFolder(path) or {}
r = table.tokenize( r, "; " ) or "failed?"
tests[#tests+1] = 
{
   tst = "files.util.getFilesInFolder('" .. path .. "')",
   out = r
}


--
-- Print tests and results
--
local curY = top + 15
for i = 1, #tests do
	results.text = results.text .. tests[i].tst .. " ==> " .. tests[i].out .. "\n---------------------\n"
end


--[[ Steps in order:
require "ssk2.loadSSK"
_G.ssk.init( { measure = false } )

local files = ssk.files

files.util.mkFolder('/storage/emulated/0/bubba')

local src = files.resource.getPath("test.csv")
local dst = '/storage/emulated/0/bubba/test.csv'
files.util.cpFile( src, dst )


--]]
