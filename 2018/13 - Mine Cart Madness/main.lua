local map = {}
local carts = {}

local isCart = {
	[">"] = {path = '-', dir = 0};
	["v"] = {path = '|', dir = 1};
	["<"] = {path = '-', dir = 2};
	["^"] = {path = '|', dir = 3};
}
local dirs = {
	[0] = {x =  1, y =  0};
	[1] = {x =  0, y =  1};
	[2] = {x = -1, y =  0};
	[3] = {x =  0, y = -1};
}
local turns = {
	['/'] = {
		[0] = 3,
		[1] = 2,
		[2] = 1,
		[3] = 0,
	};
	['\\'] = {
		[0] = 1,
		[1] = 0,
		[2] = 3,
		[3] = 2,
	};
}

for line in io.lines("input.txt") do
	local row = {}
	map[#map + 1] = row
	for c in line:gmatch("(.)") do
		if isCart[c] then
			local cart = {
				x = #row + 1;
				y = #map;
				dir = isCart[c].dir;
				turn = -1;
			}
			c = isCart[c].path
			carts[#carts + 1] = cart
		end
		row[#row + 1] = c
	end
end



local function sortCarts(a, b)
	if a.y < b.y then
		return true
	elseif a.y == b.y then
		return a.x < b.x
	end
	return false
end

local part1 = false
while true do
	table.sort(carts, sortCarts)
	local kill = {}

	for _, cart in ipairs(carts) do
		if not kill[cart] then
			cart.y = cart.y + dirs[cart.dir].y
			cart.x = cart.x + dirs[cart.dir].x
			local c = map[cart.y][cart.x]
			if turns[c] then
				cart.dir = turns[c][cart.dir]
			elseif c == '+' then
				cart.dir = (cart.dir + cart.turn)%4
				cart.turn = (cart.turn + 2)%3 - 1
			end

			for _, other in pairs(carts) do
				if not kill[other] and cart ~= other and cart.x == other.x and cart.y == other.y then
					if not part1 then
						print("Part 1:", (cart.x - 1) .. ',' .. (cart.y - 1))
						part1 = true
					end
					kill[cart] = true
					kill[other] = true
					break
				end
			end
		end
	end

	for cart in pairs(kill) do
		for i, check in pairs(carts) do
			if cart == check then
				table.remove(carts, i)
				break
			end
		end
	end

	if #carts == 1 then
		print("Part 2:", (carts[1].x - 1) .. ',' .. (carts[1].y - 1))
		os.exit()
	end
end