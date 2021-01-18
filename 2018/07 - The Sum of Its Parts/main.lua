local steps = setmetatable({}, {
	__index = function(t, i)
		t[i] = {requires = {}, time = 61 + string.byte(i) - string.byte('A')}
		return t[i]
	end;
})

for line in io.lines("input.txt") do
	local pre, step = line:match("Step (.) must be finished before step (.) can begin%.")
	table.insert(steps[step].requires, pre)
	steps[pre] = steps[pre] -- trigger the __index
end

-- Part 1:
local ready = {}
local queue = {}
for step in pairs(steps) do
	queue[#queue + 1] = step
end
table.sort(queue)

local function getNextReady()
	for i, step in ipairs(queue) do
		local isReady = true
		for _, check in pairs(steps[step].requires) do
			if not ready[check] then
				isReady = false
				break
			end
		end
		if isReady then
			return table.remove(queue, i)
		end
	end
	return nil
end

local part1 = ""
while #queue > 0 do
	local step = getNextReady()
	part1 = part1 .. step
	ready[step] = true
end
print("Part 1:", part1)

-- Part 2:
ready, queue = {}, {}
for step in pairs(steps) do
	queue[#queue + 1] = step
end
table.sort(queue)

local workers = {}
for i = 1, 5 do
	workers[i] = {
		step = nil;
		time = math.huge;
	}
end

local time = 0
while #queue > 0 do
	local timeStep = math.huge
	for _, worker in pairs(workers) do
		if not worker.step then
			local s = getNextReady()
			if s then
				worker.step = s
				worker.time = steps[s].time
			end
		end
		timeStep = math.min(timeStep, worker.time)
	end
	time = time + timeStep
	for _, worker in pairs(workers) do
		if worker.step then
			worker.time = worker.time - timeStep
			if worker.time == 0 then
				ready[worker.step] = true
				worker.step = nil
				worker.time = math.huge
			end
		end
	end
end

print("Part 2:", time)