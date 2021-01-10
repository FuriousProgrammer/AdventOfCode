local nums = {0} -- Outlet!

for line in io.lines("input.txt") do
	nums[#nums + 1] = tonumber(line)
end

table.sort(nums)

nums[#nums + 1] = nums[#nums] + 3 -- Final Adapter!

local sets = {{}}
local set = sets[1]

local three, one = 0, 0
for i = 1, #nums - 1 do
	set[#set + 1] = nums[i]

	local d = nums[i + 1] - nums[i]
	if d == 3 then
		set = {}
		sets[#sets + 1] = set
		three = three + 1
	elseif d == 1 then
		one = one + 1
	end
end

set[#set + 1] = nums[#nums]

print("Part 1:", three*one)


local function docount(set, st_i)
	if not st_i then st_i = 1 end
	if st_i == #set then return 1 end

	local count = 0
	for i = st_i + 1, #set do
		if set[i] - set[st_i] <= 3 then
			count = count + docount(set, i)
		else
			break
		end
	end

	return count
end

local combos = 1
for i, set in pairs(sets) do
	if #set > 2 then
		combos = combos*docount(set)
	end
end

print("Part 2:", combos)