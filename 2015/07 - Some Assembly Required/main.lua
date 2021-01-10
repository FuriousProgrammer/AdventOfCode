local bit = require("bit") -- LuaJIT BitOp

local wires = {}

local function wirein(req, n)
	local arg = tonumber(n)
	if arg then return {value = arg} end
	req[#req + 1] = n
	return n
end

for line in io.lines("input.txt") do
	local input, wire = line:match("(.+) %-> (.+)")
	local req = {}
	local OP -- = {} -- OP, arg1, arg2


	local a, b, c = input:match("(.+) (.+) (.+)")
	local d = input:match("NOT (.+)")
	if a then -- 2-arg check
		OP = {
			OP = b;
			a1 = wirein(req, a);
			a2 = wirein(req, c);
		}
	elseif d then -- NOT check
		OP = {
			OP = "NOT";
			a1 = wirein(req, d);
			a2 = 0
		}
	else -- must be direct assignment!
		OP = {
			OP = "ASSIGN";
			a1 = wirein(req, input);
			a2 = 0;
		}
	end

	wires[wire] = {
		op = OP;
		value = nil;
		requires = req;
	}
end

for _, wire in pairs(wires) do
	if wires[wire.op.a1] then
		wire.op.a1 = wires[wire.op.a1]
	end
	if wires[wire.op.a2] then
		wire.op.a2 = wires[wire.op.a2]
	end
end

local function resolve(wire)
	wire = wires[wire]
	if wire.value then return end
	for _, s in pairs(wire.requires) do
		resolve(s)
	end

	if wire.op.OP == "ASSIGN" then
		wire.value = wire.op.a1.value
	elseif wire.op.OP == "NOT" then
		wire.value = bit.bnot(wire.op.a1.value)
	elseif wire.op.OP == "LSHIFT" then
		wire.value = bit.lshift(wire.op.a1.value, wire.op.a2.value)
	elseif wire.op.OP == "RSHIFT" then
		wire.value = bit.rshift(wire.op.a1.value, wire.op.a2.value)
	elseif wire.op.OP == "AND" then
		wire.value = bit.band(wire.op.a1.value, wire.op.a2.value)
	elseif wire.op.OP == "OR" then
		wire.value = bit.bor(wire.op.a1.value, wire.op.a2.value)
	end

	wire.value = bit.band(wire.value, 0xFFFF)
end

resolve('a')
local a = wires.a.value
print("Part 1:", a)

for _, wire in pairs(wires) do
	wire.value = nil
end
wires['b'].value = a

resolve('a')
print("Part 2:", wires.a.value)