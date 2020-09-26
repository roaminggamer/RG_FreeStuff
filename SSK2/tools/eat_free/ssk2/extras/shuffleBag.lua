-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
-- Shuffle Bag 
--
-- Concept ==> https://gamedevelopment.tutsplus.com/tutorials/shuffle-bags-making-random-feel-more-random--gamedev-1249
-- =============================================================

local shuffleBag = {}

_G.ssk = _G.ssk or {}
_G.ssk.shuffleBag = shuffleBag


----------------------------------------------------------------------
--	shuffleTable - Table randomizer
----------------------------------------------------------------------
local function shuffleTable( t, iter )
	local iter = iter or 1
	local n

	for i = 1, iter do
		n = #t 
		while n >= 2 do
			-- n is now the last pertinent index
			local k = math.random(n) -- 1 <= k <= n
			-- Quick swap
			t[n], t[k] = t[k], t[n]
			n = n - 1
		end
	end
 
	return t
end

----------------------------------------------------------------------
--	insert - Add object to shuffle bag.
----------------------------------------------------------------------
local function insert( self, obj )
   self.unused[#self.unused+1] = obj
end

----------------------------------------------------------------------
-- shuffle - Function to shuffle table and prep 'unused' table.
--
-- Warning!: Does not shuffle 'out' cards.  They must be 'putBack' first.
----------------------------------------------------------------------
local function shuffle( self )
   for i = 1, #self.unused do
      self.used[#self.used+1] = self.unused[i]
   end
   self.unused = shuffleTable( self.used, 100 )
   self.used = {}   
end

----------------------------------------------------------------------
--	getCounts - Return count of unused, used, and out entries
----------------------------------------------------------------------
local function getCounts( self )
   return #self.unused, #self.used, table.count(self.out)
end

----------------------------------------------------------------------
--	get( autoShuffle ) - Function to get one random entry from bag.
--
--  autoShuffle - If true, and out of entries, automatically shuffle.
--                Defaults to true
----------------------------------------------------------------------
local function get( self )
   autoShuffle = (autoShuffle ~= false)
   if( #self.unused == 0 ) then      
      if( autoShuffle ) then
         self:shuffle()  
      else         
         return nil
      end
   end
      
   self.used[#self.used+1] = self.unused[#self.unused]
   
   self.unused[#self.unused] = nil
   
   return self.used[#self.used]
end

----------------------------------------------------------------------
-- take( autoShuffle ) - Similar to get, but removed entry is moved to 'out' bag
--        to prevent re-use on a shuffle.
--
--  autoShuffle - If true, and out of entries, automatically shuffle.
--                Defaults to true
----------------------------------------------------------------------
local function take( self, autoShuffle )
   autoShuffle = (autoShuffle ~= false)
   if( #self.unused == 0 ) then      
      if( autoShuffle ) then
         self:shuffle()  
      else         
         return nil
      end
   end

   local entry = self.unused[#self.unused]
   
   self.out[entry] = entry
   
   self.unused[#self.unused] = nil
   
   return entry
end

----------------------------------------------------------------------
-- putBack( entry ) - Used to move an 'out' entry to the 'used' bag.
--
--   entry - An 'returned' entry previously taken.  If 'nil', return
--           all 'out' entries at once.
--
-- 
----------------------------------------------------------------------
local function putBack( self, entry )
   -- If no entry is given, assume we are returning all entries
   --
   if( not entry ) then
      for k,v in pairs(self.out) do
         self.used[#self.used+1] = v
      end
      self.out = {}
      return true
   end

   -- Make sure this is a valid entry first
   if( not self.out[entry] ) then return false end

   -- Return the entry
   self.out[entry] = nil   
   self.used[#self.used+1] = entry

   return true
end

----------------------------------------------------------------------
-- save current state of bag.
----------------------------------------------------------------------
function save( self, fileName, base  )
   base = ( base == nil ) and system.DocumentsDirectory or base
   local toSave = { out = self.out, used = self.used, unused = self.unused }
   table.save( toSave, fileName, base )
end


----------------------------------------------------------------------
-- Restore state of bag from saved bag
----------------------------------------------------------------------
function restore( self, fileName, base  )
   base = ( base == nil ) and system.DocumentsDirectory or base

   local restored = table.load( fileName, base )
   if ( restored ) then
      self.out      = restored.out
      self.used     = restored.used
      self.unused   = restored.unused
   else
      print( "Warning! shuffleBag.restore() - Failed to restore: " .. tostring( fileName ) )
   end
end

----------------------------------------------------------------------
--	new - Return new shuffle bag instance.
----------------------------------------------------------------------
function shuffleBag.new( ... )
   local bag      = {}
   
   bag.out        = {}      
   bag.used       = {}
   bag.unused     = {}
   
   bag.insert     = insert
   bag.shuffle    = shuffle
   bag.get        = get
   bag.getCounts  = getCounts
   bag.take       = take
   bag.putBack    = putBack

   bag.save       = save
   bag.restore    = restore
   
   for i = 1, #arg do
      bag:insert( arg[i] )
   end   
   return bag
end




return shuffleBag