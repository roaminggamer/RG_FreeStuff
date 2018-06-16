
local util = require "util"
local Runtime_addEventListener = _G.Runtime.addEventListener
function _G.Runtime.addEventListener( ... )
  local name    = arg[1] or ""
  local listener = arg[2]
  if( not listener ) then
    util.trace("Runtime:addEventListener( " .. tostring(name) .. " ) - Missing listener.", 2)
    return
  end
  --
  return Runtime_addEventListener( name, listener )
end
