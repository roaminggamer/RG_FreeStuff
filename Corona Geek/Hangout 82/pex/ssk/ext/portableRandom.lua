-- =============================================================
-- portableRandom.lua 
--
-- This is an implementation of a md5 based
-- pseudo random number generator which creates the same
-- sequence of values for implementations on different
-- platforms (Hans Raaf)
--
-- http://developer.coronalabs.com/code/portable-seedable-random-number-generator 
-- 
-- =============================================================
----------------------------------------------------------------------
-- 1. Local Variables and Functions
----------------------------------------------------------------------
 
-- copy what we need as local
local floor=math.floor
local byte=string.byte
local sub=string.sub
local random=math.random
local tostring=tostring
local assert=assert
 
local crypto = require('crypto')
 
local digest=crypto.digest
local md5=crypto.md5
 
-- All functions are local and used only inside the objects I create
 
local randInt = function(self,min,max)
   local min = min or 0
   local max = max or min + 255
   assert(self.pos > 0) -- is 0 if neither seed nor randomize was called
   assert(max-min < 256 and max-min > 0) -- only possible values
   if self.pos>16 then
      self.digest=digest(md5,self.digest,true)
      self.pos=1
   end
   local x=floor(byte(sub(self.digest,self.pos,self.pos))*(max-min+1)/256)+min
   self.pos=self.pos+1
   self.my_step=self.my_step+1
   return x
end
 
local seed = function(self,s)
   self.my_step=0
   self.my_seed=s
   self.digest=digest(md5,self.my_seed,true)
   self.pos=1
end
 
local randomize = function(self)
   self:seed(tostring(random()))
end
 
local step = function(self,step)
   local step = step or 1
   assert(self.pos>0) -- is 0 if neither seed nor randomize was called
   -- fast forward to a position
   local i
   -- shortcut for full 16 steps
   for i=1, floor(step/16) do
      self.digest=digest(md5,self.digest,true)
      self.pos=1
      self.my_step=self.my_step+16
   end
   -- set the offsets to the right position
   self.pos=self.pos+step%16
   self.my_step=self.my_step+step%16
end
 
----------------------------------------------------------------------
-- 2. The module
----------------------------------------------------------------------
math.prand = {}

math.prand.new = function()
   return {
      my_step=0,
      my_seed=nil,
      digest=nil,
      pos=0,
      
      randInt=randInt,
      seed=seed,
      randomize=randomize,
      step=step
   }
end
