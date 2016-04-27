-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- =============================================================
--                              License
-- =============================================================
--[[
    > SSK is free to use.
    > SSK is free to edit.
    > SSK is free to use in a free or commercial game.
    > SSK is free to use in a free or commercial non-game app.
    > SSK is free to use without crediting the author (credits are still appreciated).
    > SSK is free to use without crediting the project (credits are still appreciated).
    > SSK is NOT free to sell for anything.
    > SSK is NOT free to credit yourself with.
]]
-- =============================================================
-- From here: https://gist.github.com/Lerg/8791421
local function fixFinalize()
    --print("Fixing finalize() bug...")
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
end

local finalizeFixed = false
local testGroup = display.newGroup()
testGroup.isVisible = false
local testObject = display.newRect(testGroup, 0, 0, 1, 1)
function testObject.finalize(self, event)
    finalizeFixed = true
    print("No longer any need to fix finalize()")
end
testObject:addEventListener("finalize")
display.remove(testGroup)
if not finalizeFixed then fixFinalize() end
testGroup, testObject = nil, nil
