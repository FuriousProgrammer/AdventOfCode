local input = io.open("input.txt")
input = input:read("*l"), input:close()

local function getLength(input, v2)
	local totalLen = 0
	while input:find("%(") do
		local pre, len, repeats, post = input:match("(.-)%((%d+)x(%d+)%)(.*)")
		len, repeats = tonumber(len), tonumber(repeats)

		local mid = post:sub(1, len)
		totalLen = totalLen + #pre + repeats*(v2 and getLength(mid, v2) or #mid)

		input = post:sub(len + 1)
	end

	return totalLen + #input
end

print("Part 1:", getLength(input))
print("Part 2:", getLength(input, true))