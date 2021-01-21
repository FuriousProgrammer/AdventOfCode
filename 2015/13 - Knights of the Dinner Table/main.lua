local people = setmetatable({}, {
	__index = function(t, i)
		t[i] = {}
		return t[i]
	end;
})

for line in io.lines("input.txt") do
	local who, lose, amount, target = line:match("^(%a+) would (%a+) (%d+) happiness units by sitting next to (%a+)%.$")
	amount = tonumber(amount)*(lose=="lose" and -1 or 1)

	people[who][target] = amount
end

local peopleList = {}
people.me = {}
for person, data in pairs(people) do
	if person ~= "me" then
		peopleList[#peopleList + 1] = person
	end
	data.me = 0
	people.me[person] = 0
end
peopleList[#peopleList + 1] = "me"

local function score(array)
	local score = 0

	for i = 1, #array do
		local current = peopleList[array[i]]
		local left  = peopleList[array[(i - 2)%#array + 1]]
		local right = peopleList[array[    (i)%#array + 1]]

		score = score + people[current][left]
		score = score + people[current][right]
	end

	return score
end

local function nextPermutation(array)
	local i = #array
	while i > 1 and array[i - 1] >= array[i] do
		i = i - 1
	end
	if i <= 1 then return false end

	local j = #array
	while array[j] <= array[i - 1] do
		j = j - 1
	end

	array[j], array[i - 1] = array[i - 1], array[j]

	j = #array
	while i < j do
		array[j], array[i] = array[i], array[j]
		i = i + 1
		j = j - 1
	end

	return true
end


local max = -math.huge
local order = {1, 2, 3, 4, 5, 6, 7, 8}
repeat
	max = math.max(max, score(order))
until not nextPermutation(order)
print("Part 1:", max)


local max = -math.huge
local order = {1, 2, 3, 4, 5, 6, 7, 8, 9}
repeat
	max = math.max(max, score(order))
until not nextPermutation(order)
print("Part 2:", max)