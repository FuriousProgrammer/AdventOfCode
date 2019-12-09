--[[
OPCODES
Format [M+]XX
	XX: two-digit opcode
	M : (default-0) parameter modes, read right-to-left
		1: immediate mode, use parameter as value [write parameters will NEVER be in immediate mode]
		0: position mode, use parameter as address of value

01 - ADD r r w - adds first two parameters, writes result to third
02 - MUL r r w - multiplies first two parameters, writes result to third
03 - INP w     - reads interger from input, writes to first parameter
04 - OUT r     - writes first parameter to output
05 - JIT r r   - set pc to second parameter if first is non-zero
06 - JIF r r   - set pc to second parameter if first is zero
07 - TLT r r w - writes to third parameter: 1 if first is less than second, 0 otherwise
08 - TEQ r r w - writes to third parameter: 1 if first and second are equal, 0 otherwise
99 - HLT       - halts operation

Valid address range is 0..#prog
--]]

-- TODO: move input and output streams to external code
local paramCounts = {3, 3, 1, 1, 2, 2, 3, 3, [99] = 0}
return function(prog, inputStream, outputStream)
	local inputN = 1
	local pc = 0

	while true do
		local op = prog[pc] % 100
		local param = {}
		do
			local m = tostring(prog[pc]):reverse():sub(3)
			if paramCounts[op] and paramCounts[op] > 0 then
				for i = 1, paramCounts[op] do
					local mode = tonumber(m:sub(i, i)) or 0
					local value = prog[pc + i]
					param[i] = mode == 1 and value or prog[value]
				end
			end
		end

--		print(op, table.concat(param, ', '))

		local d_pc = paramCounts[op] + 1
		if     op == 01 then -- ADD r r w
			prog[prog[pc + 3]] = param[1] + param[2]

		elseif op == 02 then -- MUL r r w
			prog[prog[pc + 3]] = param[1] * param[2]

		elseif op == 03 then -- INP w
			-- TODO: input validation
			io.write("Input: ")
			if not inputStream or inputN > #inputStream then
				prog[prog[pc + 1]] = tonumber(io.read()) or 0
			else
				prog[prog[pc + 1]] = inputStream[inputN]
				print(inputStream[inputN])
				inputN = inputN + 1
			end

		elseif op == 04 then -- OUT r
			if not outputStream then
				io.write("> ", param[1], '\n')
			else
				outputStream[#outputStream + 1] = param[1]
			end

		elseif op == 05 then -- JIT r r
			if param[1] ~= 0 then
				pc = param[2]
				d_pc = 0
			end

		elseif op == 06 then -- JIF r r
			if param[1] == 0 then
				pc = param[2]
				d_pc = 0
			end

		elseif op == 07 then -- TLT r r w
			prog[prog[pc + 3]] = param[1] < param[2] and 1 or 0

		elseif op == 08 then -- TEQ r r w
			prog[prog[pc + 3]] = param[1] == param[2] and 1 or 0

		elseif op == 99 then -- HLT
			break
		else
			error(string.format("Invalid opcode %d @ %d", prog[pc], pc))
		end
		pc = pc + d_pc
	end
end