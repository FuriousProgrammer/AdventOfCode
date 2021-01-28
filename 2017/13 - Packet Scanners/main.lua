local scanners = {}
local total = 0

for line in io.lines("input.txt") do
	local depth, range = line:match("(%d+): (%d+)")
	scanners[tonumber(depth)] = {
		pos = 1;
		max = tonumber(range);
		dir = 1;
	}
	total = math.max(tonumber(depth), total)
end

local severity = 0
for i = 0, total do
	if scanners[i] and scanners[i].pos == 1 then
		severity = severity + i*scanners[i].max
	end

	for j, scanner in pairs(scanners) do
		scanner.pos = scanner.pos + scanner.dir
		if scanner.pos == 1 or scanner.pos == scanner.max then
			scanner.dir = scanner.dir*-1
		end
	end
end
print("Part 1:", severity)

-- reset scanners
for _, node in pairs(scanners) do
	node.pos = 1
	node.dir = 1
end

local packets = {}
local function step()
	for i, pos in pairs(packets) do
		if scanners[pos] and scanners[pos].pos == 1 then
			packets[i] = nil
			-- TODO: maybe find a better way to remove packets?
		else
			packets[i] = packets[i] + 1
			if packets[i] > total then
				print("Part 2:", i)
				os.exit()
			end
		end
	end

	for _, scanner in pairs(scanners) do
		scanner.pos = scanner.pos + scanner.dir
		if scanner.pos == 1 or scanner.pos == scanner.max then
			scanner.dir = scanner.dir*-1
		end
	end
end

for i = 0, math.huge do
	packets[i] = 0
	step()
end