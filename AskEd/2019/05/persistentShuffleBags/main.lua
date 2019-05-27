io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
require "ssk2.loadSSK"
_G.ssk.init( { measure = false } )
-- =====================================================
--ssk.meters.create_fps(true)
--ssk.meters.create_mem(true)
--ssk.misc.enableScreenshotHelper("s") 
--ssk.easyIFC.generateButtonPresets( nil, true )
-- =====================================================

-- Create bag and fill it
local shuffleBag = ssk.shuffleBag
local bag = shuffleBag.new( 1, 2, 3, 4, 5 )


--
-- 1
--

-- Set random seed to enfore specific random order for example
math.randomseed( 10 )

-- Print result of get 4 times
print(bag:get()) -- 1 
print(bag:get()) -- 2
print(bag:get()) -- 3
print(bag:get()) -- 4

-- Dump internal structures of bag to verify this works
print("Pre-save")
table.dump(bag.unused)
table.dump(bag.used)
table.dump(bag.out)

-- Save the bag
bag:save( "testBag.json" )

-- Set random seed to enfore specific random order for example
math.randomseed( 10 )

-- Use bage some more to modify it
print("Post-save")
print(bag:get()) -- 1 
print(bag:get()) -- 2

-- Restore
bag:restore( "testBag.json" )

-- Dump internal structures of bag to verify this worked
print("Post-restore")
table.dump(bag.unused)
table.dump(bag.used)
table.dump(bag.out)


-- Set random seed to enfore specific random order for example
math.randomseed( 10 )

-- Print result of 2 get calls (should match post-save order)
print(bag:get()) -- 1 
print(bag:get()) -- 2
