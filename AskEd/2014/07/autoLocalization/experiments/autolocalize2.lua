local mMin,mMax,mSqrt = math.min,math.max,math.sqrt

local usage
local locals = {}
local i = 1
repeat
    local k, v = debug.getlocal(1, i)
    print(k,v)
    if( k ~= "i" and 
        k ~= "locals" and 
        k ~= "usage") then

        if(k~=nil) then locals[k]=v end

        if(usage == nil and k ~= nil) then 
            usage = "local " .. k 
        elseif(k ~= nil) then
            usage = usage .. "," .. k
        end        
    end
    i=i+1

until nil == k
print(usage .. ';require("autolocalize2").go()') 

local function run()
    local i = 1
    repeat
        local k, v = debug.getlocal(2, i)
        if k then
            if v == nil then
                if not locals[k] then
                    print('No value for a local variable: ' .. k)
                else
                    debug.setlocal(2, i, locals[k])
                end
            end
            i = i + 1
        end
    until nil == k
end
local public = {}
public.run = run


local function go()
    local locals = {mMin=mMin,mMax=mMax,mSqrt=mSqrt}
    local i = 1
    repeat
        local k, v = debug.getlocal(2, i)
        if k then
            if v == nil then
                if not locals[k] then
                    print('No value for a local variable: ' .. k)
                else
                    debug.setlocal(2, i, locals[k])
                end
            end
            i = i + 1
        end
    until nil == k
end
local public = {}
public.go = go
return public