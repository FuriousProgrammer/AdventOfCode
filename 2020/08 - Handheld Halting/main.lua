local inst = {}

for line in io.lines("input.txt") do
	local op, arg = line:match("(...) (.%d+)")
	inst[#inst + 1] = {op=op;arg=tonumber(arg)}
end

local op, acc = 1, 0
while true do
	if inst[op].visited1 then break end

	inst[op].visited1 = true
	if inst[op].op == "acc" then
		acc = acc + inst[op].arg
		op = op + 1
	elseif inst[op].op == "jmp" then
		op = op + inst[op].arg
	else
		op = op + 1
	end
end

print("Part 1:", acc)

local pc, acc = 1, 0
local flip, pc_b, acc_b = false
local visited, visited_b = {}
local skip = false

while true do
	if pc == #inst + 1 then break end
	if pc > #inst + 1 or visited[pc] then
--		print("resetting", pc)
		pc, acc, visited = pc_b, acc_b, visited_b
		skip = true
		flip = false
	end

	local OP, ARG = inst[pc].op, inst[pc].arg
	visited[pc] = true

--	print(pc, OP, ARG, skip, flip)

	if OP == "acc" then
		acc = acc + ARG
	elseif skip or flip then
		skip = false
		if OP == "jmp" then
			pc = pc - 1 + ARG
		end
	else
--		print("flipping", pc)
		flip = true
		acc_b, pc_b = acc, pc
		visited_b = {}
		for i, v in pairs(visited) do
			visited_b[i] = v
		end
		visited_b[pc] = false
		if OP == "nop" then
			pc = pc - 1 + ARG
		end
	end

	pc = pc + 1
end

print("Part 2:", acc)