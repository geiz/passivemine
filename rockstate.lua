-- This module keeps track of the game's runtime state. (of rocks)
-- KEY IDEA: Anything that changes the current rock's state goes in this module.

require ("playerstate")
local config = require ("configuration")

local currentrock = nil

local function currentRockId ()
	return getPlayerState().current_rock_id or 1
end

local function initRock (r)   -- Resets the health values of rock r.
	r.curr_hp = r.start_hp
	return r
end

function selectRock (n)   -- selects rock number n. If needed, calls getRockDefinition() to update current rock stats.
	if n ~= currentRockId () or currentrock == nil then
		
		-- Loads new rock configuration.
		local rockdef = config.getRockDefinition (n)
		if rockdef then  -- only select the rock if we got a valid index
			currentrock = initRock (rockdef)
			setCurrentRockIdInPlayerstate (n)
		end
	end
end

function getRockState ()  -- returns a table with current rock stats.
	selectRock (currentrock_id)
	return currentrock
end

function mineCurrentRock ()   -- hits the current rock once with pickaxe.
	if currentrock.defense > activeHitPower() then -- if player's hit bypasses defense
	else
		currentrock.curr_hp = currentrock.curr_hp - activeHitPower()
		if currentrock.curr_hp <= 0 then
			setPlayerstateDollars (getPlayerState().dollar + currentrock.dollar)
			initRock (currentrock)
		end
	end
end

function simulateAutomine (count)  -- simulates the effect of calling mineCurrentRock() count times.
end

