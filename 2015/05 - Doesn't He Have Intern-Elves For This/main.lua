local nice = 0
local nice2 = 0

for line in io.lines("input.txt") do
	line = line:lower()
	if line:find("[aeiou].*[aeiou].*[aeiou]") and line:find("(.)%1")
			and not ( line:find("ab") or line:find("cd") or line:find("pq") or line:find("xy") ) then
		nice = nice + 1
	end

	if line:find("(..).*%1") and line:find("(.).%1") then
		nice2 = nice2 + 1
	end
end

print("Part 1:", nice)
print("Part 2:", nice2)