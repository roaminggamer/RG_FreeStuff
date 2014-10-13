-- From here: https://github.com/bjorn/lua-oop
--
-- Object is the base class of anything that follows this OOP mechanism.
-- Usage example:
--
--
-- CREATING A DERIVED CLASS
--
--      local Human = Object {
--          name = "Anonymous",
--          weight = 0,
--      }
--
--      function Human:say(text)
--          print(self.name .. " says: " .. text)
--      end
--
--
-- INSTANTIATING AN OBJECT
--
--      local jim = Human:new {
--          name = "Jim Jimmalot"
--          weight = "85"
--      }
--
--      jim:say("Hi!")
--
--
-- OR WITHOUT PROVIDING THE INSTANCE TABLE
--
--      jim = Human:new()
--      jim.name = "Jim Jimmalot"
--      jim.weight = 85
--

--
-- It turns 'subclass' into a subclass of 'class', and prepares it to be
-- used as metatable for instances of 'subclass'.
--
local function derive(class, subclass)
    -- The class is reused as the metatable for subclasses and instances
    subclass.__index = subclass
    subclass.__call = derive
    
    return setmetatable(subclass, class)
end

--
-- Bootstrap the first class into the hierarchy
--
local Object = derive({
    -- Report an error when trying to access a member that doesn't exist
    __index = function(table, key)
        --error("No such member: " .. tostring(key))
    end,
    __call = derive
}, {})

--
-- Initializes the object right after it has been instantiated. Basically the
-- constructor.
--
function Object:init()
end

--
-- Instantiates an object. Either wraps the given instance table or will
-- create one if not provided.
--
function Object:new(instance)
    assert(rawget(self, "__call"), "Trying to instantiate an instance")

    instance = setmetatable(instance or {}, self)
    instance:init()
    return instance
end

--
-- Returns this object when it is an instance of the given class, and nil
-- otherwise.
--
function Object:as(class)
    local meta = getmetatable(self)
    while meta do
        if meta == class then
            return self
        end
        meta = getmetatable(meta)
    end
    return nil
end

--
-- Convenience function to log a message from an instance.
--
function Object:log(...)
    print(tostring(self) .. ":", ...)
end

return Object
