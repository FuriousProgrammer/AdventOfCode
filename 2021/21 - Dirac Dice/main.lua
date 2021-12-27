local file = io.open("input.txt")
local a = {space = tonumber( file:read("*l"):match("(%d+)$") ) - 1, score = 0}
local b = {space = tonumber( file:read("*l"):match("(%d+)$") ) - 1, score = 0}
file:close()

-- for part 2
local aStart = a.space
local bStart = b.space

local die = 0
local tosses = 0

while true do
	tosses = tosses + 3

	a.space = (a.space + die + (die + 1)%100 + (die + 2)%100 + 3)%10
	a.score = a.score + a.space + 1
	die = (die + 3)%100

	if a.score >= 1000 then break end
	a, b = b, a
end

print("Part 1:", tosses*b.score)

local wins = {0, 0}
local rolls = {}
for a = 1, 3 do
	for b = 1, 3 do
		for c = 1, 3 do
			local roll = a + b + c
			rolls[roll] = (rolls[roll] or 0) + 1
		end
	end
end

--[[ ~1.5 minutes
local queue = {{
	a = {space = aStart, score = 0, player = 1};
	b = {space = bStart, score = 0, player = 2};
	universes = 1;
}}
while #queue > 0 do
	local turn = table.remove(queue)

	for roll, multiplier in pairs(rolls) do
		local new = {
			a = {space = turn.b.space, score = turn.b.score, player = turn.b.player};
			b = {space = turn.a.space, score = turn.a.score, player = turn.a.player};
			universes = turn.universes*multiplier
		}
		
		new.b.space = (new.b.space + roll)%10
		new.b.score = new.b.score + new.b.space + 1

		if new.b.score >= 21 then
			wins[new.b.player] = wins[new.b.player] + new.universes

			winsUpper[new.b.player] = winsUpper[new.b.player] + math.floor(wins[new.b.player] / 1000000)
			wins[new.b.player] = wins[new.b.player]%1000000
		else
			table.insert(queue, new)
		end

	end

end
--]]

--[[ ~17 seconds
local function recurse(aSpace, aScore, aPlayer, bSpace, bScore, bPlayer, universes)
	if bScore >= 21 then
		wins[bPlayer] = wins[bPlayer] + universes
		return
	end

	for roll, multiplier in pairs(rolls) do
		newaSpace = (aSpace + roll)%10
		newaScore = aScore + newaSpace + 1
		recurse(bSpace, bScore, bPlayer, newaSpace, newaScore, aPlayer, universes*multiplier)
	end
end
recurse(aStart, 0, 1, bStart, 0, 2, 1)
--]]

-- [[ ~9 seconds
local function recurse(aSpace, aScore, bSpace, bScore, universes)
	for rollA, multiplierA in pairs(rolls) do
		local newaSpace = (aSpace + rollA)%10
		local newaScore = aScore + newaSpace + 1
		if newaScore >= 21 then
			wins[1] = wins[1] + universes*multiplierA
		else
			for rollB, multiplierB in pairs(rolls) do
				local newbSpace = (bSpace + rollB)%10
				local newbScore = bScore + newbSpace + 1
				if newbScore >= 21 then
					wins[2] = wins[2] + universes*multiplierA*multiplierB
				else
					recurse(newaSpace, newaScore, newbSpace, newbScore, universes*multiplierA*multiplierB)
				end
			end
		end
	end
end
recurse(aStart, 0, bStart, 0, 1)
--]]

print("Part 2:", string.format("%.0f", math.max( wins[1], wins[2] )))