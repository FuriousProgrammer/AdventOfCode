-- 1) Sort input chronologically
local data = {}

for line in io.lines("input.txt") do
	-- [YYYY-MM-DD HH:MM] <text>
	-- YYYY is always 1518
	-- HH is either 23 or 00
	-- text is one of: "wakes up", "falls asleep", "Guard #<guardID> begins shift"
	-- NOTE: "falls asleep" and "wakes up" never occur when HH is 23

	local month, day, hour, minute, text = line:match("^%[%d%d%d%d%-(%d%d)%-(%d%d) (%d%d):(%d%d)%] (.+)$")
	data[#data + 1] = {
		month = tonumber(month),
		day = tonumber(day) + (hour == "00" and 0 or 1),
		text = text,
		minute = tonumber(minute) - (hour == "00" and 0 or 60),
--		line = line
	}
end

table.sort(data, function(a, b)
	-- NOTE: I could probably refactor this, but the logic is clear and the input is relatively tiny so it's moot.
	if a.month < b.month then
		return true
	elseif a.month == b.month then
		if a.day < b.day then
			return true
		elseif a.day == b.day then
			return a.minute < b.minute
		end
	end
	return false
end)

--[[ also uncomment line 17!
-- log.txt
for _, row in ipairs(data) do
	print(row.line)
end
os.exit()
--]]



-- 2) Construct per-minute sleep schedule for each shift, stored under the on-duty guard's ID
local guards = {}
local i = 1

while i < #data do
	local guardID = data[i].text:match("(%d+)")

	local shift = {
--		date = data[i].month .. "-" .. data[i].day
	}
	if not guards[guardID] then
		guards[guardID] = {shift}
	else
		table.insert(guards[guardID], shift)
	end

	local minute = 0
	local awake = true
	while true do
		i = i + 1
		if i > #data or data[i].text:find("Guard") then break end

		for j = minute, data[i].minute-1 do
			shift[j] = awake
		end
		awake = not awake
		minute = data[i].minute
	end
	for j = minute, 59 do
		shift[j] = awake
	end
end

--[[ also uncomment line 53!
-- log2.txt
for guardID, shifts in pairs(guards) do
	print("Shift for Guard #" .. guardID)
	print("000000000011111111112222222222333333333344444444445555555555")
	print("012345678901234567890123456789012345678901234567890123456789")
	for _, shift in pairs(shifts) do
		for i = 0, 59 do
			io.write(shift[i] and '.' or '#')
		end
		print("", shift.date)
	end
	print()
end
os.exit()
--]]

-- 3) Part 1
-- 3a) find guard that slept the most
local max, maxID = -math.huge

for id, shifts in pairs(guards) do
	local asleepTime = 0
	for _, shift in pairs(shifts) do
		for m = 0, 59 do
			asleepTime = asleepTime + (shift[m] and 0 or 1)
		end
	end
	if asleepTime > max then
		max = asleepTime
		maxID = id
	end
end
-- 3b) report the minute they most frequently slept on
local counts = {}
for _, shift in pairs(guards[maxID]) do
	for m = 0, 59 do
		counts[m] = (counts[m] or 0) + (shift[m] and 0 or 1)
	end
end

local max, maxMinute = -math.huge
for minute, count in pairs(counts) do
	if count > max then
		max = count
		maxMinute = minute
	end
end

print("Part 1:", maxMinute*maxID)


-- 4) Part 2
counts = {}
for m = 0, 59 do
	counts[m] = {max = -math.huge, maxID = nil}
end

for guardID, shifts in pairs(guards) do
	local subCounts = {}
	for _, shift in pairs(shifts) do
		for m = 0, 59 do
			subCounts[m] = (subCounts[m] or 0) + (shift[m] and 0 or 1)
		end
	end

	for m = 0, 59 do
		if counts[m].max < subCounts[m] then
			counts[m].max = subCounts[m]
			counts[m].maxID = guardID
		end
	end
end

max, maxMinute = -math.huge
for minute, data in pairs(counts) do
	if data.max > max then
		max = data.max
		maxMinute = minute
	end
end

print("Part 2:", maxMinute*counts[maxMinute].maxID)