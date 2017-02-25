require "ssk2.loadSSK"
_G.ssk.init( {} )


--
-- 1. Print path of desktop
--
local path = ssk.files.desktop.getDesktopRoot() 
print(path)

--
-- 2. Make a folder on the destkop
--
local path = ssk.files.desktop.getDesktopPath("SSK2FilesTest") 
ssk.files.util.mkFolder( path )

--
-- 3. Copy a file to the folder
--
local src = ssk.files.resource.getPath( "rg256.png" )
local dst = ssk.files.desktop.getDesktopPath("SSK2FilesTest/rg256.png") 
print(src,dst)
ssk.files.util.cpFile( src, dst )

--
-- 4. Explore the folder
--
ssk.files.desktop.explore(path)
