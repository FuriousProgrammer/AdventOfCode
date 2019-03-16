local inpt = io.open("input.txt")
inpt = inpt:read("*a"), inpt:close()

local f = 0
local basement

for i = 1, #inpt do
	f = f + (inpt:sub(i,i) == "(" and 1 or -1)
	if f < 0 and not basement then
		basement = i
	end
end

print("Part 1:", f)
print("Part 2:", basement)