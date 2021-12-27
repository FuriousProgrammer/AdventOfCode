local function parse(txt, prefix)
	if not prefix then prefix = "" end
	if tonumber(txt) then return {{prefix = prefix, value = tonumber(txt)}} end

	-- [ num or [?..]? , num or [?..]? ]
	local left = txt:match("^%[(%d+),") or txt:match("^%[(%b[]),")
	local right = txt:match(",(%d+)%]$") or txt:match(",(%b[])%]$")

	local res = parse(left, prefix .. "L")
	for _, v in ipairs(parse(right, prefix .. "R")) do
		table.insert(res, v)
	end
	return res
end


local function reduce(num)
	local stale = true

	while stale do
		stale = false
		for i, v in ipairs(num) do
			if #v.prefix > 4 then
				stale = true
				-- explode!

				-- i:     ????L
				-- i + 1: ????R
				if i > 1 then
					num[i - 1].value = num[i - 1].value + num[i].value
				end
				if i + 1 < #num then
					num[i + 2].value = num[i + 2].value + num[i + 1].value
				end
				num[i].value = 0
				num[i].prefix = num[i].prefix:sub(1,-2)
				table.remove(num, i + 1)

				break
			end
		end

		if not stale then
			for i, v in ipairs(num) do
				if v.value > 9 then
					stale = true
					-- split!

					local new = {prefix = v.prefix .. "R", value = math.ceil(v.value/2)}
					table.insert(num, i + 1, new)
					v.prefix = v.prefix .. "L"
					v.value = math.floor(v.value/2)

					break
				end
			end
		end
	end

	return num
end


local function add(a, b)
	local res = {}

	for _, v in ipairs(a) do
		table.insert(res, {
			prefix = "L" .. v.prefix;
			value = v.value;
		})
	end
	for _, v in ipairs(b) do
		table.insert(res, {
			prefix = "R" .. v.prefix;
			value = v.value;
		})
	end

	return reduce(res)
end


local function magnitude(num)
	local res = 0

	for _, v in pairs(num) do
		local val = v.value
		for c in v.prefix:gmatch(".") do
			val = val * (c == "L" and 3 or 2)
		end
		res = res + val
	end

	return res
end


assert( magnitude(parse("[[1,2],[[3,4],5]]")) == 143 )
assert( magnitude(parse("[[[[0,7],4],[[7,8],[6,0]]],[8,1]]")) == 1384 )
assert( magnitude(parse("[[[[1,1],[2,2]],[3,3]],[4,4]]")) == 445 )
assert( magnitude(parse("[[[[3,0],[5,3]],[4,4]],[5,5]]")) == 791 )
assert( magnitude(parse("[[[[5,0],[7,4]],[5,5]],[6,6]]")) == 1137 )
assert( magnitude(parse("[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]")) == 3488 )


local sum
local nums = {}
for line in io.lines("input.txt") do
	local num = parse(line)
	table.insert(nums, num)
	sum = sum and add(sum, num) or num
end
print("Part 1:", magnitude(sum))


local max = -math.huge
for a = 1, #nums - 1 do
	for b = a + 1, #nums do
		max = math.max( max, magnitude( add( nums[a], nums[b] ) ) )
		max = math.max( max, magnitude( add( nums[b], nums[a] ) ) )
	end
end
print("Part 2:", max)