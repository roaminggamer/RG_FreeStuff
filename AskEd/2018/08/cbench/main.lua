-- =============================================================
-- main.lua
-- =============================================================
-- SSK vs. Pure Comparisons
-- =============================================================

io.output():setvbuf("no") -- Don't use buffer for console messages
display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar
if( system.getInfo( "environment" ) == "simulator" ) then
	local function myUnhandledErrorListener( event )
		return true
	end
	Runtime:addEventListener("unhandledError", myUnhandledErrorListener)
end

require "ssk2.loadSSK"
_G.ssk.init( ) 
local json = require "json"
local harness = require "benchHarness"


local tests = {}

-- OPS TESTS 

tests[#tests+1] = "ops.math_misc_emptyloop"

local allTests = true

if( allTests ) then

	-- http://forums.coronalabs.com/topic/15165-tips-optimization-101/
	tests[#tests+1] = "ops.optimization_localization_a"
	tests[#tests+1] = "ops.optimization_localization_b"

	tests[#tests+1] = "ops.optimization_heavystringcompare_a"
	tests[#tests+1] = "ops.optimization_heavystringcompare_b"

	tests[#tests+1] = "ops.optimization_forloops_a"
	tests[#tests+1] = "ops.optimization_forloops_b"
	tests[#tests+1] = "ops.optimization_forloops_c"

	tests[#tests+1] = "ops.creation_displayGroup"
	tests[#tests+1] = "ops.creation_displayCircle"
	tests[#tests+1] = "ops.creation_displayColoredCircle"
	tests[#tests+1] = "ops.destruction_displayGroup"

	tests[#tests+1] = "ops.math_misc_multiplyloopnum"
	tests[#tests+1] = "ops.math_misc_multiplysamesmallnum"
	tests[#tests+1] = "ops.math_misc_multiplysamelargenum"
	--tests[#tests+1] = "ops.math_sqrt"
	--tests[#tests+1] = "ops.math_sqrt_file_local"
	--tests[#tests+1] = "ops.math_sqrt_function_local"

	--tests[#tests+1] = "ops.ssk_vector_squarelength_obj_global"
	--tests[#tests+1] = "ops.ssk_vector_squarelength_num"
	--tests[#tests+1] = "ops.ssk_vector_squarelength_obj"
	tests[#tests+1] = "ops.math_vector_squarelength"
	tests[#tests+1] = "ops.math_vector_length"
	--tests[#tests+1] = "ops.ssk_vector_length_obj"


	-- MEM TESTS
	tests[#tests+1] = "mem.creation_displayGroup"
	tests[#tests+1] = "mem.creation_displayCircle"
	tests[#tests+1] = "mem.creation_displayColoredCircle"
	tests[#tests+1] = "mem.creation_displayRect"

	tests[#tests+1] = "mem.creation_HugeTable"
	tests[#tests+1] = "ops.creation_HugeTable"

	-- FPS TESTS
	tests[#tests+1] = "fps.onscreen_circles_100"
	tests[#tests+1] = "fps.onscreen_circles_200"
	tests[#tests+1] = "fps.onscreen_circles_300"
	tests[#tests+1] = "fps.onscreen_circles_400"
	tests[#tests+1] = "fps.onscreen_circles_500"

	--tests[#tests+1] = "mem._mem_template"
end

-- Run tests in triplicate
local tests3 = {}
for i = 1, #tests do
	tests3[#tests3+1] = tests[i]
	tests3[#tests3+1] = tests[i]
	tests3[#tests3+1] = tests[i]
end


local build = system.getInfo("build")
local ifcGroup = display.newGroup()

local function onStart( event )
	display.remove(ifcGroup)
	ifcGroup = nil
	label1 = nil
	label2 = nil
	label3 = nil
	runButton = nil
	nextFrame( function() harness.run( tests3 ) end, 500 )
end


local label1 = ssk.easyIFC:quickLabel(ifcGroup, "CBench v0.1 (Build Date: 180805)", centerX, 40, nil, 18 )
local label2 = ssk.easyIFC:quickLabel(ifcGroup, "Corona SDK (TM) Build: " .. build , centerX, 65, nil, 16 )
label2.x = label1.x + - label1.width/2 + label2.width/2


local date = os.date( "*t" )    -- returns table of date & time values
local dateNum = tonumber( date.year .. 
						  string.format( "%02.2d", date.month) ..
						  string.format( "%02.2d",  date.day) )

local runButton = ssk.easyIFC:presetPush( ifcGroup, "default", centerX, centerY, 140, 40, "Start", onStart, { textColor = _GREEN_, fontSize = 22, strokeColor = _GREEN_, strokeWidth = 2 } )

--onStart()