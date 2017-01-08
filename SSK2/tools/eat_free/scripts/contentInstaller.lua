-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- Eds Awesome Tool (a free SSK2 PRO co-product)
-- =============================================================
-- See README.md for full license details.
-- =============================================================
--   Last Updated: 06 JAN 2017
-- =============================================================

----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------
local zip 			= require( "plugin.zip" ) 
local RGFiles 		= ssk.files



local contentInstaller = {}

-- =============================================================
-- check() - Make sure content has not been removed.
-- =============================================================
function contentInstaller.check(   )
	local sourceFolder = RGFiles.documents.getPath("sources")
	if( not RGFiles.util.isFolder( sourceFolder ) ) then
		return false
	end
	return true
end	

-- =============================================================
-- run() - Install Content
-- =============================================================
function contentInstaller.run( onComplete  )
	print("Executing Content Installer")
	local message = ssk.easyIFC:quickLabel( nil, "Preparing Tool...", centerX, bottom - 100, gameFont, 45 )
	transition.blink( message, { time = 1500 } )

    local function zipListener( event )
        if( event.isError ) then
            onComplete( false )
            display.remove( message )
        else
        	onComplete( true )
        	display.remove( message )
        end
    end


    local zipOptions =
    {
        zipFile     = "sources.zip",
        zipBaseDir  = system.ResourceDirectory,
        dstBaseDir  = system.DocumentsDirectory,
        listener    = zipListener
    }

    nextFrame( function() zip.uncompress( zipOptions ) end, 1000 )

end

return contentInstaller
