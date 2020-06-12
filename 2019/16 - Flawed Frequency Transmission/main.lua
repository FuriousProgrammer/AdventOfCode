local inpt = io.open("inpt.txt"):read("*a")

local data = {}
for i = 1, #inpt do
	data[i] = tonumber(inpt:sub(i,i))
end

local n = {}
for _ = 1, 100 do
	-- Front half:
	for op = 1, #data/2 do
		local s = 0
		for offset = 0, op - 1 do
			local pos = op + offset
--				print(pos, op, offset)
			while pos <= #data do
				s = s + data[pos]
				pos = pos + 4*op
			end
			pos = 3*op + offset
			while pos <= #data do
				s = s - data[pos]
				pos = pos + 4*op
			end
		end

		n[op] = math.abs(s)%10
	end
	-- Back half:
	n[#data] = data[#data]
	for pos = #data - 1, #data/2 + 1, -1 do
		n[pos] = (data[pos] + n[pos + 1])%10
	end
	data,n = n,data
end


local p1 = ""
for i = 1, 8 do
	p1 = p1 .. data[i]
end
print("Part 1:", p1)

-- I spent *way* too much time on this. For some ungodly reason I misread the offset as being the *output* first 7 digits.
-- It took that number being completely out of range for me to notice my mistake.

local offset = tonumber(inpt:sub(1,7))

inpt = inpt:rep(10000):sub(offset+1)
data = {}
for i = 1, #inpt do
	data[i] = tonumber(inpt:sub(i,i))
end

local n = {}
for _ = 1, 100 do
	n[#data] = data[#data]
	for pos = #data - 1, 1, -1 do
		n[pos] = (data[pos] + n[pos + 1])%10
	end
	data,n = n,data	
end

local p2 = ""
for i = 1, 8 do
	p2 = p2 .. data[i]
end
print("Part 2:", p2)