local eyecolors = {amb=true; blu=true; brn=true; gry=true; grn=true; hzl=true; oth=true}
local dat = {}

local valid1 = 0
local valid2 = 0

-- I could probably find a way to make this less messy, but it works!
local function validate(dat)
	local byr, iyr, eyr, hgt, hcl, ecl, pid = dat['byr'], dat['iyr'], dat['eyr'], dat['hgt'], dat['hcl'], dat['ecl'], dat['pid']
	if byr and iyr and eyr and hgt and hcl and ecl and pid then
		valid1 = valid1 + 1
	else
		return
	end

--	print()
--	for f, d in pairs(dat) do
--		print(f, d)
--	end
--	io.read()

	if #byr ~= 4 or tonumber(byr) < 1920 or tonumber(byr) > 2002 then return end
	if #iyr ~= 4 or tonumber(iyr) < 2010 or tonumber(iyr) > 2020 then return end
	if #eyr ~= 4 or tonumber(eyr) < 2020 or tonumber(eyr) > 2030 then return end

	local num, unit = hgt:match("(%d+)(%w%w)")
	num = tonumber(num)
	if not unit then return end
	if unit == "in" then
		if num < 59 or num > 76 then return end
	elseif unit == "cm" then
		if num < 150 or num > 193 then return end
	else
		return
	end

	if not hcl:match("^(#%x%x%x%x%x%x)$") then return end
	if not eyecolors[ecl] then return end
	if not pid:match("^(%d%d%d%d%d%d%d%d%d)$") then return end

--	print("APPROVED")
	valid2 = valid2 + 1
end

for line in io.lines("input.txt") do
	if line ~= "" then
		line = line .. " "
		for field, data in line:gmatch("(...):(.-) ") do
			dat[field] = data
		end
	else
		validate(dat)
		dat = {}
	end
end
validate(dat) -- so the last passport isn't ignored!

print("Part 1:", valid1)
print("Part 2:", valid2)