local part1 = 0
local map = {
	[')'] = {c = '(', score = 3};
	[']'] = {c = '[', score = 57};
	['}'] = {c = '{', score = 1197};
	['>'] = {c = '<', score = 25137};
}

local scores = {}
local map2 = {
	['('] = 1;
	['['] = 2;
	['{'] = 3;
	['<'] = 4;
}

for line in io.lines("input.txt") do
	local stack = {}
	local corrupt = false

	for c in line:gmatch(".") do
		if not map[c] then
			table.insert(stack, c)
		elseif #stack == 0 or map[c].c ~= table.remove(stack) then
			part1 = part1 + map[c].score
			corrupt = true
			break
		end
	end

	if not corrupt then
		local score = 0
		for i = #stack, 1, -1 do
			score = score*5 + map2[stack[i]];
		end
		table.insert(scores, score)
	end
end

print("Part 1:", part1)
table.sort(scores)
print("Part 2:", scores[math.ceil(#scores/2)])