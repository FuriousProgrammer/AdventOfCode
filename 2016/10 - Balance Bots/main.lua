local bots = setmetatable({}, {
	__index = function(t, i)
		t[i] = {
			botID = i;
			holding = {};
--			high = ""; -- a specific bot, or a number (output)
--			low = ""; -- a specific bot, or a number (output)
		}
		return t[i]
	end;
})
local output = {}
local queue = {}

for line in io.lines("input.txt") do
	if line:find("value") then
		local val, bot = line:match("(%d+).-(%d+)")
		table.insert(bots[bot].holding, tonumber(val))
		if #bots[bot].holding == 2 then
			queue[#queue + 1] = bots[bot]
		end
	else
		local from, lowType, low, highType, high = line:match("bot (%d+) gives low to (%a+) (%d+) and high to (%a+) (%d+)")
		bots[from].high = (highType == "bot" and bots[high] or tonumber(high))
		bots[from].low  = (lowType  == "bot" and bots[low]  or tonumber(low) )
	end
end

while #queue > 0 do
	local bot = table.remove(queue)
	local high = math.max(bot.holding[1], bot.holding[2])
	local low  = math.min(bot.holding[1], bot.holding[2])

	if high == 61 and low == 17 then
		print("Part 1:", bot.botID)
	end

	if type(bot.high) == "table" then
		table.insert(bot.high.holding, high)
		if #bot.high.holding == 2 then
			queue[#queue + 1] = bot.high
		end
	else
		output[bot.high] = high
	end

	if type(bot.low) == "table" then
		table.insert(bot.low.holding, low)
		if #bot.low.holding == 2 then
			queue[#queue + 1] = bot.low
		end
	else
		output[bot.low] = low
	end

end

print("Part 2:", output[0]*output[1]*output[2])