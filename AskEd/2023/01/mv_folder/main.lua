io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)

-- =====================================================
-- 1. Load and initialize SSK2 (ONCE ONLY IN MAIN.LUA)
-- =====================================================
require "ssk2.loadSSK"
_G.ssk.init( { measure = false } )
-- =====================================================


-- =====================================================
-- 2. Create sub-folder in temporary and copy some files  to it so we have a folder and files to demonstrate this example.
--
-- (ONLY FOR THIS EXAMPLE)
-- =====================================================
local medievalPath 	= ssk.files.resource.getPath( 'images/medieval' )
local temporaryRoot = ssk.files.temporary.getRoot()

-- ssk.files.desktop.explore(medievalPath) -- Uncomment to open in your Windows or OSX runs
-- ssk.files.desktop.explore(temporaryRoot) -- Uncomment to open in your Windows or OSX runs

local dstFolder     = ssk.files.temporary.getPath( 'medieval' )

ssk.files.util.cpFolder( medievalPath, dstFolder )
-- ssk.files.desktop.explore(dstFolder) -- Uncomment to open in your Windows or OSX runs


-- =====================================================
-- 3. Example of how to move folder SRC to DST
--
--  Folder SRC is system.TemporaryFolder/medieval (created and filed above for this example)
--  Folder DST is system.DocumentsFolder/medieval is the destination for our move
--
-- =====================================================
local src = ssk.files.temporary.getPath( 'medieval' )
local dst = ssk.files.documents.getPath( 'medieval' )

-- local documentsRoot = ssk.files.documents.getRoot()
-- ssk.files.desktop.explore(src)
-- ssk.files.desktop.explore(documentsRoot)

if( ssk.files.util.isFolder( dst ) ) then
	print("Warning!  ", dst, " already exists!  Move may fail (depending upon OS)." )
	print("Deleting folder first." )
	ssk.files.util.rmFolder( dst )
end

ssk.files.util.mvFolder( src, dst )
