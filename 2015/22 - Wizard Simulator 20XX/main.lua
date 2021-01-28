local input = io.open("input.txt")
input = input:read("*a"), input:close()

local queue = {
	{
		playerTurn = false;
		playerHealth = 50;
		playerMana = 500;
		bossHealth = tonumber(input:match("Hit Points: (%d+)"));
		bossDamage = tonumber(input:match("Damage: (%d+)"));
		effects = {shield=0, poison=0, recharge=0};
		manaSpent = 0;
	},

	{
		hardMode = true;
		playerTurn = false;
		playerHealth = 50;
		playerMana = 500;
		bossHealth = tonumber(input:match("Hit Points: (%d+)"));
		bossDamage = tonumber(input:match("Damage: (%d+)"));
		effects = {shield=0, poison=0, recharge=0};
		manaSpent = 0;
	},
}
local function deepCopy(t)
	local n = {}
	for i, v in pairs(t) do
		if type(v) == "table" then
			v = deepCopy(v)
		end
		n[i] = v
	end
	return n
end

local minMana = math.huge
local minHard = math.huge
local function win(state)
	if state.hardMode then
		minHard = math.min(minHard, state.manaSpent)
	else
		minMana = math.min(minMana, state.manaSpent)
	end
end

local function process(state)
	if state.manaSpent > (state.hardMode and minHard or minMana) then return end

	-- Hard Mode:
	if state.playerTurn and state.hardMode then
		state.playerHealth = state.playerHealth - 1
	end
	if state.playerHealth <= 0 then return end

	-- Effects:
	if state.effects.recharge > 0 then
		state.effects.recharge = state.effects.recharge - 1
		state.playerMana = state.playerMana + 101
	end
	if state.effects.poison > 0 then
		state.effects.poison = state.effects.poison - 1
		state.bossHealth = state.bossHealth - 3
	end
	state.effects.shield = state.effects.shield - 1

	if state.bossHealth <= 0 then
		win(state)
		return
	end

	state.playerTurn = not state.playerTurn -- saves some lines to do this here
	if state.playerTurn then
		-- Player's turn:

		-- Magic Missile:
		if state.playerMana < 53 then return end
		local nxt = deepCopy(state)
		nxt.manaSpent = nxt.manaSpent + 53
		nxt.playerMana = nxt.playerMana - 53
		nxt.bossHealth = nxt.bossHealth - 4
		queue[#queue + 1] = nxt

		-- Drain:
		if state.playerMana < 73 then return end
		nxt = deepCopy(state)
		nxt.manaSpent = nxt.manaSpent + 73
		nxt.playerMana = nxt.playerMana - 73
		nxt.bossHealth = nxt.bossHealth - 2
		nxt.playerHealth = nxt.playerHealth + 2
		queue[#queue + 1] = nxt

		-- Shield:
		if state.playerMana < 113 then return end
		if state.effects.shield <= 0 then
			nxt = deepCopy(state)
			nxt.manaSpent = nxt.manaSpent + 113
			nxt.playerMana = nxt.playerMana - 113
			nxt.effects.shield = 6
			queue[#queue + 1] = nxt
		end

		-- Poison:
		if state.playerMana < 173 then return end
		if state.effects.poison == 0 then
			nxt = deepCopy(state)
			nxt.manaSpent = nxt.manaSpent + 173
			nxt.playerMana = nxt.playerMana - 173
			nxt.effects.poison = 6
			queue[#queue + 1] = nxt
		end

		-- Recharge:
		if state.playerMana < 229 then return end
		if state.effects.recharge == 0 then
			state.manaSpent = state.manaSpent + 229
			state.playerMana = state.playerMana - 229
			state.effects.recharge = 5
			queue[#queue + 1] = state
		end

	else
		-- Boss's turn:
		local damage = math.max(1, state.bossDamage - (state.effects.shield > 0 and 7 or 0))
		state.playerHealth = state.playerHealth - damage
		if state.playerHealth <= 0 then return end

		queue[#queue + 1] = state
	end
end

while #queue > 0 do
	process(table.remove(queue))
end

print("Part 1:", minMana)
print("Part 2:", minHard)