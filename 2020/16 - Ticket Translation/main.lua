local fields = {}
local yours

local file = io.open("input.txt")

while true do
	local field, min1, max1, min2, max2 = file:read("*l"):match("^(.-): (%d+)%-(%d+) or (%d+)%-(%d+)")
	if not field then break end

	fields[#fields + 1] = {
		field = field;
		min1 = tonumber(min1);
		max1 = tonumber(max1);
		min2 = tonumber(min2);
		max2 = tonumber(max2); 
		solved = false;
	}
end

file:read("*l*l")
yours = file:read("*l")
file:read("*l*l")

local function find(t, v)
	for i, check in pairs(t) do
		if v == check then
			return i
		end
	end
	return nil
end
local ticketFields

local errors = 0
local function validate(line)
	local ticket = {}
	local valid = true

	for n in line:gmatch("(%d+)") do
		n = tonumber(n)
		local row = {}
		ticket[#ticket + 1] = row

		for fieldID, field in pairs(fields) do
			if (n >= field.min1 and n <= field.max1) or (n >= field.min2 and n <= field.max2) then
				row[#row + 1] = fieldID
			end
		end

		if #row == 0 then
			errors = errors + n
			valid = false
		end
	end

	if not valid then return end

	if not ticketFields then ticketFields = ticket return end

	for ticketID, data in pairs(ticket) do
		local n = {}
		local check = ticketFields[ticketID]

		for _, fieldID in pairs(data) do
			if find(check, fieldID) then
				n[#n + 1] = fieldID
			end
		end

		ticketFields[ticketID] = n
	end
end

-- NOTE: the problem doesn't state whether YOUR ticket should be considered valid!
-- I'm ASSUMING that it *is* a valid ticket, for a lil extra data! :D
validate(yours)

while true do
	line = file:read("*l")
	if not line then break end
	validate(line)
end

print("Part 1:", errors)


local stale = false
while not stale do
	stale = true
	for ticketID, data in ipairs(ticketFields) do -- ipairs to avoid undefined behavior from changing ticketFields during iteration!
		if #data ~= 0 then
			local n = {}

			for _, fieldID in pairs(data) do
				if not fields[fieldID].solved then
					n[#n + 1] = fieldID
				end
			end

			if #n == 1 then
				fields[n[1]].solved = ticketID
				n = {}
				stale = false
			end
			ticketFields[ticketID] = n
		end
	end
end
-- NOTE: my inputs (and likely ALL inputs) trivially reduce fully in the above loop, so no guess-and-check (or other, smarter algorithm) necessary!


local yourTicket = {}
for n in yours:gmatch("(%d+)") do
	yourTicket[#yourTicket + 1] = tonumber(n)
end

local part2 = 1
for fieldID, field in pairs(fields) do
	if field.field:find("^departure") then
		part2 = part2*yourTicket[field.solved]
	end
end

print("Part 2:", part2)