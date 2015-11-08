-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

display.setStatusBar(display.HiddenStatusBar) 
-- Notes for this example ( not part of example )
--
local notes = {
	"The user wanted a way to 'secure' their data.", 
	"",
	"This demo shows how to use a basic substitution cypher that can be", 
	"easily created, stored, and used in your program. While not hyper-secure",
	"this technique is simple, fast to implement, and moderately hard to crack."
}
for i = 1, #notes do
	local tmp = display.newText( notes[i], 50, 20 + (i-1) * 30, native.systemFont, 22 )
	tmp.anchorX = 0
end


--
-- Load SSK
--require "ssk.loadSSK"

-- 
-- Encryption decryption demo w/ security module.
--
local curY = 200
local _print = function( str )
	print( str )
	local tmp = display.newText( str, 20, curY, native.systemFont, 22 )
	curY = curY + 25
	tmp.anchorX = 0
end

local function demo1()
	local security = require "security"

	-- A string to 'secure'
	local secureMe = "mySuperSecretPassword"

	-- Generate a random key
	security.genKey()

	-- Dump The Key To Console
	security.printJsonKey()
	
	local encoded = security.encode( secureMe )
	local decoded = security.decode( encoded )

	_print("Demo 1 - Generating Key")
	_print( "original: " .. secureMe )
	_print( "encoded: " .. encoded )
	_print( "decoded: " .. decoded )

end


-- 
-- Encryption decryption demo w/ security module using previously generated key.
--
local function demo2()
	local security = require "security"

	local jsonKey = '{"a":"D","`":"U","c":"b","b":"G","e":"!","d":"^","g":"I","f":"&","i":"v","h":"d","k":"j","j":"V","m":"_","l":"L","o":"p","n":"|","q":"$","p":"e","s":"@","r":")","u":"9","t":"S","w":"Y","v":"u","y":".","x":"{","{":"]","z":"W","}":"f","|":"6","~":"Z","!":"m"," ":"X","#":"g","%":",","$":"J","&":"2",")":"=","(":"x","+":"#","*":"8","-":"-",",":">","/":"1",".":"h","1":";","0":"3","3":"w","2":"P","5":"K","4":"~","7":"}","6":"q","9":"`","8":"+",";":"T",":":"/","=":"0","<":"M","?":"Q",">":"?","A":"[","@":"l","C":"*","B":"t","E":"o","D":"k","G":"F","F":"R","I":"r","H":"y","K":"B","J":" ","M":"C","L":"(","O":"4","N":"c","Q":":","P":"n","S":"<","R":"i","U":"7","T":"a","W":"s","V":"A","Y":"z","X":"E","[":"H","Z":"N","]":"O","_":"5","^":"%"}'

	-- A string to 'secure'
	local encoded = "!HtvopItpNIpB2TWW3EIh"

	-- Generate a random key
	security.loadJsonKey( jsonKey )

	local decoded = security.decode( encoded )

	curY = curY + 50
	_print("Demo 2 - Using previously generated key")
	_print( "encoded: " .. encoded )
	_print( "decoded: " .. decoded )

end

demo1()
demo2()
