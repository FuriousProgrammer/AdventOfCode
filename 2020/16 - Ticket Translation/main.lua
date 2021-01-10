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
	}
end

file:read("*l*l")
yours = file:read("*l")
file:read("*l*l")

local ticketFields = {}
for i = 1, #fields do
	ticketFields[i] = {}
end
-- NOTE: the problem DOES NOT state that your ticket is valid!
-- Therefor, it cannot be used to determine which field is in which column!

local errors = 0
while true do
	line = file:read("*l")
	if not line then break end

	local ticket = {}
	for n in line:gmatch("(%d+)") do
		n = tonumber(n)
		local valid = false

		if ticket then ticket[#ticket + 1] = n end
		for _, field in pairs(fields) do
			if n >= field.min1 and n <= field.max1 or n >= field.min2 and n <= field.max2 then
				valid = true
				break
			end
		end

		if not valid then
			errors = errors + n
			ticket = nil
		end
	end

	if ticket then
		for i = 1, #fields do
			table.insert(ticketFields[i], ticket[i])
		end
	end
end

print("Part 1:", errors)


-- 1) figure out which fields MIGHT correspond to the given column
-- 1.a) remove fields that have been determined to remove unnecesary computation
local unknownFields = #fields
local totalFields = #fields
local determined = {}

for col, vals in pairs(ticketFields) do
	local possible = {} -- shallow copy of fields
	local possibleCount = 0
	for i, v in pairs(fields) do
		possible[i] = v
		possibleCount = possibleCount + 1
	end

	if possibleCount > 1 then
		for _, n in pairs(vals) do
			for i = 1, totalFields do
				local field = possible[i]
				if field then
					if not (n >= field.min1 and n <= field.max1 or n >= field.min2 and n <= field.max2) then
						possible[i] = nil
						possibleCount = possibleCount - 1
					end
				end
			end
		end
	end
	if possibleCount == 1 then
		for i, v in pairs(possible) do -- only runs once
			determined[col] = v
			fields[i] = nil
		end
		unknownFields = unknownFields - 1
	else
		determined[col] = {}
		for i in pairs(possible) do
			table.insert(determined[col], i)
		end
	end
end

-- 2) if any ambiguity remains, remove determined fields from ambiguous lists until none remains.
local stale = false
while unknownFields > 0 do
	if not stale then
		stale = true
		for i = 1, #determined do
			if not determined[i].field then
				local valid = {}
				for _, id in pairs(determined[i]) do
					if fields[id] then
						valid[#valid + 1] = id
					end
				end
				if #valid == 1 then
					determined[i] = fields[i]
					fields[i] = nil
					unknownFields = unknownFields - 1
					stale = false
				else
					determined[i] = valid
				end
			end
		end
	else --if stale
		-- TODO: guess + check!
		break
	end
end


for i = 1, #determined do
	io.write(i, ": ")
	if determined[i].field then
		print(determined[i].field)
	else
		print(table.concat(determined[i], ", "))
	end 
end

--[[
local yourTicket = {}
for n in yours:gmatch("(%d+)") do
	yourTicket[#yourTicket+1] = tonumber(n)
end	

local part2 = 1
for i = 1, #determined do
	if determined[i].field:find("^departure") then
		part2 = part2*yourTicket[i]
	end
end

print("Part 2:", part2)
--]]