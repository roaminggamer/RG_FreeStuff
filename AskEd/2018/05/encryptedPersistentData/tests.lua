local tests = {}

local json = require "json"
local openssl = require( "plugin.openssl" )
local cipher = openssl.get_cipher ( "aes-256-cbc" )


-- testing encryption
function tests.one( myPassword )

	local orig = "Lorem ipsum ... yada yada"
	print( "BEFORE: ", orig )

	local out = cipher:encrypt( orig, myPassword )
	print( "ENCRYPTED:", out ) 

	local out2 = cipher:decrypt( out, myPassword )
	print( "DECRYPTED:", out2 ) 

end


-- testing table encoding, saving, restorging WITHOUT encryption.
function tests.two( )

	local myData = { name = "billy", age = 10, loves = "Corona and Games" }
	print( "DUMP OF ORIGINAL TABLE" )
	for k,v in pairs( myData ) do
		print(k,v)
	end

   local encoded = json.encode( myData )
	print( "JSON ENCODED: ", encoded )   

	-- Save and restore
	io.writeFile( encoded, "mydata.json" )

	local restored = io.readFile( "mydata.json")
	print( "RESTORED: ", restored )   

   local decoded = json.decode( restored )
	print( "JSON DECODED: ", decoded )   


	print( "DUMP OF SAVED & RESTORED & DECODED TABLE" )
	for k,v in pairs( decoded ) do
		print(k,v)
	end	

end


function tests.three( myPassword )

	local myData = { name = "billy", age = 10, loves = "Corona and Games" }
	print( "DUMP OF ORIGINAL TABLE" )
	for k,v in pairs( myData ) do
		print(k,v)
	end

   local encoded = json.encode( myData )
	print( "JSON ENCODED: ", encoded )   

	local out = cipher:encrypt( encoded, myPassword )
	print( "ENCRYPTED:", out ) 

	-- Save and restore
	io.writeFile( out, "mydata.json" )

	local restored = io.readFile( "mydata.json")
	print( "RESTORED: ", restored )   

	local out2 = cipher:decrypt( restored, myPassword )
	print( "DECRYPTED:", out2 ) 
	
   local decoded = json.decode( out2 )
	print( "JSON DECODED: ", decoded )   


	print( "DUMP OF SAVED & RESTORED & DECODED TABLE" )
	for k,v in pairs( decoded ) do
		print(k,v)
	end
	
end

return tests