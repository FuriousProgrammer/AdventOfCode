-- TODO: parse input.txt instead of hardcoding everything.

local steps = 12368930

local states = {
	a = {
		[0] = {
			out = 1,
			move = 1,
			next = 'b'
		},
		[1] = {
			out = 0,
			move = 1,
			next = 'c'
		},
	};
	b = {
		[0] = {
			out = 0,
			move = -1,
			next = 'a'
		},
		[1] = {
			out = 0,
			move = 1,
			next = 'd'
		},
	};
	c = {
		[0] = {
			out = 1,
			move = 1,
			next = 'd'
		},
		[1] = {
			out = 1,
			move = 1,
			next = 'a'
		},
	};
	d = {
		[0] = {
			out = 1,
			move = -1,
			next = 'e'
		},
		[1] = {
			out = 0,
			move = -1,
			next = 'd'
		},
	};
	e = {
		[0] = {
			out = 1,
			move = 1,
			next = 'f'
		},
		[1] = {
			out = 1,
			move = -1,
			next = 'b'
		},
	};
	f = {
		[0] = {
			out = 1,
			move = 1,
			next = 'a'
		},
		[1] = {
			out = 1,
			move = 1,
			next = 'e'
		},
	};
}

local tape = {}
local pos = 0
local state = 'a'

for i = 1, steps do
	local op = states[state][tape[pos] or 0]
	tape[pos] = op.out
	pos = pos + op.move
	state = op.next
end

local total = 0
for _, v in pairs(tape) do
	total = total + v
end
print("Part 1:", total)
print("Part 2:", "Admire the Circuit!")