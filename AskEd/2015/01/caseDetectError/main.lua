require "ssk.loadSSK"
-- 1. Include this file in your project (very early or as first line in main.lua)
local ced = require "caseErrorDetect"

-- 2. Optionally promote warning prints to errors
ced.promoteToError()

-- =======================================================================
-- 1. Test 'require' -- Correct name is "bob"
--
-- a. Root folder
local bob = require("Bob") 
print(bob.name)

-- b. Sub- folder
require("scripts.Bob") 
print(bob.name)

-- =======================================================================
-- 2. Test display.newImage -- Correct name is "smiley.png"
--
-- a. variant 1
local tmp = display.newImage( "Smiley.png", 50, 50 ) 

-- b. variant 2
local tmp = display.newImage( display.currentStage, "Smiley.png", 150, 50 )


-- c. sub-folder variant 1
local tmp = display.newImage( "images/Smiley.png", 50, 100 ) -- Correct name is "smiley.png"

-- d. sub-folder variant 2
local tmp = display.newImage( display.currentStage, "images/Smiley.png", 150, 100 )


-- =======================================================================
-- 3. Test display.newImageRect -- Correct name is "smiley.png"
--
-- a. variant 1
local tmp = display.newImageRect( "Smiley.png", 32,32 ) 
tmp.x = 50
tmp.y = 150

-- b. variant 2
local tmp = display.newImageRect( display.currentStage, "Smiley.png", 32, 32 )
tmp.x = 150
tmp.y = 150


-- c. sub-folder variant 1
local tmp = display.newImageRect( "images/Smiley.png", 32, 32 ) -- Correct name is "smiley.png"
tmp.x = 50
tmp.y = 200

-- d. sub-folder variant 2
local tmp = display.newImageRect( display.currentStage, "images/Smiley.png", 32, 32 )
tmp.x = 150
tmp.y = 200
