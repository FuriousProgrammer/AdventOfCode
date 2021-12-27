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

-- aStart, bStart = 3, 7

local winsUpper = {0, 0}
local wins = {0, 0}
local queue = {{
	a = {space = aStart, score = 0, player = 1};
	b = {space = bStart, score = 0, player = 2};
	universes = 1;
}}

local rolls = {}
for a = 1, 3 do
	for b = 1, 3 do
		for c = 1, 3 do
			local roll = a + b + c
			rolls[roll] = (rolls[roll] or 0) + 1
		end
	end
end


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

local totalMax
if winsUpper[1] > winsUpper[2] then
	totalMax = winsUpper[1] .. wins[1]
elseif winsUpper[1] < winsUpper[2] then
	totalMax = winsUpper[2] .. wins[2]
else -- upper equal
	totalMax = winsUpper[1] .. math.max( wins[1], wins[2] )
end
print("Part 2:", totalMax)