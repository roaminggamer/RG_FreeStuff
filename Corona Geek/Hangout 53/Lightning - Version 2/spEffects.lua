module(..., package.seeall)
--effects.lua
-- Project: RobotWars
-- Description:  Special Effect routines
--
-- Version: 1.0
-- Managed with http://CoronaProjectManager.com
--
-- Copyright 2012 Brian Burton. All Rights Reserved.
-- Sound effects:
--[[Lightning sound effect: Zoltan Csengeri
	
	]]
local lightning = {}
lightning[1] = audio.loadSound("zap.mp3")
lightning[2] = audio.loadSound("spark.wav")
lightning[3] = audio.loadSound("tesla.wav")
lightning[4] = audio.loadSound("lightning1.mp3")
lightning[5] = audio.loadSound("lightning1.mp3")
 

function drawLightning(x1, y1, x2, y2, displace, r, g, b, level, playSound)

		local playSound = playSound or false

		if( playSound ) then --EFM
 			audio.play(lightning[level])
		end
        
        if displace < curDetail then
 	
                --glow around lightning
                for i = 1, 4 do
                        line = display.newLine(x1, y1, x2, y2)
                        line:setColor(r, g, b)
                        line.width = (15* level) / i
                        line.alpha = 0.05 * i
                        lines:insert(line)
                end
 
                --bolt itself
                line = display.newLine(x1, y1, x2, y2)
                line:setColor(r, g, b)
                line.width = level * 2
                lines:insert(line)
 
        else
                local midx = (x2+x1)/2
                local midy = (y2+y1)/2
                midx = midx + (math.random(0, 1) - 0.5)*displace
                midy = midy + (math.random(0, 1) - 0.5)*displace
                drawLightning(x1, y1, midx, midy, displace/2, r, g, b, level)
                drawLightning(x2, y2, midx, midy, displace/2, r, g, b, level)
        end
end
 
