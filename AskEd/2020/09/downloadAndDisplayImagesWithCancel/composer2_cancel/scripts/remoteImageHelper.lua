
local remoteImageHelper = {}

-- set to true to see more of what is happening
local debugEn = false

function remoteImageHelper.downloadAndUseRemoteImage( downloadPath, saveAs, onSuccess, onFailure, baseDir, params )
	onSuccess = onSuccess or function() end 
	onFailure = onFailure or function() end 
	baseDir = baseDir or system.TemporaryDirectory 
	params = params or {}

	local function networkListener( event )

		if( debugEn ) then
			print( downloadPath, saveAs, onSuccess, onFailure, baseDir, params )
			for k,v in pairs(event) do
				print(k,v)
			end
		end

	    if ( event.isError ) then			
			onFailure( downloadPath, saveAs, baseDir, event  )
	    
	    elseif ( event.phase == "ended" ) then
	    	if( event.status and event.status ~= 200 ) then
	    		onFailure( downloadPath, saveAs, baseDir, event  )
	    	else
	    		onSuccess( downloadPath, saveAs, baseDir, event )
	    	end
	    end
	end

	-- https://docs.coronalabs.com/api/library/network/download.html
	network.download( downloadPath, "GET", networkListener, params, saveAs, baseDir )
end


return remoteImageHelper
