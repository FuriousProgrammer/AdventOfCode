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

local lastPlayed
local pc = 1
while inst[pc] do
	local op = inst[pc]
	local dpc = 1

	if op.op == "snd" then
		lastPlayed = regs[op.a]
	elseif op.op == "set" then
		regs[op.a] = regs[op.b]
	elseif op.op == "add" then
		regs[op.a] = regs[op.a] + regs[op.b]
	elseif op.op == "mul" then
		regs[op.a] = regs[op.a] * regs[op.b]
	elseif op.op == "mod" then
		regs[op.a] = regs[op.a] % regs[op.b]
	elseif op.op == "rcv" then
		if regs[op.a] > 0 then
			print("Part 1:", lastPlayed)
			break
		end
	elseif op.op == "jgz" then
		if regs[op.a] > 0 then
			dpc = regs[op.b]
		end
	end

	pc = pc + dpc
end



local function co(pID, inst)
	local regs = setmetatable({}, {
		__index = function(t, i)
			if type(i) == "number" then return i end
			t[i] = 0
			return 0
		end;
	})

	regs.p = pID

	local pc = 1
	while inst[pc] do
		local op = inst[pc]
		local dpc = 1

		if op.op == "snd" then
			coroutine.yield(regs[op.a])
		elseif op.op == "set" then
			regs[op.a] = regs[op.b]
		elseif op.op == "add" then
			regs[op.a] = regs[op.a] + regs[op.b]
		elseif op.op == "mul" then
			regs[op.a] = regs[op.a] * regs[op.b]
		elseif op.op == "mod" then
			regs[op.a] = regs[op.a] % regs[op.b]
		elseif op.op == "rcv" then
			regs[op.a] = coroutine.yield()
		elseif op.op == "jgz" then
			if regs[op.a] > 0 then
				dpc = regs[op.b]
			end
		end

		pc = pc + dpc
	end
end

local queue1, queue2 = {}, {}
local part2 = 0

local prog1 = coroutine.create(co)
do
	local _, dat1 = coroutine.resume(prog1, 0, inst)
	while dat1 do
		queue2[#queue2 + 1] = dat1
		_, dat1 = coroutine.resume(prog1)
	end
end

local prog2 = coroutine.create(co)
do
	local _, dat2 = coroutine.resume(prog2, 1, inst)
	while dat2 do
		part2 = part2 + 1
		queue1[#queue1 + 1] = dat2
		_, dat2 = coroutine.resume(prog2)
	end
end

while #queue1 > 0 or #queue2 > 0 do
	while #queue1 > 0 do
		stale = false
		local _, dat1 = coroutine.resume(prog1, table.remove(queue1, 1))
		while dat1 do
			queue2[#queue2 + 1] = dat1
			_, dat1 = coroutine.resume(prog1)
		end
	end

	while #queue2 > 0 do
		local _, dat2 = coroutine.resume(prog2, table.remove(queue2, 1))
		while dat2 do
			part2 = part2 + 1
			queue1[#queue1 + 1] = dat2
			_, dat2 = coroutine.resume(prog2)
		end
	end
end

print("Part 2:", part2)