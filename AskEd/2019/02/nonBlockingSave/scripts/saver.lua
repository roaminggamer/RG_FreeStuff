local saver = {}

function saver.blocking( tbl, dst, onComplete, base )
	base = base or system.DocumentsDirectory	
   for i = 1, #tbl do
     if( i == 1 ) then
        io.writeFile( tbl[i] .. "\n", dst, base )
     else
        io.appendFile( tbl[i] .. "\n", dst, base )
     end
   end

   if ( onComplete ) then onComplete() end 
end

function saver.nonBlocking( tbl, dst, onComplete, base )
	base = base or system.DocumentsDirectory
   local index = 1

   local getTimer = system.getTimer -- localize for call speedup
   local maxTime = 10 -- Time we can be active per frame saving in ms

   local function helper()
   	local started = system.getTimer()
   	local dt = getTimer() - started

   	while( index <= #tbl and dt < maxTime ) do
        if( index == 1 ) then
           io.writeFile( tbl[index] .. "\n", dst, base or system.DocumentsDirectory )
        else
           io.appendFile( tbl[index] .. "\n", dst, base or system.DocumentsDirectory )
        end
	      index = index + 1
	      dt = getTimer() - started
      end

      if( index >= #tbl ) then
        	if ( onComplete ) then onComplete() end 
         return
      end
      timer.performWithDelay( 1, helper )
   end
   helper()
end

return saver