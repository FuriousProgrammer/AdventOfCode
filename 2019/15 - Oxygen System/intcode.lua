--[[
OPCODES
Format [M+]XX
	XX: two-digit opcode
	M : (default-0) parameter modes, read right-to-left
		1: immediate mode, use parameter as value [write parameters will NEVER be in immediate mode]
		0: position mode, use parameter as address of value
		2: relative mode, same as position + relative base

01 - ADD r r w - adds first two parameters, writes result to third
02 - MUL r r w - multiplies first two parameters, writes result to third
03 - INP w     - reads interger from input, writes to first parameter
04 - OUT r     - writes first parameter to output
05 - JIT r r   - set pc to second parameter if first is non-zero
06 - JIF r r   - set pc to second parameter if first is zero
07 - TLT r r w - writes to third parameter: 1 if first is less than second, 0 otherwise
08 - TEQ r r w - writes to third parameter: 1 if first and second are equal, 0 otherwise
09 - CRB r     - adjust relative base by first parameter
99 - HLT       - halts operation

Valid address range is all positive integers.
--]]

require("bignum")
local ZERO = BigNum.new(0)
local paramCounts = {3, 3, 1, 1, 2, 2, 3, 3, 1, [99] = 0}
local function run(_prog, outputStream)
	_prog.pc = _prog.pc or ZERO
	_prog.rbase = _prog.rbase or ZERO

	local prog = setmetatable({}, {
		__index = function(t, i)
			return _prog[tostring(i)] or ZERO
		end;
		__newindex = function(t, i, v)
			if i < ZERO then error("Negative address!") end
			_prog[tostring(i)] = BigNum.new(v)
--			print(i, '=', v)
		end;
	})

	while true do
		local pc = _prog.pc
		local op = tonumber(tostring(prog[pc] % 100))
		local param = {}
		do
			local m = tostring(prog[pc]):reverse():sub(3)
			if paramCounts[op] and paramCounts[op] > 0 then
				for i = 1, paramCounts[op] do
					local mode = tonumber(m:sub(i, i)) or 0
					local value = prog[pc + i]
					if mode == 1 then
						param[i] = {val=value,addr=pc+i}
					elseif mode == 0 then
						param[i] = {val=prog[value],addr=value}
					elseif mode == 2 then
						param[i] = {val=prog[value + _prog.rbase],addr=value + _prog.rbase}
					else
						error("unknown mode: " .. mode)
					end
				end
			end
		end
--[[
		if not param[1] then param[1] = {} end
		if not param[2] then param[2] = {} end
		if not param[3] then param[3] = {} end
		print(pc, prog[pc], param[1].addr, param[1].val, param[2].addr, param[2].val, param[3].addr, param[3].val)
--]]
		local d_pc = paramCounts[op] + 1
		if     op == 01 then -- ADD r r w
			prog[param[3].addr] = param[1].val + param[2].val

		elseif op == 02 then -- MUL r r w
			prog[param[3].addr] = param[1].val * param[2].val

		elseif op == 03 then -- INP w
			-- TODO: input validation
			prog[param[1].addr] = tonumber(coroutine.yield()) or 0

		elseif op == 04 then -- OUT r
			outputStream[#outputStream + 1] = tostring(param[1].val)

		elseif op == 05 then -- JIT r r
			if param[1].val ~= ZERO then
				pc = param[2].val
				d_pc = 0
			end

		elseif op == 06 then -- JIF r r
			if param[1].val == ZERO then
				pc = param[2].val
				d_pc = 0
			end

		elseif op == 07 then -- TLT r r w
			prog[param[3].addr] = param[1].val < param[2].val and 1 or 0

		elseif op == 08 then -- TEQ r r w
			prog[param[3].addr] = param[1].val == param[2].val and 1 or 0

		elseif op == 09 then -- CRB r
			_prog.rbase = _prog.rbase + param[1].val

		elseif op == 99 then -- HLT
			break
		else
			error(string.format("Invalid opcode %d @ %d", prog[pc], pc))
			break
		end
		_prog.pc = pc + d_pc
	end
end

-- TODO: wrap this in something to make it cleaner maybe?
return function(prog, outputStream)
	if type(outputStream) ~= "table" then error("Missing or invalid outputStream!") end
	local co = coroutine.create(run)
	return co, coroutine.resume(co, prog, outputStream)
end