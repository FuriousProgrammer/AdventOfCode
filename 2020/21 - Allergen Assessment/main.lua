local data = {}
local allerg = {}

for line in io.lines("input.txt") do
	local new = {food={}, allergens={}}
	data[#data + 1] = new

	local food, allergens = line:match("^(.+) %(contains (.+)%)$")
	allergens = allergens:gsub(",", "")

	for w in allergens:gmatch("(%S+)") do
		table.insert(new.allergens, w)
		if not allerg[w] then allerg[w] = {} end
		table.insert(allerg[w], new.food)
	end
	for w in food:gmatch("(%S+)") do
		table.insert(new.food, w)
	end
end

local function find(t, v)
	for i, check in pairs(t) do
		if check == v then
			return i
		end
	end
	return nil
end

-- TODO: maybe refactor data structures to avoid searching and unnecesary memory usage
local solved = {}
local stale = false
while not stale do
	stale = true
	for allergen, foodList in pairs(allerg) do
		if not find(solved, allergen) then

			local prev = {}
			for _, food in pairs(foodList[1]) do
				if not solved[food] then
					prev[#prev + 1] = food
				end
			end

			for i = 2, #foodList do
				local n = {}
				for _, food in pairs(foodList[i]) do
					if not solved[food] and find(prev, food) then
						n[#n + 1] = food
					end
				end
				prev = n
				if #n == 1 then break end
			end

			if #prev == 1 then
				solved[prev[1]] = allergen
				stale = false
			end

		end
	end
end

-- TODO: rename usage of "food" above to "ingr" where appropriate
-- TODO: assert that all listed allergens are accounted for!

local notAllergens = 0
for _, food in pairs(data) do
	for _, ingr in pairs(food.food) do
		if not solved[ingr] then
			notAllergens = notAllergens + 1
		end
	end
end
print("Part 1:", notAllergens)

local sortable = {}
for ingr in pairs(solved) do
	sortable[#sortable + 1] = ingr
end
table.sort(sortable, function(a, b)
	return solved[a] < solved[b]
end)
print("Part 2:", table.concat(sortable, ","))