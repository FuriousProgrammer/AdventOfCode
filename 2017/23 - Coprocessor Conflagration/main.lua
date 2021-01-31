local inst = {}

for line in io.lines("input.txt") do
	local op, a, b = line:match("(...) (%-?%w+) ?(%-?%w*)")
	inst[#inst + 1] = {
		op = op;
		a = tonumber(a) and tonumber(a) or a;
		b = tonumber(b) and tonumber(b) or b;
	}
end


local regs = setmetatable({}, {
	__index = function(t, i)
		if type(i) == "number" then return i end
		t[i] = 0
		return 0
	end;
})

local part1 = 0
local pc = 1
while inst[pc] do
	local op = inst[pc]
	local dpc = 1

	if op.op == "set" then
		regs[op.a] = regs[op.b]
	elseif op.op == "sub" then
		regs[op.a] = regs[op.a] - regs[op.b]
	elseif op.op == "mul" then
		part1 = part1 + 1
		regs[op.a] = regs[op.a] * regs[op.b]
	elseif op.op == "jnz" then
		if regs[op.a] ~= 0 then
			dpc = regs[op.b]
		end
	end

	pc = pc + dpc
end

print("Part 1:", part1)


local low = 100000 + 100*inst[1].b
local high = low + 17000
local part2 = 0

for b = low, high, 17 do
	local f = false

--[[for d = 2, b do
		for e = 2, b do
			if d*e == b then
				f = true
				break
			end
		end

		if f then break end
	end

	if f then
		part2 = part2 + 1
	end
--]]

	for d = 2, math.sqrt(b) do
		if b%d == 0 then
			part2 = part2 + 1
			break
		end
	end
end

print("Part 2:", part2)