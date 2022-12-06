local inpt = io.open("input.txt"):read("*l")

-- No reason to be clever, this completes basically instantly even without the early out!
for i = 4, #inpt do
	local packet = inpt:sub(i-3, i)
	if not packet:find("(.).*(%1)") then
		print("Part 1: " .. i)
		break
	end
end

for i = 14, #inpt do
	local packet = inpt:sub(i-13, i)
	if not packet:find("(.).*(%1)") then
		print("Part 2: " .. i)
		break
	end
end