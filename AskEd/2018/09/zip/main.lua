local zip = require( "plugin.zip" ) 

local function zipListener( event )
    for k,v in pairs( event ) do
        print(k,v)
    end

    if ( event.isError ) then
        print( "Error!" )
    else
        print ( "event.name: " .. event.name )
        print ( "event.type: " .. event.type )
        for k,v in pairs( event.response ) do
            print(k,v)
        end
    end
end

local function doCompress()
    local zipOptions = { 
        zipFile = "test.zip",
        zipBaseDir = system.DocumentsDirectory,
        srcBaseDir = system.ResourceDirectory,
        srcFiles = { "sonic.png", "pinky.png" },
        listener = zipListener
    }
    zip.compress( zipOptions )
end

local function doUncompress()
    local zipOptions = { 
        zipFile = "test.zip",
        zipBaseDir = system.DocumentsDirectory,
        dstBaseDir = system.TemporaryDirectory,
        listener = zipListener
    }
    zip.uncompress( zipOptions )
end

doCompress()
timer.performWithDelay( 1000, doUncompress )
