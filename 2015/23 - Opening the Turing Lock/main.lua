local inst = {}

for line in io.lines("input.txt") do
	local op, rest = line:match("(...) (.+)")
	local a, b

	if op == "jmp" then
		a = tonumber(rest:match("[%+%-]?%d+"))
	elseif op:find("ji") then
		a, b = rest:match("(%a), ([%+%-]?%d+)")
		b = tonumber(b)
	else
		a = rest:match("%a")
	end

	inst[#inst + 1] = {op=op, a=a, b=b}
end


local regs = {a=0, b=0}
local pc = 1

local function runProg()
	while inst[pc] do
		local op = inst[pc]
		local dpc = 1

		if op.op == "hlf" then
			regs[op.a] = math.floor(regs[op.a]/2)
		elseif op.op == "tpl" then
			regs[op.a] = regs[op.a]*3
		elseif op.op == "inc" then
			regs[op.a] = regs[op.a] + 1
		elseif op.op == "jmp" then
			dpc = op.a
		elseif op.op == "jie" then
			if regs[op.a]%2 == 0 then
				dpc = op.b
			end
		elseif op.op == "jio" then
			if regs[op.a] == 1 then
				dpc = op.b
			end
		end

		pc = pc + dpc
	end
end

runProg()
print("Part 1:", regs.b)

regs.a = 1
regs.b = 0
pc = 1
runProg()
print("Part 2:", regs.b)