-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
-- =============================================================
-- Behavior - Instance Template
-- =============================================================
-- Short and Sweet License: 
-- 1. You may use anything you find in the SSKCorona library and sampler to make apps and games for free or $$.
-- 2. You may not sell or distribute SSKCorona or the sampler as your own work.
-- 3. If you intend to use the art or external code assets, you must read and follow the licenses found in the
--    various associated readMe.txt files near those assets.
--
-- Credit?:  Mentioning SSKCorona and/or Roaming Gamer, LLC. in your credits is not required, but it would be nice.  Thanks!
--
-- =============================================================
--
-- =============================================================

--local debugLevel = 1 -- Comment out to get global debugLevel from main.cs
local dp = ssk.debugPrinter.newPrinter( debugLevel )
local dprint = dp.print

public = {}
public._behaviorName = "behaviorTemplate_Instance"

function public:onAttach( obj, params )
	dprint(0,"Attached Behavior: " .. self._behaviorName)

	behaviorInstance = {}
	behaviorInstance._behaviorName = self._behaviorName
	behaviorInstance.owner = obj

	if( not params ) then 
		behaviorInstance.params = {}
	else
		behaviorInstance.params = table.shallowCopy(params)
	end
	
	-- =========  ADD YOUR ATTACH CODE HERE =======
	-- =========  ADD YOUR ATTACH CODE HERE =======

	
	-- =========  ADD YOUR ATTACH CODE HERE =======
	-- =========  ADD YOUR ATTACH CODE HERE =======

	function behaviorInstance:onDetach( obj )
		dprint(0,"Detached Behavior: " .. self._behaviorName)
		-- =========  ADD YOUR DETACH CODE HERE =======
		-- =========  ADD YOUR DETACH CODE HERE =======


		-- =========  ADD YOUR DETACH CODE HERE =======
		-- =========  ADD YOUR DETACH CODE HERE =======
	end

	return behaviorInstance
end

ssk.behaviors:registerBehavior( "behaviorTemplate_Instance", public )
return public
