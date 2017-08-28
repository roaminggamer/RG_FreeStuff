-- =============================================================
require "ssk2.loadSSK"
_G.ssk.init()
-- =============================================================

local files = ssk.files


local src = ssk.files.desktop.getDrivePath( "C:\\Users\\Asani\\Music" ) -- FIXED ERROR HERE

local dst = files.documents.getPath( "music" ) -- FIXED ERROR HERE

files.util.cpFolder( src, dst )


print(src)
print(dst)
