-- NOTE: Luajit's and older version of Lua's `tonumber` doesn't work correctly for numbers with more than 32 bits!
local tonumber = function(n)
	local res = 0
	local base = 1
	for i = #n, 1, -1 do
		if n:sub(i,i) == '1' then
			res = res + base
		end
		base = base*2
	end
	return res
end

local function parse(packet)
	if #packet < 6 then
		return nil, 0
	end

	local node = {
		version = tonumber(packet:sub(1,3), 2);
		type = tonumber(packet:sub(4,6), 2);
		subpackets = {};
	}
	packet = packet:sub(7)

	if node.type == 4 then
		local num = {}
		while true do
			local last = packet:sub(1,1) == '0'
			table.insert(num, packet:sub(2,5))
			packet = packet:sub(6)
			if last then break end
		end

		node.value = tonumber(table.concat(num), 2)

	else
		lengthType = packet:sub(1,1)
		packet = packet:sub(2)

		if lengthType == '0' then -- next **15** bits are the *length in bits* of all contained sub-packets
			local length = tonumber(packet:sub(1,15), 2)
			local data = packet:sub(16, 15 + length)
			packet = packet:sub(16 + length)

			while #data > 0 do
				local newNode
				newNode, data = parse(data)
				table.insert(node.subpackets, newNode)
			end

		else -- next **11** bits are the *number* of contained sub-packets
			local count = tonumber(packet:sub(1,11), 2)
			packet = packet:sub(12)

			for i = 1, count do
				local newNode
				newNode, packet = parse(packet)
				table.insert(node.subpackets, newNode)
			end

		end


	end

	return node, packet
end

local _eval
local function eval(node)
	return _eval[node.type](node)
end

local index = 0
_eval = {
	-- Sum
	[0] = function(node)
		local res = 0
		for _, sub in pairs(node.subpackets) do
			res = res + eval(sub)
		end
		return res
	end;

	-- Product
	[1] = function(node)
		local res = 1
		for _, sub in pairs(node.subpackets) do
			res = res*eval(sub)
		end
		return res
	end;

	-- Minimum
	[2] = function(node)
		local min = math.huge
		for _, sub in pairs(node.subpackets) do
			min = math.min(min, eval(sub))
		end
		return min
	end;

	-- Maximum
	[3] = function(node)
		local max = -math.huge
		for _, sub in pairs(node.subpackets) do
			max = math.max(max, eval(sub))
		end
		return max
	end;

	-- Literal value
	[4] = function(node)
		return node.value
	end;

	-- Greater than
	[5] = function(node)
		assert(#node.subpackets == 2)
		return eval(node.subpackets[1]) > eval(node.subpackets[2]) and 1 or 0
	end;

	-- Less than
	[6] = function(node)
		assert(#node.subpackets == 2)
		return eval(node.subpackets[1]) < eval(node.subpackets[2]) and 1 or 0
	end;

	-- Equal to
	[7] = function(node)
		assert(#node.subpackets == 2)
		return eval(node.subpackets[1]) == eval(node.subpackets[2]) and 1 or 0
	end;
}

local hex2bin = {
	['0'] = "0000";
	['1'] = "0001";
	['2'] = "0010";
	['3'] = "0011";
	['4'] = "0100";
	['5'] = "0101";
	['6'] = "0110";
	['7'] = "0111";
	['8'] = "1000";
	['9'] = "1001";
	['A'] = "1010";
	['B'] = "1011";
	['C'] = "1100";
	['D'] = "1101";
	['E'] = "1110";
	['F'] = "1111";
}

local function process(input)
	local bits = {}
	for c in input:gmatch(".") do
		table.insert(bits, hex2bin[c])
	end
	bits = table.concat(bits)

	local tree = parse(bits)

	local versionSum = 0
	local function recurse(node)
		versionSum = versionSum + node.version
		for _, node in pairs(node.subpackets) do
			recurse(node)
		end
	end
	recurse(tree)

	return versionSum, eval(tree)
end

--[[
assert( process("8A004A801A8002F478") == 16 )
assert( process("620080001611562C8802118E34") == 12 )
assert( process("C0015000016115A2E0802F182340") == 23 )
assert( process("A0016C880162017C3686B18A3D4780") == 31 )

assert( select(2, process("C200B40A82")) == 3)
assert( select(2, process("04005AC33890")) == 54)
assert( select(2, process("880086C3E88112")) == 7)
assert( select(2, process("CE00C43D881120")) == 9)
assert( select(2, process("D8005AC2A8F0")) == 1)
assert( select(2, process("F600BC2D8F")) == 0)
assert( select(2, process("9C005AC2F8F0")) == 0)
assert( select(2, process("9C0141080250320F1802104A08")) == 1 )
--]]

local input = io.open("input.txt"):read("*l")
local vsum, val = process(input)
print("Part 1:", vsum)
print("Part 2:", val)