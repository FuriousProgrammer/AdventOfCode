local paper = {}

local width, height
local folding = false
for line in io.lines("input.txt") do
	if line == "" then
		folding = true
	else
		if not folding then
			local x, y = line:match("(%d+),(%d+)")
			if not paper[tonumber(y)] then paper[tonumber(y)] = {} end
			paper[tonumber(y)][tonumber(x)] = true
		else
			local dir, val = line:match("([xy])=(%d+)")
			val = tonumber(val)

			if dir == "x" then
				if not width then width = val*2 end

				for y in pairs(paper) do
					for x = val + 1, width do
						if paper[y][x] then
							paper[y][2*val - x] = true
							paper[y][x] = nil
						end
					end
				end

				width = val - 1
			else --if dir == "y" then
				if not height then height = val*2 end

				for y = val + 1, height do
					if paper[y] then
						local target = 2*val - y
						if not paper[target] then paper[target] = {} end

						for x in pairs(paper[y]) do
							paper[target][x] = true
						end

						paper[y] = nil
					end
				end

				height = val - 1
			end

			if not part1 then
				part1 = 0

				for _, row in pairs(paper) do
					for _ in pairs(row) do
						part1 = part1 + 1
					end
				end

				print("Part 1:", part1)
			end

		end
	end
end

local chars = {[0]=" ", string.char(220), string.char(223), string.char(219)}

print("Part 2:")
for y = 0, height, 2 do
	for x = 0, width do
		local char = 0
		if paper[y] and paper[y][x] then
			char = char + 2
		end
		if paper[y + 1] and paper[y + 1][x] then
			char = char + 1
		end
		io.write( chars[char] )
	end
	io.write("\n")
end