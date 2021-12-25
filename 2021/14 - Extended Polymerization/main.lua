local base
local rules = {}
local part1, part2 = {}, {}

for line in io.lines("input.txt") do
	if not base then
		base = line
		for c in line:gmatch(".") do
			part1[c] = (part1[c] or 0) + 1
			part2[c] = (part2[c] or 0) + 1
		end
	elseif line ~= "" then
		local pair, insert = line:match("(..) %-> (.)")
		rules[pair] = insert
	end
end


local function recurse(left, right, depth, memo)
	if depth == 0 then return {} end

	if memo[left .. right .. depth] then
		return memo[left .. right .. depth]
	else
		local insert = rules[left .. right]
		local counts = {}
		counts[insert] = (counts[insert] or 0) + 1

		for c, amt in pairs(recurse(left, insert, depth - 1, memo)) do
			counts[c] = (counts[c] or 0) + amt
		end
		for c, amt in pairs(recurse(insert, right, depth - 1, memo)) do
			counts[c] = (counts[c] or 0) + amt
		end

		memo[left .. right .. depth] = counts
		return counts
	end
end


local memoA, memoB = {}, {}
for i = 1, #base - 1 do
	local left = base:sub(i,i)
	local right = base:sub(i+1,i+1)

	-- Part 1
	for c, amt in pairs(recurse(left, right, 10, memoA)) do
		part1[c] = (part1[c] or 0) + amt
	end

	-- Part 2
	for c, amt in pairs(recurse(left, right, 40, memoB)) do
		part2[c] = (part2[c] or 0) + amt
	end
end


local min, max = math.huge, -math.huge
for c, amt in pairs(part1) do
	min = math.min(min, amt)
	max = math.max(max, amt)
end
print("Part 1:", max - min)

min, max = math.huge, -math.huge
for c, amt in pairs(part2) do
	min = math.min(min, amt)
	max = math.max(max, amt)
end
print("Part 2:", max - min)