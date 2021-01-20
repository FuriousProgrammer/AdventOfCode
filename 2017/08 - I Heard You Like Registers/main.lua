local regs = setmetatable({}, {
	__index = function(t, i)
		t[i] = 0;
		return t[i];
	end;
})

local ops = {
	["=="] = function(a, b)
		return a == b
	end;
	["!="] = function(a, b)
		return a ~= b
	end;
	["<"] = function(a, b)
		return a < b
	end;
	[">"] = function(a, b)
		return a > b
	end;
	["<="] = function(a, b)
		return a <= b
	end;
	[">="] = function(a, b)
		return a >= b
	end;
}

local max2 = 0
for line in io.lines("input.txt") do
	--q inc -541 if c != 4
	local reg, inc, by, check, op, val = line:match("^(%a+) (%a+) (%-?%d+) if (%a+) (..?) (%-?%d+)$")
	by = tonumber(by)*(inc == "inc" and 1 or -1)
	val = tonumber(val)

	if ops[op](regs[check], val) then
		regs[reg] = regs[reg] + by
	end

	max2 = math.max(regs[reg], max2)
end

local max = 0
for _, val in pairs(regs) do
	max = math.max(val, max)
end

print("Part 1:", max)
print("Part 2:", max2)