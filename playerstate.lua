-- This module keeps track of the game's runtime state. (of the player)
-- KEY IDEA: Anything that reads or writes the player's runtime state goes in this module.

local config = require ("configuration")

local playerstate = config.loadPlayerStats()   -- NOTE: don't add anything to this table unless it needs to be saved!

function activeHitPower ()
	return playerstate.pickaxe_power * playerstate.pickaxe_quality * playerstate.active_multiplier
end

function passiveHitPower ()
	return playerstate.pickaxe_power * playerstate.pickaxe_quality * playerstate.passive_multiplier
end

function switchScreen ()
	
end

function setCurrentRockIdInPlayerstate (n)  -- intended for use by the rockstate module.
	playerstate.current_rock_id = n
end

function setPlayerstateDollars (d)
	playerstate.dollar = d
end

function getPlayerState()   -- returns a table with current player stats.
	return playerstate
end

function upgradePickAxe()   -- gives player an upgraded pickaxe.
end
