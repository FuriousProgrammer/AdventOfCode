local file = io.open("input.txt")

local calls = file:read("*l")
file:read("*l")
local boards = {}

local line
while true do
	local nboard = {{},{},{},{},{}}
	for i = 1, 5 do
		line = file:read("*l")
		if not line then break end

		for n in line:gmatch("%d+") do
			table.insert(nboard[i], {mark = false, n = tonumber(n)})
		end
	end
	if not line then break end
	file:read("*l")

	table.insert(boards, nboard)
end


local function boardHasWon(board, x, y)
	local won = true
	for cy = 1, 5 do
		if not board[cy][x].mark then
			won = false
			break
		end
	end
	if won then return true end

	for cx = 1, 5 do
		if not board[y][cx].mark then
			return false
		end
	end
	return true
end

local function winScore(board, n)
	local score = 0

	for y = 1, 5 do
		for x = 1, 5 do
			if not board[y][x].mark then
				score = score + board[y][x].n
			end
		end
	end

	return score*n
end

local part1 = false
for n in calls:gmatch("%d+") do
	local n = tonumber(n)

	local i = 1
	while true do
		local kill = false
		local board = boards[i]
		if not board then break end

		for y = 1, 5 do
			for x = 1, 5 do
				if board[y][x].n == n then
					board[y][x].mark = true
					if boardHasWon(board, x, y) then
						if not part1 then
							part1 = true
							print("Part 1:", winScore(board, n))
						end
						if #boards > 1 then
							kill = true
							table.remove(boards, i)
						else
							print("Part 2:", winScore(board, n))
							os.exit()
						end
					end
				end
			end
		end

		if not kill then
			i = i + 1
		end
	end
end