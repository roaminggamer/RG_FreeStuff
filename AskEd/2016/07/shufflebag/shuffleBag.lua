-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015 
-- =============================================================
-- This content produced for Corona Geek Hangouts audience.
-- You may use any and all contents in this example to make a game or app.
-- =============================================================

local shuffleBag = {}

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
--	insert - Table randomizer
----------------------------------------------------------------------
local function insert( self, obj )
   self.unused[#self.unused+1] = obj
end

----------------------------------------------------------------------
--	shuffle - Function to shuffle table and prep 'unused' table.
----------------------------------------------------------------------
local function shuffle( self )
   for i = 1, #self.unused do
      self.used[#self.used+1] = self.unused[i]
   end
   self.unused = shuffleTable( self.used, 100 )
   self.used = {}   
end

----------------------------------------------------------------------
--	get - Function to get one random entry from bag.
----------------------------------------------------------------------
local function get( self )
   if( #self.used == 0 and #self.unused == 0) then return nil end
   
   if( #self.unused == 0 ) then
      self:shuffle()
   end
   
   self.used[#self.used+1] = self.unused[#self.unused]
   
   self.unused[#self.unused] = nil
   
   return self.used[#self.used]
end


----------------------------------------------------------------------
--	new - Return new shuffle bag instance.
----------------------------------------------------------------------
function shuffleBag.new( ... )
   local bag   = {}
   
   bag.used    = {}
   bag.unused  = {}
   
   bag.insert  = insert
   bag.shuffle = shuffle
   bag.get     = get
   
   for i = 1, #arg do
      bag:insert( arg[i] )
   end   
   return bag
end


return shuffleBag