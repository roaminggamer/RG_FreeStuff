io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
-- =====================================================

local function test2()
	print("\n\nGets and error...")
	doit()
end

local function doit()
	print("YO I'm visible to test1(), but not test2()")
end

local function test1()
	print("\n\nWorks fine...")
	doit()
end

test1()

test2()