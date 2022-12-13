local root = {
	parent = nil;
	data = {};
}

local cwd = root
for line in io.lines("input.txt") do
	local cmd, dir = line:match("$ (.+) (.+)")
	if cmd and cmd == "cd" then
		if dir == "/" then
			cwd = root
		elseif dir == ".." then
			cwd = cwd.parent
		else
			cwd = cwd.data[dir]
		end
	elseif line:sub(1,1) ~= "$" then
		type, name = line:match("(.+) (.+)")
		if type == "dir" then
			cwd.data[name] = {
				parent = cwd;
				data = {};
			}
		else
			cwd.data[name] = {
				size = tonumber(type);
			}
		end
	end
end


local function GetDirSizes( cwd )
	if cwd.size then return cwd.size end
	cwd.size = 0

	for _, v in pairs(cwd.data) do
		cwd.size = cwd.size + GetDirSizes(v) 
	end
	return cwd.size
end
GetDirSizes(root)


local part1 = 0
local part2 = math.huge
local part2Min = 30000000 - (70000000 - root.size)
local function countMaxSizeDirectories( cwd )
	if not cwd.data then return end

	if cwd.size <= 100000 then
		part1 = part1 + cwd.size
	end

	if cwd.size >= part2Min then
		part2 = math.min(part2, cwd.size)
	end

	for _, v in pairs(cwd.data) do
		countMaxSizeDirectories( v )
	end
end
countMaxSizeDirectories(root)

print("Part 1: " .. part1)
print("Part 2: " .. part2)