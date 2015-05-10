local example = {}

-- Require modules we'll use here
--
local com 			= require "common"
local wordList		= require "wordList"
local searchField	= require "searchField"


-- Local variables and flags we'll use to make decisions as the module runs.
--
local searching 	-- Currently searching for matches?
local lastTerm 		-- Last search term used
local curIndex 		-- Current search index
local foundCount 	-- How many words matched the criteria.
local foundGroup	-- Display group to hold search results in.
local searchTime	-- Maximum time we can search per frame


-- ******************************************************************
-- start() -- Define a 'enterFrame' listener and start listening.
--
-- Note: This listener does all the work
--
-- ******************************************************************
function example.start(  )	

	-- onEnterFrame() -- Runs every frame once we start listening.
	--
	-- 1. Get the current search term from our input field and 
	--   check to see if it has changed.
	--    a. If so, reset the search results
	--
	-- 2. If we are not searching, abort early.
	--
	-- 3. Compare words versus the search criteria till done or till searchTime elapses.
	--    a. Each time a result is found, display it.
	--
	-- 4. Update search index meter.
	-- 
	-- 5. Check to see if we're done searching.
	-- 
	local function onEnterFrame( event )

		-- 1. 
		--
		local searchTerm = searchField.getSearchTerm()
		if( lastTerm ~= searchTerm ) then 
			-- 1a.
			--
			example.resetResults()
			lastTerm = searchTerm
			searching = ( string.len( searchTerm ) > 0 )
		end

		-- 2. 
		--
		if( not searching ) then return end

		-- 3. 
		--
		local getTimer 		= system.getTimer -- localize for speedup
		local strLower 		= string.lower -- localize for speedup
		local startTime		= getTimer()
		local elapsedTime	= 0
		while( elapsedTime < searchTime and curIndex <= #wordList ) do
			local curWord = wordList[curIndex]			

			-- 3a. 
			--
			if( string.match( strLower(curWord), strLower( searchTerm ) ) ~= nil ) then
				example.drawResult( curWord )
			end

			elapsedTime = getTimer() - startTime
			curIndex = curIndex + 1
		end

		-- 4.
		-- 
		searchField.setSearchIndex( curIndex )

		-- 5. 
		--
		searching = curIndex < #wordList

	end
	Runtime:addEventListener( "enterFrame", onEnterFrame )
end


-- ******************************************************************
-- init( maxTime ) - Used to initialize our module settings.
--
-- 1. Create and position initial results display group.
--
-- 2. Initialize flags and variables to starting values.
--
-- 3. Set how many comparisons we're allowed to do per frame.
--
-- ******************************************************************
function example.init( maxTime )
	-- 1.
	--
	foundGroup 		= display.newGroup()
	foundGroup.y 	= com.top + 60 

	-- 2.
	--
	searching 		= false -- Not currently searching
	lastTerm 		= ""    -- No search term yet.
	curIndex 		= 1		-- On first word in word list.
	foundCount 		= 0		-- No words found yet.
	
	-- 3.
	--
	searchTime 		= maxTime or (1000/display.fps/2) -- Default to half of a frame
end


-- ******************************************************************
-- resetResult() - Clears our old search results and prepare for new search.
--
-- 1. Reset search flags and variables
--
-- 2. Reset results meters (found count and index)
--
-- 3. Destroy the old results group and create a new one.
--
-- ******************************************************************
function example.resetResults( )
	-- 1.
	--
	curIndex 	= 1
	curY 		= 10
	foundCount 	= 0

	-- 2.
	--
	searchField.setFoundCount( foundCount )
	searchField.setSearchIndex( curIndex )
	
	-- 3.
	--
	display.remove( foundGroup )
	foundGroup = display.newGroup()
	foundGroup.y = com.top + 60
	foundGroup.curY = 10
end

-- ******************************************************************
-- drawResults( foundWord )
--
-- 1. Draw new text object showing 'foundWord'.
--
-- 2. Increment found counter and update meter.
-- 
-- ******************************************************************
function example.drawResult( foundWord )
	-- 1.
	--
	local tmp = display.newText( foundGroup, foundWord, 10, foundGroup.curY, native.systemFont, 10 )
	tmp.anchorX = 0
	foundGroup.curY = foundGroup.curY + 12

	-- 2.
	--
	foundCount = foundCount + 1
	searchField.setFoundCount( foundCount )
end


return example