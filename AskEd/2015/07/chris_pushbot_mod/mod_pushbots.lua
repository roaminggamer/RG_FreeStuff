--[[
Pushbots.com module for Corona SDK v1.1
Copyright (c) 2014 develephant.net
]]--
local json = require("json")
local url = require("socket.url")

local Pushbots = 
{
  appId = nil,
  
  showStatus = false,
  showAlert = false,
  showJSON = false,
  
  endpoint = "https://api.pushbots.com/",

  --Event Dispatcher
  dispatcher = display.newGroup(),
  --Requests
  requestQueue = {},
  
  --Pushbots type constants
  NIL = nil,
  ERROR = "ERROR",

  --Pushbots API constants
  REGISTER = "deviceToken",
  UNREGISTER = "deviceToken/del",
  DEVICE = "deviceToken/one",
  ALIAS = "alias",
  TAG = "tag",
  UNTAG = "tag/del",
  LOCATION = "geo",
  BADGE = "badge",
  STATS = "stats",

  --Pushbot platform constants
  IOS = "0",
  ANDROID = "1",
  UNKNOWN = "-1",

  --action constants
  POST = "POST",
  GET = "GET",
  PUT = "PUT",
  --DELETE = "DELETE",

}

--------------------------------------------------------------------- 
-- Pushbots API REGISTRATION
---------------------------------------------------------------------

function Pushbots:registerDevice( deviceToken, objDataTable, _callback )
  --check for optional data
  if objDataTable ~= Pushbots.NIL then
    objDataTable.token = deviceToken
  else
    objDataTable = { token = deviceToken }
  end

  local uri = Pushbots:getEndpoint( Pushbots.REGISTER )
  return self:sendRequest( uri, objDataTable, Pushbots.REGISTER, Pushbots.PUT, _callback ) --returns requestId 
end

function Pushbots:unregisterDevice( deviceToken, _callback )
  local objDataTable = { token = deviceToken }
  local uri = Pushbots:getEndpoint( Pushbots.UNREGISTER )
  return self:sendRequest( uri, objDataTable, Pushbots.UNREGISTER, Pushbots.PUT, _callback ) --returns requestId 
end

--------------------------------------------------------------------- 
-- Pushbots API ALIAS
---------------------------------------------------------------------

function Pushbots:setAlias( deviceToken, deviceAlias, _callback )
  local objDataTable = { token = deviceToken, alias = deviceAlias }
  local uri = Pushbots:getEndpoint( Pushbots.ALIAS )
  return self:sendRequest( uri, objDataTable, Pushbots.ALIAS, Pushbots.PUT, _callback ) --returns requestId 
end

--------------------------------------------------------------------- 
-- Pushbots API TAGS
---------------------------------------------------------------------

function Pushbots:addTag( objDataTable, _callback )
  local uri = Pushbots:getEndpoint( Pushbots.TAG )
  return self:sendRequest( uri, objDataTable, Pushbots.TAG, Pushbots.PUT, _callback ) --returns requestId 
end

function Pushbots:removeTag( objDataTable, _callback )
  local uri = Pushbots:getEndpoint( Pushbots.UNTAG )
  return self:sendRequest( uri, objDataTable, Pushbots.UNTAG, Pushbots.PUT, _callback ) --returns requestId 
end

--------------------------------------------------------------------- 
-- Pushbots API LOCATION
---------------------------------------------------------------------

function Pushbots:setLocation( deviceToken, latitude, longitude, _callback )
  local objDataTable = { token = deviceToken, lat = latitude, lng = longitude }
  local uri = Pushbots:getEndpoint( Pushbots.LOCATION )
  return self:sendRequest( uri, objDataTable, Pushbots.LOCATION, Pushbots.PUT, _callback ) --returns requestId 
end

--------------------------------------------------------------------- 
-- Pushbots API DEVICE
---------------------------------------------------------------------

function Pushbots:getDevice( deviceToken, _callback )
  local objDataTable = { device = deviceToken } --trick for get call
  local uri = Pushbots:getEndpoint( Pushbots.DEVICE )
  return self:sendRequest( uri, objDataTable, Pushbots.DEVICE, Pushbots.GET, _callback ) --returns requestId 
end

--------------------------------------------------------------------- 
-- Pushbots API BADGE
---------------------------------------------------------------------

function Pushbots:setBadgeCount( deviceToken, badgeCount, _callback )
  local objDataTable = { token = deviceToken, setbadgecount = badgeCount }
  local uri = Pushbots:getEndpoint( Pushbots.BADGE )

  native.setProperty( "applicationIconBadgeNumber", badgeCount )

  return self:sendRequest( uri, objDataTable, Pushbots.BADGE, Pushbots.PUT, _callback ) --returns requestId
end

function Pushbots:clearBadgeCount( deviceToken, _callback )
  local objDataTable = { token = deviceToken, setbadgecount = 0 }
  local uri = Pushbots:getEndpoint( Pushbots.BADGE )

  native.setProperty( "applicationIconBadgeNumber", 0 )

  return self:sendRequest( uri, objDataTable, Pushbots.BADGE, Pushbots.PUT, _callback ) --returns requestId
end

--------------------------------------------------------------------- 
-- Pushbots API STATS
---------------------------------------------------------------------

