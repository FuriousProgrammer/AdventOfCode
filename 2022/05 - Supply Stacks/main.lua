-- TODO: read initial configuration from input.txt
local stacks = {
	{'H', 'T', 'Z', 'D'};
	{'Q', 'R', 'W', 'T', 'G', 'C', 'S'};
	{'P', 'B', 'F', 'Q', 'N', 'R', 'C', 'H'};
	{'L', 'C', 'N', 'F', 'H', 'Z'};
	{'G', 'L', 'F', 'Q', 'S'};
	{'V', 'P', 'W', 'Z', 'B', 'R', 'C', 'S'};
	{'Z', 'F', 'J'};
	{'D', 'L', 'V', 'Z', 'R', 'H', 'Q'};
	{'B', 'H', 'G', 'N', 'F', 'Z', 'L', 'D'};
}

local stacks2 = {
	{'H', 'T', 'Z', 'D'};
	{'Q', 'R', 'W', 'T', 'G', 'C', 'S'};
	{'P', 'B', 'F', 'Q', 'N', 'R', 'C', 'H'};
	{'L', 'C', 'N', 'F', 'H', 'Z'};
	{'G', 'L', 'F', 'Q', 'S'};
	{'V', 'P', 'W', 'Z', 'B', 'R', 'C', 'S'};
	{'Z', 'F', 'J'};
	{'D', 'L', 'V', 'Z', 'R', 'H', 'Q'};
	{'B', 'H', 'G', 'N', 'F', 'Z', 'L', 'D'};
}

for line in io.lines("input.txt") do
	n, src, dst = line:match("move (%d+) from (%d+) to (%d+)")
	n, src, dst = tonumber(n) or 0, tonumber(src), tonumber(dst)

	local tmp = {}
	for i = 1, n do
		table.insert( stacks[dst], table.remove(stacks[src]) )

		table.insert( tmp, table.remove(stacks2[src]) )
	end

	for i = 1, n do
		table.insert( stacks2[dst], table.remove(tmp) )
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