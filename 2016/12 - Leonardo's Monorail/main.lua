local prog = {}

local i = 0
for line in io.lines("input.txt") do
	local op, a, b = line:match("(...) (%S*) ?(%S*)")
	prog[i] = {
		op = op;
		a = tonumber(a) and tonumber(a) or a;
		b = tonumber(b) and tonumber(b) or b;
	}
	i = i + 1
end

--[[ Attempting to run the assembunny code as provided takes a... very long time to execute, see log.txt!
local regs = {
	a = 0;
	b = 0;
	c = 0;
	d = 0;
}
local pc = 0

local function runProg()
	while true do
		local dpc = 1
		local inst = prog[pc]
		if not inst then break end

		if     inst.op == "cpy" then
			regs[inst.b] = (regs[inst.a] and regs[inst.a] or inst.a)
		elseif inst.op == "inc" then
			regs[inst.a] = regs[inst.a] + 1
		elseif inst.op == "dec" then
			regs[inst.a] = regs[inst.a] + 1
		elseif inst.op == "jnz" then
			if inst.a ~= 0 then
				dpc = inst.b -- second op is never a register :D
			end
		end

		pc = pc + dpc
	end
end

runProg()
print("Part 1:", regs.a)

regs = {
	a = 0;
	b = 0;
	c = 1;
	d = 0;
}
runProg()
print("Part 2:", regs.a)
--]]

local per_player_mod = prog[16].a*prog[17].a

local a, b = 1, 1
for _ = 1, 26 do
	a, b = a + b, a
end
print("Part 1:", a + per_player_mod)

for _ = 27, 33 do
	a, b = a + b, a
end
print("Part 2:", a + per_player_mod)

-- NOTE: I am uncertain which part of the input are modified for each users,
-- but I'm reasonably sure it's only the final two loops.