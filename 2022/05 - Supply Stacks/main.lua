local stacks = {}
do
	-- there *should* always be spaces padding out the initial config diagram,
	-- but this code is written assuming trailing whitepsace has been truncated

	-- read all lines until first empty line, storing them in reverse order
	local lines = {}
	for line in io.lines("input.txt") do
		if line == "" then break end
		table.insert(lines, 1, line)
	end

	-- topmost line is the stack labels, always 1..n with no gaps so we only
	-- need to grab the final, largest, value to get the number of stacks
	local numstacks = table.remove(lines, 1):match("(%d+)%s*$")
	for i = 1, numstacks do
		stacks[i] = {}
	end

	-- finally, extract the characters stored in each stack, bottom-to-top
	for _, line in ipairs(lines) do
		for i = 0, numstacks-1 do
			local c = line:sub(i*4 + 2, i*4 + 2)
			
			if c and c ~= ' ' then
				table.insert(stacks[i+1], c)
			end
		end
	end
end

-- deep copy of stacks for part 2
local stacks2 = {}
for i, v in pairs(stacks) do
	stacks2[i] = {}
	for j, n in pairs(v) do
		stacks2[i][j] = n
	end
end


local tmp = {}
for line in io.lines("input.txt") do
	n, src, dst = line:match("move (%d+) from (%d+) to (%d+)")
	n, src, dst = tonumber(n) or 0, tonumber(src), tonumber(dst)

	for i = 1, n do
		table.insert( stacks[dst], table.remove(stacks[src]) )

		table.insert( tmp, table.remove(stacks2[src]) )
	end

	for i = 1, n do
		table.insert( stacks2[dst], table.remove(tmp) ) -- double reversal for part 2
	end
end


io.write("Part 1: ")
for _, s in ipairs(stacks) do
	io.write(s[#s])
end
io.write('\n')


io.write("Part 2: ")
for _, s in ipairs(stacks2) do
	io.write(s[#s])
end
io.write('\n')