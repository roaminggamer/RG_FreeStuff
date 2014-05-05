local testNum = 6 -- 1 .. 4

local function someWork( self, event )
    print(self.name)
    for k,v in pairs(event) do
        print(k,v)
    end
end

local function onFinalize( self, event )
    self:someWork( event )
end


local myGroup = display.newGroup()
local myCircle = display.newCircle( myGroup, 240, 160, 30 )

myGroup.name = "myGroup"
myGroup.finalize = onFinalize
myGroup.someWork = someWork
myGroup:addEventListener( "finalize" )

myCircle.name = "myCircle"
myCircle.finalize = onFinalize
myCircle.someWork = someWork
myCircle:addEventListener( "finalize" )

print("\nTest:" .. testNum .. "\n")
if( testNum == 1 ) then -- PASS
    myCircle:removeSelf()

elseif( testNum == 2 ) then -- PASS
    display.remove( myCircle )

elseif( testNum == 3 ) then -- FAIL (only calls finalize for 'myGroup')
    myGroup:removeSelf()

elseif( testNum == 4 ) then -- FAIL (only calls finalize for 'myGroup')
    display.remove( myGroup )

elseif( testNum == 5 ) then -- PASS 
    -- Override display.remove
    display.__remove = display.remove
    display.remove = function ( obj ) 
        if( obj.numChildren == nil ) then
            display.__remove( obj )
        else
            local child
            for i = 1, obj.numChildren do
                child = obj[i]
                display.remove( child )
            end
            display.__remove( obj )
        end
    end

    display.remove( myGroup )

elseif( testNum == 6 ) then -- PASS 
    -- Override display.remove
    display.__remove = display.remove
    display.remove = function ( obj ) 
        if( obj.numChildren == nil ) then
            display.__remove( obj )
        else
            local child
            for i = 1, obj.numChildren do
                child = obj[i]
                display.remove( child )
            end
            display.__remove( obj )
        end
    end

    local myGroup2 = display.newGroup()
    myGroup2:insert(myGroup)
    myGroup2.name = "myGroup2"
    myGroup2.finalize = onFinalize
    myGroup2.someWork = someWork
    myGroup2:addEventListener( "finalize" )
    display.remove( myGroup2 )
end