local deer = {}

for line in io.lines("input.txt") do
--	Dancer can fly 27 km/s for 5 seconds, but then must rest for 132 seconds.
	local speed, active, rest = line:match("^.-(%d+) km/s for (%d+) seconds.-(%d+) seconds.$")

	deer[#deer + 1] = {
		running = true;
		speed = tonumber(speed);
		active = tonumber(active);
		rest = tonumber(rest);
		time = tonumber(active);
		score = 0;
		distance = 0;
	}
end

-- I could probably skip seconds, but it's far easier to just simulate the race!
local maxDistance = 0
local maxScore = 0

for _ = 1, 2503 do
	for _, runner in pairs(deer) do
		runner.distance = runner.distance + (runner.running and runner.speed or 0)
		runner.time = runner.time - 1
		if runner.time == 0 then
			runner.running = not runner.running
			runner.time = runner.running and runner.active or runner.rest
		end
		maxDistance = math.max(maxDistance, runner.distance)
	end

	for _, runner in pairs(deer) do
		if runner.distance == maxDistance then
			runner.score = runner.score + 1
			maxScore = math.max(maxScore, runner.score)
		end
	end
end

print("Part 1:", maxDistance)
print("Part 2:", maxScore)