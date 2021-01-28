local input = io.open("input.txt")
input = input:read("*a"), input:close()

bossHealth = tonumber(input:match("Hit Points: (%d+)"))
bossDamage = tonumber(input:match("Damage: (%d+)"))
bossArmor  = tonumber(input:match("Armor: (%d+)"))

playerHealth = 100
playerDamage = 0
playerArmor  = 0

local weps = {
	{cost=8,   dam=4, arm=0};
	{cost=10,  dam=5, arm=0};
	{cost=25,  dam=6, arm=0};
	{cost=40,  dam=7, arm=0};
	{cost=74,  dam=8, arm=0};
}
local arms = {
	{cost=0,   dam=0, arm=0}; -- since you can choose to not buy!
	{cost=13,  dam=0, arm=1};
	{cost=31,  dam=0, arm=2};
	{cost=53,  dam=0, arm=3};
	{cost=75,  dam=0, arm=4};
	{cost=102, dam=0, arm=5};
}
local rings = {
	{cost=0,   dam=0, arm=0};
	{cost=25,  dam=1, arm=0};
	{cost=50,  dam=2, arm=0};
	{cost=100, dam=3, arm=0};
	{cost=20,  dam=0, arm=1};
	{cost=40,  dam=0, arm=2};
	{cost=80,  dam=0, arm=3};
}

local minWin = math.huge
local maxLose = -math.huge
local cost = 0

local function duel(bHP, bDM, bAM, pHP, pDM, pAM)
	while true do
		bHP = bHP - math.max(1, pDM - bAM)
		if bHP <= 0 then break end
		pHP = pHP - math.max(1, bDM - pAM)
		if pHP <= 0 then break end
	end

	if pHP > 0 then -- player win!
		minWin = math.min(minWin, cost)
	else -- player lose! :(
		maxLose = math.max(maxLose, cost)
	end
end

local function add(arr)
	cost = cost + arr.cost
	playerDamage = playerDamage + arr.dam
	playerArmor = playerArmor + arr.arm
end
local function rem(arr)
	cost = cost - arr.cost
	playerDamage = playerDamage - arr.dam
	playerArmor = playerArmor - arr.arm
end

for _, wep in pairs(weps) do
	add(wep)
	for _, arm in pairs(arms) do
		add(arm)
		for i = 1, #rings do
			add(rings[i])
			for j = 1, #rings do
				if i ~= j then add(rings[j]) end
				duel(bossHealth, bossDamage, bossArmor, playerHealth, playerDamage, playerArmor)
				if i ~= j then rem(rings[j]) end
			end
			rem(rings[i])
		end
		rem(arm)
	end
	rem(wep)
end

print("Part 1:", minWin)
print("Part 2:", maxLose)