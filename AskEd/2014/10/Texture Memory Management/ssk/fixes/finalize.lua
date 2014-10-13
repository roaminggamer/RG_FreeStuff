-- From here: https://gist.github.com/Lerg/8791421
--[[
-- Fix problem that finalize event is not called for children objects when group is removed
local function finalize(event)
    local g = event.target
    for i = 1, g.numChildren do
        if g[i]._tableListeners and g[i]._tableListeners.finalize then
            for j = 1, #g[i]._tableListeners.finalize do
                g[i]._tableListeners.finalize[j]:dispatchEvent{name = 'finalize', target = g[i]}
            end
        end
        if g[i]._functionListeners and g[i]._functionListeners.finalize then
            for j = 1, #g[i]._functionListeners.finalize do
                g[i]._functionListeners.finalize[j]({name = 'finalize', target = g[i]})
            end
        end
        if g[i].numChildren then
            finalize{target = g[i]}
        end
    end
end
local newGroup = display.newGroup
function display.newGroup()
    local g = newGroup()
    g:addEventListener('finalize', finalize)
    return g
end
--]]

----[[
-- Fix problem that finalize event is not called for children objects when group is removed
local function finalize(g)
    for i = 1, g.numChildren do
        if g[i]._tableListeners and g[i]._tableListeners.finalize then
            for j = 1, #g[i]._tableListeners.finalize do
                g[i]._tableListeners.finalize[j]:dispatchEvent{name = 'finalize', target = g[i]}
            end
        end
        if g[i]._functionListeners and g[i]._functionListeners.finalize then
            for j = 1, #g[i]._functionListeners.finalize do
                g[i]._functionListeners.finalize[j]({name = 'finalize', target = g[i]})
            end
        end
        if g[i].insert then
            finalize(g[i])
        end
    end
end
local newGroup = display.newGroup
function display.newGroup()
    local g = newGroup()
    local removeSelf = g.removeSelf
    g.removeSelf = function()
            finalize(g)
            removeSelf(g)
        end
    return g
end
--]]