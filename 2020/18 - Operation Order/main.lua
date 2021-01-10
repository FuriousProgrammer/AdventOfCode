if type(jit) == "table" or tonumber(_VERSION:sub(-1)) < 3 then
	print("This code requires Lua 5.3+")
	print("The sum in Part 2 is *just* too large to fit exactly in a LuaJIT number.")
	os.exit()
end


local function process1(line) -- manual processing!
-- NOTE: I originally tried to do part 1 with Shunting Yard while ignoring precedence,
-- but that didn't work and I don't know enough about the algorithm to figure out why.
	local temp = {}
	while true do
		local pre, expression, post = line:match("^(.-)(%b())(.*)$")
		if not pre then break end
		temp[#temp + 1] = pre
		temp[#temp + 1] = process1(expression:sub(2,-2))
		line = post
	end
	temp[#temp + 1] = line
	line = table.concat(temp)

	-- TODO: optimize this to avoid concatenation!
	while true do
		local a, op, b, rest = line:match("^(%d+) ([+%*]) (%d+)(.*)$")
		if not a then break end
		a, b = tonumber(a), tonumber(b)
		line = (op == "+" and a + b or a * b) .. rest
	end

	return tonumber(line)
end

local function process2(line) -- shunting yard + postfix processing
	local ops, out = {}, {}

	for c in line:gmatch(".") do
		if c ~= " " then -- ignore whitespace
			if c == "(" or c == "+" then
				ops[#ops + 1] = c
			elseif c == ")" then
				while ops[#ops] ~= "(" do
					out[#out + 1] = table.remove(ops)
				end
				ops[#ops] = nil
			elseif c == "*" then
				while ops[#ops] and ops[#ops] == "+" do
					out[#out + 1] = table.remove(ops)
				end
				ops[#ops + 1] = c
			else -- c is a number!
				out[#out + 1] = tonumber(c)
			end
		end
	end
	while #ops > 0 do
		out[#out + 1] = table.remove(ops)
	end

	for _, tok in ipairs(out) do
		if tok == "+" then
			ops[#ops - 1] = ops[#ops - 1] + ops[#ops] 
			ops[#ops] = nil
		elseif tok == "*" then
			ops[#ops - 1] = ops[#ops - 1] * ops[#ops] 
			ops[#ops] = nil
		else
			ops[#ops + 1] = tok
		end
	end

	return ops[1]
end


local sum1, sum2 = 0, 0
for line in io.lines("input.txt") do
	-- NOTE: every number appears to be a single digit in the input, yay!
	sum1 = sum1 + process1(line)
	sum2 = sum2 + process2(line)
end

print("Part 1:", sum1)
print("Part 2:", sum2)