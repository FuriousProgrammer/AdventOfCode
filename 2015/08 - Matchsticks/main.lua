local string_c, memory_c, encoded_c = 0, 0, 0

for line in io.lines("input.txt") do
	string_c = string_c + #line

	local real = line:sub(2, -2)
	real = real:gsub("\\\\", "_")
	real = real:gsub("\\x..", "_")
	real = real:gsub("\\\"", "_")

	memory_c = memory_c + #real

	real = line:gsub("\\", "__")
	real = real:gsub("\"", "__")

	encoded_c = encoded_c + #real + 2
end	

print("Part 1:", string_c - memory_c)
print("Part 2:", encoded_c - string_c)