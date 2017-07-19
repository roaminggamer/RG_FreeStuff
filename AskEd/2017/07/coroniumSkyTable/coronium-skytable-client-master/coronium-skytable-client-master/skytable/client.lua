-- #########################################################################
-- # Coronium SkyTable Client 
-- # Copyright 2017 C. Byerley (develephant.com)
-- # Licensed under the Apache License, Version 2.0 (the "License");
-- # you may not use this file except in compliance with the License.
-- # You may obtain a copy of the License at: 
-- # http://www.apache.org/licenses/LICENSE-2.0
-- # Unless required by applicable law or agreed to in writing, software
-- # distributed under the License is distributed on an "AS IS" BASIS,
-- # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- # See the License for the specific language governing permissions and
-- # limitations under the License.
-- #########################################################################

local json = require('json')
local crypto = require('crypto')

local concat = table.concat
local lower = string.lower
local hmac = crypto.hmac

local gen_key = "eb49bc6839ab34b95efafdd723aff3ce024a0dc4de9cc8b024bd18429675e027"

local _M = {}
local _client = {}

local mt = { __index = _client }

--###############################################################################
--# Utils
--###############################################################################
--- Pretty print table data.
-- @tparam table t The table data to print.
-- @param[opt=""] indent Indentation char.
function _log( t, indent )
  --== Check for scalar
  if type(t) ~= 'table' then
    print(t)
    return
  end

  --== Print contents of a table, with keys sorted.
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
              _log(v, indent.." ")
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

--###############################################################################
--# Privates
--###############################################################################

local function _create_user_key(user_name, user_password)
  local data = lower(user_name)..lower(user_password)
  local hash = hmac(crypto.md5, data, gen_key)
  return hash
end

local function _create_key_path(base_key, key)
  local parts = concat({base_key, key}, ":")
  return parts
end

local function _create_data_path(data_path)
  data_path = "." .. (data_path or '')
  return data_path
end

local function _generate_auth()
  --disabled in demo
  return ""
end

local function _create_request(key_path, action, data_path, payload, server_key, user_key, options)

  local body = 
  {
    scope = key_path,
    path = data_path,
    data = json.encode(payload)
  }

  if options then
    body.flag = options.flag
    body.expiry = options.expiry
  end

  body = json.encode(body)

  local headers = 
  {
    ["X-SkyTable-Key"] = server_key,
    ["X-SkyTable-UserKey"] = user_key,
    ["X-SkyTable-Action"] = action,
    ["X-SkyTable-Auth"] = _generate_auth(),
    ["Content-Type"] = "application/json",
    ["Content-Length"] = #body
  }

  local params = 
  {
    headers = headers,
    body = body
  }

  return body, headers, params

end

local function _parseArgs(...)
  local args = {...}

  local err, data_path, listener, options = nil

  if #args == 1 then
    listener = args[1]
  elseif #args == 2 then
    if type(args[1]) == 'function' then
      listener = args[1]
      options = args[2]
    else
      data_path = args[1]
      listener = args[2]
    end
  elseif #args == 3 then
    data_path = args[1]
    listener = args[2]
    options = args[3]
  else
    err = "Missing arguments!"
    print(err)
  end

  return err, data_path, listener, options
end

--###############################################################################
--# SkyTable
--###############################################################################

function _M.init(self, config)
  self.config = config
  self.config.user_key = _create_user_key(config.user, config.password)
end

function _M.open(self, table_key)
  return setmetatable({
    table_key = table_key,
    config = self.config,
    queue = {}
  }, mt)
end

--###############################################################################
--# Client
--###############################################################################

function _client.request(self, key_path, action, data_path, payload, listener, options)
  
  local body, headers, params = _create_request(
    key_path, action, data_path, payload, self.config.key, self.config.user_key, options)

  local tag = nil
  if options and options.tag then
    tag = options.tag
  end

  local function onResponse(evt)

    --find request
    local request = nil
    for i=1, #self.queue do 
      if self.queue[i].id == evt.requestId then
        request = table.remove(self.queue, i)
        break
      end
    end

    --check for request item
    assert(request, "Request event was not found in the queue!")

    --check network error
    if evt.isError then
      if request.listener then
        return request.listener({isError=true, error=evt.error})
      else
        return print("Response error: "..evt.error)
      end
    end

    if self.config.debug then
      print('======= SkyTable Response =======')
    end

    local response = json.decode(evt.response)

    if not response then
      return request.listener({isError=true, error="Could not parse response data."})
    end

    --parse result
    local result = response.result

    --check server error
    if response.error then
      return request.listener({isError=true, error=response.error..': '..response.result, tag=request.tag})
    end

    --check api error
    if result.err then
      return request.listener({isError=true, error=result.err, tag=request.tag})
    end

    --check for Set return
    if result.success then
      if request.listener then
        return request.listener({success=result.success, user=result.key, tag=request.tag})
      end
    end

    local _type = result._t 
    local _data = nil

    if not _type then
      if result.data then
        _data = result.data
      end
    elseif _type == 'tbl' then
      _data = json.decode(result.data)
    elseif _type == 'str' then
      _data = tostring(result.data)
    elseif _type == 'num' then
      _data = tonumber(result.data)
    elseif _type == 'bol' then
      _data = result.data
    end

    if request.listener then
      request.listener({data=_data, user=result.key, tag=request.tag})
    end

    if self.config.debug then
      _log(_data)
    end

    request = nil

  end

  local id = network.request(self.config.host, "POST", onResponse, params)

  --add to queue
  table.insert(self.queue, {id=id, listener=listener, tag=tag})
end

--###############################################################################
--# Set
--###############################################################################

function _client.set(self, ...)

  local args = {...}

  local action = "Set"

  local data_path, data, listener, options = nil

  if #args == 2 then
    data = args[1]
    listener = args[2]
    options = { flag = "NX" }
  elseif #args == 3 then
    if type(args[2]) == 'function' then
      data = args[1]
      listener = args[2]
      options = args[3]
      if not options.flag then
        options.flag = "NX"
      end
    else
      data_path = args[1]
      data = args[2]
      listener = args[3]
    end
  elseif #args == 4 then
    data_path = args[1]
    data = args[2]
    listener = args[3]
    options = args[4]
  else
    return print("Missing arguments!")
  end

  local key_path = _create_key_path(self.config.base, self.table_key)
  local data_path = _create_data_path(data_path)

  self:request(
    key_path,
    action,
    data_path,
    data,
    listener,
    options)
end

--###############################################################################
--# Get/Delete/Keys
--###############################################################################

function _client.sendRequest(self, action, data_path, listener, options)
  local key_path = _create_key_path(self.config.base, self.table_key)
  local data_path = _create_data_path(data_path)

  self:request(
    key_path,
    action, 
    data_path, 
    nil,
    listener,
    options)
end

function _client.get(self, ...)
  local err, data_path, listener, options = _parseArgs(...)
  if not err then
    self:sendRequest("Get", data_path, listener, options)
  end
end

function _client.delete(self, ...)
  local err, data_path, listener, options = _parseArgs(...)
  if not err then
    self:sendRequest("Delete", data_path, listener, options)
  end
end

function _client.keys(self, ...)
  local err, data_path, listener, options = _parseArgs(...)
  if not err then
    self:sendRequest("Keys", data_path, listener, options)
  end
end

--###############################################################################
--# Export
--###############################################################################
return _M