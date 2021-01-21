local ingredients = {}

for line in io.lines("input.txt") do
--Sprinkles: capacity 5, durability -1, flavor 0, texture 0, calories 5
	local cap, dur, fla, tex, cal = line:match("capacity (%-?%d+), durability (%-?%d+), flavor (%-?%d+), texture (%-?%d+), calories (%-?%d+)")
	ingredients[#ingredients + 1] = {
		cap = tonumber(cap);
		dur = tonumber(dur);
		fla = tonumber(fla);
		tex = tonumber(tex);
		cal = tonumber(cal);
	}
end

local maxScore1 = 0
local maxScore2 = 0

-- TODO: generalize to `n` ingredients
for a = 100, 0, -1 do
	for b = 100 - a, 0, -1 do
		for c = 100 - a - b, 0, -1 do
			local d = 100 - a - b - c
			assert(a + b + c + d == 100)

			local cookie = {cap=0,dur=0,fla=0,tex=0,cal=0}
			local counts = {a, b, c, d}
			for i = 1, 4 do
				for part, amount in pairs(ingredients[i]) do
					cookie[part] = cookie[part] + amount*counts[i]
				end
			end

			local score = math.max(cookie.cap, 0)*math.max(cookie.dur, 0)
					     *math.max(cookie.fla, 0)*math.max(cookie.tex, 0)
			maxScore1 = math.max(maxScore1, score)
			if cookie.cal == 500 then
				maxScore2 = math.max(maxScore2, score)
			end

		end
	end
end

print("Part 1:", maxScore1)
print("Part 2:", maxScore2)