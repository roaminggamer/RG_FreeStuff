io.output():setvbuf("no") -- Don't use buffer for console messages
display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar

local maxIter = 1000
local primes = {}
local fails = {}

local function primeTest(n)
	for i = 2, n^(1/2) do
		if (n % i) == 0 then
			return false
		end
	end
	return true
end


-- Warning uses brute force!
local function findGoldbachSums( num )
	local start 
	for i = 1, #primes do
		if(primes[i] > num) then 
			start = i-1
			break
		elseif( i == #primes ) then
			start = i
		end
	end
	if(not start) then 
		return 0,0,false
	end
	for i = start, 1, -1 do
		local a = primes[i]
		for k = start, 1, -1 do			
			local b = primes[k]
			if(a+b == num) then
				return a,b,true
			end
		end
	end
	return 0,0,false
end
local function testGoldbachConjecture( min, max )
	local passed = true
	for i = min, max do
		if( i % 2 == 0 ) then -- Even number, test it				
			local a,b,pass = findGoldbachSums( i )
			passed = passed and pass
			if( not pass ) then
				fails[#fails+1] = i
			end
		end
	end
	return passed
end

-- Build list of primes
for i = 1, maxIter do
	if( primeTest(i) ) then
		primes[#primes+1] = i			
	end
end
print( "There are " .. #primes .. " prime numbers between 1 and " .. maxIter )

-- Test all even numbers between 3 and .. maxIter
local startTime = system.getTimer()
local passed = testGoldbachConjecture( 3, maxIter )
local endTime = system.getTimer()

if( passed ) then
	print("All even numbers between 3 and " .. maxIter .. " are in fact the sum of two prime numbers.")
else
	print("Found the follwing even numbers that are not the sum of two primes:")
	for i = 1, #fails do
		print(i)
	end
end
print("Test ran for " .. (endTime - startTime) .. " milliseconds.")