local reactions = {}

for line in io.lines("inpt.txt") do
	local i, o = line:match("(.+) => (.+)")

	local ins = {}
	for amt, name in i:gmatch("(%d+) (%a+)") do
		ins[name] = tonumber(amt)
	end
	amt, name = o:match("(%d+) (%a+)")
	amt = tonumber(amt)

	reactions[name] = {cost=ins, amt=amt}
end

-- NOTE: this solution assumes 2 things:
--	1) No reaction produces multiple outputs.
--  2) No two reactions produce the same output.
-- ASIDE: balancing real chemical equations is more fun than this :(
local function buildFuel(amtFuel)
	local ore = 0
	local spare = {ORE=0}

	local function build(name, amt)
		if (spare[name] or 0) >= amt then
			return -- Skip if nothing to do!
		elseif (spare[name] or 0) > 0 then
			amt = amt - spare[name] -- Reduce if partially done!
		end
		if name == "ORE" then
			ore = ore + amt
			spare.ORE = spare.ORE + amt
		else
			local multi = math.ceil(amt/reactions[name].amt)
			for name, amt in pairs(reactions[name].cost) do
				build(name, amt*multi)
				spare[name] = spare[name] - amt*multi
			end
			spare[name] = (spare[name] or 0) + reactions[name].amt*multi
		end
	end

	build("FUEL", amtFuel)
	return ore
end

print("Part 1:", buildFuel(1))

local cap = 1000000000000

local low = 0
local high = math.floor(0.9*cap/buildFuel(1)) -- guarantee an under-estimate
local ore = buildFuel(high)
while ore < cap do -- generate an over-estimate
	low = high
	high = math.floor(high*1.1)
	ore = buildFuel(high)
end

-- test value halfway between over- and under-estimate, replacing relevant estimate
-- When the difference is 1, under-estimate is highest value under cap!
while high - low > 1 do
	local test = math.floor((high + low)/2)
	if buildFuel(test) > cap then
		high = test
	else
		low = test
	end
end

print("Part 2:", low)