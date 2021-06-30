--
-- proxy.lua
-- Adds "propertyUpdate" events to any Corona display object.
--

local m = {}

function m.get_proxy_for( obj )
  local t = {}
  t.raw = obj

  local mt =
  {
    __index = function(tb,k)
      if k == "raw" then
        return rawget( t, "raw" )
      end

      -- pass method and property requests to the display object
      if type(obj[k]) == 'function' then
        return function(...) arg[1] = obj; obj[k](unpack(arg)) end
      else
        return obj[k]
      end
    end,

    __newindex = function(tb,k,v)
      -- dispatch event before property update
      local event =
      {
        name = "propertyUpdate",
        target=tb,
        key=k,
        value=v
      }
      obj:dispatchEvent( event )

      -- update the property on the display object
      obj[k] = v
    end
  }
  setmetatable( t, mt )

  return t
end

return m