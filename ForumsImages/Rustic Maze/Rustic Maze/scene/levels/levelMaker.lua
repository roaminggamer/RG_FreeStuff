local t = {};
local types = {W = "wall", F = "floor", G = "gem", P = "player"}; --input definitions

for i = 1, 10 do
    table.insert(t, io.read("*line")); --read all inputs
end
    
print("["); --open JSON
    
for k, v in pairs(t) do
    local st = {};
     
    for m = 1, 10 do
        table.insert(st, v:sub(m, m)); --break up input line
    end

    for j, w in pairs(st) do
        if types[w] ~= nil then --filter undefined inputs
            local fin = ",";
            
            if (k == 10) and (j == 10) then
                fin = ""; --avoid commas on last line
            end
            
            print("\t".."{".. --open line
                "\"".."x".."\""..":"..((j - 1)*32)..",".. --x-coord
                "\"".."y".."\""..":"..((k - 1)*32)..",".. --y-coord
                "\"".."type".."\""..":".."\""..types[w].."\"".. --type
                "}"..fin); --close line
				
			if (w == "G") or (w == "P") then
				print("\t".."{".. --open line
					"\"".."x".."\""..":"..((j - 1)*32)..",".. --x-coord
					"\"".."y".."\""..":"..((k - 1)*32)..",".. --y-coord
					"\"".."type".."\""..":".."\"".."floor".."\"".. --type
					"}"..fin); --close line	
			end
        end
    end
end

print("]") --close the JSON