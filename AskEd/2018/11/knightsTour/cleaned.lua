math.randomseed (os.time ())    -- random turn on

local cleaned = {}

function cleaned.run( params )
   params = params or {}

   local pm = {{-2,1},{-1,2},{1,2},{2,1},{-2,-1},{-1,-2},{1,-2},{2,-1}}
   local n    = 8 --//number rows/collons
   local cbx = n   --// rows
   local cby = n   --// colls
    
   --// start square  ( 2/2 = kritisch!) 
   local kx  = params.kx or 2
   local ky  = params.ky or 2
    
   --// start square  -  randomizer (for testing)
   if( params.randomzie ) then
      kx = math.random(1, 8)
      ky = math.random(1, 8)
   end
    
   print("start square kx/ky: "..kx .."/"..ky)    
   --// make chess board n x n
   local cb = {}
   for i = 1, n do
      cb[i] = {}
      for j = 1, n do
         cb[i][j] = 0
      end
   end
    
   function printCB()
      for y = 1, n do
         io.write("|")
         for x = 1, n do
            if cb[y][x] <10 then
               io.write(" "..cb[y][x].."|" )
            else
               io.write( cb[y][x].."|" )
            end
         end
         print("")
      end 
      return
   end  

   function between(x, min, max)
      return (x>=min) and (x<=max)
   end 

   local k = 0
   while(k < 65) do
      cb[kx][ky] = k+1
      pq = {}

      for i = 1, n do
         nx = kx + pm[i][1]; ny = ky + pm[i][2]  
         if between(nx, 1, cbx) and between(ny, 1, cby) then
            if cb[nx][ny] == 0 then 
               ctr = 1
               for j = 1, n do   
                  ex = nx + pm[j][1]; ey = ny + pm[j][2]
                  if between(ex, 1, cbx) and between(ey, 1, cby) then 
                     if cb[ey][ex] == 0 then 
                        ctr=ctr+1 
                     end
                  end
               end
               table.insert(pq, (ctr*100)+i)     
            end
         end
      end

      -- Warnsdorff’s algorithmus;   extended
      -- move to the neighbor that has min number of available neighbors
      -- randomization:  we could take it - or not
      if #pq > 0 then
         table.sort (pq)      -- OK (min first)
         minVal = 8     -- max loop nr   
         minD   = 0       -- min value     
         math.randomseed (1,10)  -- random: 1-10
         math.random(); math.random(); math.random(); --warming up
         for dd = 1, #pq do 
            x = table.remove(pq,1)         -- kopf-element loeschen     
            p = math.floor(x / 100)        -- p wert extrahieren
            m = x % 10      -- m (row) wert extrahieren  
            if p == minVal and math.random() <5 then 
               minVal = p
               minD   = m
            end
            if p < minVal then
               minVal = p
               minD   = m
            end 
         end

         m = minD 
         kx = kx + pm[m][1]
         ky = ky + pm[m][2]
      elseif k < 63 then
         print("Error in Field-No.: "..k)
         break
      else
         print(" >>>------------------->  Success!")
         break
      end

      k = k+1

   end  -- while

   if( not params.quiet ) then
      print(CB)
   end
   -- ******************  end main pgm   ********************
end

return cleaned

