local pieces = {}

local piece
for line in io.lines("input.txt") do
	if not piece then
		piece = {data = {}}
		piece.tile = line:match("Tile (%d+):")
		pieces[#pieces + 1] = piece
	elseif line == "" then
		local dat = piece.data
		local a, b = "", ""
		for i = 1, #dat do
			a = a .. dat[i][1]
			b = b .. dat[i][#dat[i]]
		end
		piece.borders = {table.concat(dat[1]), table.concat(dat[#dat]), a, b} -- top, bottom, left, right
		piece = nil
	else
		local row = {}
		piece.data[#piece.data + 1] = row
		for c in line:gmatch(".") do
			row[#row + 1] = c
		end
	end
end

local rev = string.reverse

local part1 = 1
for i = 1, #pieces do
	local mine = pieces[i]
	local matches = {0,0,0,0}
	for bor, der in pairs(mine.borders) do
		for j = i, #pieces do
			for _, check in pairs(pieces[j].borders) do
				if der == check or der == rev(check) then
--					assert(matches[bor] == 0)
					matches[bor] = pieces[j].tile
				end
			end
		end
	end

	local c = 0
	for _, v in pairs(matches) do
		if v ~= 0 then c = c + 1 end
	end
	if c == 2 then part1 = part1*mine.tile end
end

print("Part 1:", part1)