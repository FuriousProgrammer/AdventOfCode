local data = io.open("inpt.txt"):read("*a")

local progbase = {}
local pc = 0
for d in data:gmatch("%d+") do
	progbase[pc] = tonumber(d)
	pc = pc + 1
end

local function run(noun, verb)
	local prog = {}
	for i, v in pairs(progbase) do
		prog[i] = v
	end
	pc = 0

	prog[1] = noun
	prog[2] = verb

	while true do
		local op, a1, a2, a3 = prog[pc], prog[pc + 1], prog[pc + 2], prog[pc + 3]
		-- todo: disassemble visualization?
		if op == 99 then
			-- HLT
--			print("Halting!")
			break
		elseif op == 1 then
			-- ADD i i o
			prog[a3] = (prog[a1] or 0) + (prog[a2] or 0)
		elseif op == 2 then
			-- MUL i i o
			prog[a3] = (prog[a1] or 0) * (prog[a2] or 0)
		else
			-- HCF
--			print(string.format("Illegal opcode %d @ %X with args %X %X %X", op, pc, a1, a2, a3))
			break
		end
		pc = pc + 4
	end

	return prog[0]
end

print("Part 1", run(12, 2))

-- noun is some strictly-increasing multiplicative base, verb simply gets added to the result of that.
-- However, that produces an invalid checksum with a low verb (as well as an infinite set of valid checksums!),
--   so I'm assuming that any address not in the initial program is out of bounds, as it would cause the first instruction to crash
local size = #progbase - 1
local target = 19690720

for noun = 0, size do
	local r = run(noun, 0)
	if r > target then break end
	if target - r <= size then
		print("Part 2", 100*noun + (target - r))
	end
end