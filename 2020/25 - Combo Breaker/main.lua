local file = io.open("input.txt")
local publicCard = tonumber(file:read("*l"))
local publicDoor = tonumber(file:read("*l"))
file:close()

local subject = 7
local i = 0
while subject ~= publicCard do
	i = i + 1
	subject = (subject*7)%20201227
end
subject = publicDoor

for j = 1, i do
	subject = (subject*publicDoor)%20201227
end

print("Part 1:", subject)