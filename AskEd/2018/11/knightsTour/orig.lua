-- kt-02-3.lua
-- ******************************************************************
-- works fine in: basic256, x11basic, algoid, euphoria, tcl, ring ... 
-- version whitout grafik /  With Warnsdorff's rule (extended)
-- ******************************************************************
--// possible moves
pm = {{-2,1},{-1,2},{1,2},{2,1},{-2,-1},{-1,-2},{1,-2},{2,-1}}
 
n    = 8 --//number rows/collons
cbx = n   --// rows
cby = n   --// colls
 
--// startfeld  ( 2/2 = kritisch!) 
kx  = 2 --
ky  = 2 --
 
--// startfeld  -  randomizer (for testing)
math.randomseed (os.time ())    -- random turn on
kx =math.random(1, 8)
ky =math.random(1, 8)
 
print("Startfeld kx/ky: "..kx .."/"..ky)
 
--// make chessboard n*n
--cb = list(cby) for x in cb  x = list(cbx)  next  ??
cb = {}      -- cb definition filled with nulls
for i = 1, n do
    cb[i] = {}
    for j = 1, n do
        cb[i][j] = 0
    end
end
 
function printCB()        -- cb printing
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
 
--#-- between inclusive
--if nx >= 1 and nx <= N and ny >= 1 and ny <= N then  -- cb grenzen
function between(x, min, max)
    return (x>=min) and (x<=max)
end 
 
k = 0 --// jmps-counter 
 while(k < 65) do
  cb[kx][ky] = k+1        -- counter set
  pq = {}                 -- priority queue (clear)
  
for i = 1, n do
nx = kx + pm[i][1]; ny = ky + pm[i][2]  
if between(nx, 1, cbx) and between(ny, 1, cby) then
      if cb[nx][ny] == 0 then ctr = 1   -- zaehler reset
for j = 1, n do   
ex = nx + pm[j][1]; ey = ny + pm[j][2]
if between(ex, 1, cbx) and between(ey, 1, cby) then 
if cb[ey][ex] == 0 then ctr=ctr+1 end
end
end --for j
          table.insert(pq, (ctr*100)+i)     
end -- if cb[nx][ny] 
end  -- if between..
end -- for i  
 
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
    end  --dd
 
m = minD 
kx = kx + pm[m][1]
ky = ky + pm[m][2]
else 
if k < 63 then
print("Error in Field-No.: "..k)
      break
else
print(" >>>------------------->  Success!")
      break
end
end
k = k+1
end  -- while
-- ******************  end main pgm   ********************
printCB() 
