local players, marbles

-- NOTE: really only one line of input:
for line in io.lines("input.txt") do
	players, marbles = line:match("^(%d+).-(%d+).-$")
	players, marbles = tonumber(players), tonumber(marbles)
end

local function game(players, marbles)
	local scores = {}
	local curPlayer = 0

	local ring = {value = 0}
	ring.next = ring -- clockwise
	ring.prev = ring -- counter-clockwise

	for marble = 1, marbles do
		if marble%23 == 0 then
			ring = ring.prev.prev.prev.prev.prev.prev.prev -- 7 counter-clockwise
			scores[curPlayer] = (scores[curPlayer] or 0) + marble + ring.value
			ring.next.prev = ring.prev
			ring.prev.next = ring.next
			ring = ring.next
		else
			local n = {value = marble}
			n.next = ring.next.next
			n.prev = ring.next
			n.next.prev = n
			n.prev.next = n
			ring = n
		end

		curPlayer = (curPlayer + 1)%players
	end

	local max = -math.huge
	for _, score in pairs(scores) do
		max = math.max(score, max)
	end
	return max
end

print("Part 1:", game(players, marbles))
print("Part 2:", game(players, marbles*100))