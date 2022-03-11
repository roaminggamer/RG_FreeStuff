local zip = require( "plugin.zip" )

-- Attempts to compress files in the "filenames" parameter to "test.zip".

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

        --example response
        --event.response = {
        --[1] = "space.jpg",
        --[2] = "space1.jpg",
        --}
    end
end

local zipOptions = { 
    zipFile = "test.zip",
    zipBaseDir = system.DocumentsDirectory,
    srcBaseDir = system.ResourceDirectory,
    srcFiles = { "sonic.png", "pinky.png" },
    listener = zipListener
}
zip.compress( zipOptions )