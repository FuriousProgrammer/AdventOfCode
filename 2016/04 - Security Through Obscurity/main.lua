local sum = 0
local secretRoomID = 0

for line in io.lines("input.txt") do
	local txt, sector, checksum = line:match("^(.-)%-(%d+)%[(.+)%]$")
	sector = tonumber(sector)

	local counts = {}
	local sortable = {}
	local decrypted = {}
	for c in txt:gmatch(".") do
		if c == "-" then
			decrypted[#decrypted + 1] = " "
		else
			decrypted[#decrypted + 1] = string.char( (string.byte(c) - string.byte('a') + sector)%26 + string.byte('a') )
			if not counts[c] then
				counts[c] = {letter = c, count = 1}
				sortable[#sortable + 1] = counts[c]
			else
				counts[c].count = counts[c].count + 1
			end
		end
	end

	table.sort(sortable, function(a, b)
		if a.count > b.count then
			return true
		elseif a.count == b.count then
			return a.letter < b.letter
		end
		return false
	end)

	local real = true
	local i = 1
	for c in checksum:gmatch('.') do
		if not sortable[i] or sortable[i].letter ~= c then
			real = false
			break
		end
		i = i + 1
	end

	if real then
		sum = sum + sector
		if table.concat(decrypted):find("north") then
			secretRoomID = sector
		end
	end
end

print("Part 1:", sum)
print("Part 2:", secretRoomID)