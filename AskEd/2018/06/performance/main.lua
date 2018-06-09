io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
require "ssk2.loadSSK"
_G.ssk.init( { measure = false } )
ssk.meters.create_fps(true)
--ssk.meters.create_mem(true)
--ssk.misc.enableScreenshotHelper("s") 
-- =====================================================

local workloadCount = 30000

-- No payload
function hi()  end

function print1()
   for i = 1, workloadCount do
      hi()
   end
end 


-- Test 1
local function test1()
	for i = 1, workloadCount do
		Runtime:addEventListener("enterFrame", hi)
	end
end

local function test2( iter)
	Runtime:addEventListener("enterFrame", print1)
end

-- Test 2


-- 1. Run NO test and check FPS average

-- 2. Run ONLY test 1 and adjust workloadCount till FPS drops below average from step #1
test1()

-- 3. Run ONLY test 2 and compare FPS to step 2
--test2()