function Pushbots:pushOpened( _callback )
  local uri = Pushbots:getEndpoint( Pushbots.STATS )
  return self:sendRequest( uri, {}, Pushbots.STATS, Pushbots.PUT, _callback ) --returns requestId 
end

---------------------------------------------------------------------
-- Pushbots Module Internals
---------------------------------------------------------------------

-- REQUESTS --
function Pushbots:newRequestParams( bodyData )
  --set up headers
  local headers = {}
  headers["x-pushbots-appid"] = self.appId
  headers["Content-Type"] = "application/json"

  --populate parameters for the network call
  local requestParams = {}

  if bodyData.device ~= Pushbots.NIL then
    --Most likely a device info GET call, add token to header
    headers["token"] = bodyData.device
  else
    requestParams.body = bodyData
  end

  requestParams.headers = headers

  return requestParams
end

function Pushbots:buildRequestParams( withDataTable )
  local postData = Pushbots.NIL

  if withDataTable.device ~= Pushbots.NIL then
    postData = withDataTable
  else
    --add platform
    withDataTable.platform = Pushbots:getPlatform()
    postData = json.encode( withDataTable )
  end

  return self:newRequestParams( postData ) --for use in a network request
end

function Pushbots:sendRequest( uri, requestParamsTbl, requestType, action, _callback )
  local requestParams = self:buildRequestParams( requestParamsTbl )
  
  requestType = requestType or Pushbots.NIL
  action = action or Pushbots.POST

  local q = { 
    requestId = network.request( uri, action, function(e) Pushbots:onResponse(e); end, requestParams ),
    requestType = requestType,
    _callback = _callback,
  }
  table.insert( self.requestQueue, q )
  
  return q.requestId
end

-- RESPONSE --
function Pushbots:onResponse( event )
  if event.phase == "ended" then
  
    local status = event.status
    local requestId = event.requestId

    local response, decodedResponse
    if status ~= -1 then
      response = event.response
      decodedResponse = json.decode( response )

      if self.showJSON then
        print( event.response )
      end

      if self.showStatus then
        if type( decodedResponse ) == 'table' then
          Pushbots:printTable( decodedResponse )
        else
          if decodedResponse == nil then
            if status >= 200 and status < 400 then
              print( "Success: " .. status )
            else
              print( "Error: " .. status )
            end
          else
            print( decodedResponse )
          end
        end
      end
        
      if self.showAlert then
        local msg = "Status: " .. status .. "\n"
        
        if decodedResponse ~= nil and decodedResponse.message then
          msg = msg .. "Error: " .. decodedResponse.message
        else
          msg = "Pushbots action was successful."
        end
        
        native.showAlert( "Pushbots!", msg , { "OK" } )
      end
      
    end
    
    --find request
    local requestType = Pushbots.NIL
    local _callback = nil
    for r=1, #self.requestQueue do
      local request = self.requestQueue[ r ]
      if request.requestId == requestId then
        requestType = request.requestType
        _callback = request._callback
        table.remove( self.requestQueue, r )
        break
      end
    end

    --broadcast response
    local e = nil
    if status == -1 then --timed out
      e = {
        name = "pushbotsRequest",
        requestId = requestId,
        requestType = requestType,
        response = nil,
        code = -1,
        error = "The request timed out.",
      }
    elseif status >= 200 and status < 400 then
      if decodedResponse == nil then
        decodedResponse = "Success: " .. status
      end

      e = {
        name = "pushbotsRequest",
        requestId = requestId,
        requestType = requestType,
        response = decodedResponse,
        code = status,
        error = nil,
      }

    elseif status >= 400 then  -- error
      e = {
        name = "pushbotsRequest",
        requestId = requestId,
        requestType = self.ERROR,
        response = nil,
        code = status,
        error = decodedResponse.message, 
      }
    end
    
    --broadcast it
    if e ~= nil then
      if _callback then
        _callback( e )
      else --use global event
        self.dispatcher:dispatchEvent( e )
      end
    end
    
  end
end

function Pushbots:getEndpoint( typeConstant )
  return self.endpoint .. typeConstant
end

function Pushbots:cancelRequest( requestId )
  network.cancel( requestId )
end

function Pushbots:getPlatform()
  local platformName = system.getInfo( "platformName" )
  if platformName == "Android" then
    return Pushbots.ANDROID
  elseif platformName == "iPhone OS" then
    return Pushbots.IOS
  else
    return Pushbots.UNKNOWN
  end
end

function Pushbots:printTable( t, indent )
-- print contents of a table, with keys sorted. second parameter is optional, used for indenting subtables
  local names = {}
  if not indent then indent = "" end
  for n,g in pairs(t) do
      table.insert(names,n)
  end
  table.sort(names)
  for i,n in pairs(names) do
      local v = t[n]
      if type(v) == "table" then
          if(v==t) then -- prevent endless loop if table contains reference to itself
              print(indent..tostring(n)..": <-")
          else
              print(indent..tostring(n)..":")
              Pushbots:printTable(v,indent.."   ")
          end
      else
          if type(v) == "function" then
              print(indent..tostring(n).."()")
          else
              print(indent..tostring(n)..": "..tostring(v))
          end
      end
  end
end

function Pushbots:init( appId )
  self.appId = appId
end

return Pushbots
