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

function setPlayerstateGem (g)
	playerstate.gem = g
end

function setPlayerstatePickaxePower(p)
	playerstate.pickaxe_power = p
end

function setPlayerstatePickaxeQuality(q)
	playerstate.pickaxe_quality = q
end

function setPlayerstateActiveMultiplier(m)
	playerstate.active_multiplier = m
end

function setPlayerstatePassiveMultiplier(m)
	playerstate.passive_multiplier = m
end

function setBSExpertiseLevel (e)
	playerstate.bs_expertise_level = e
end

function setBSEfficiencyLevel (e)
	playerstate.bs_efficiency_level = e
end

function getBSUpgradeLevel ()
	return playerstate.bs_upgrade_level
end

function getBSSkillLevel () 
	return playerstate.bs_skill_level
end

function getBSExpertiseLevel ()
	return playerstate.bs_expertise_level
end

function getBSEfficiencyLevel ()
	return playerstate.bs_efficiency_level
end


-- PLayer State
function getPlayerState()   -- returns a table with current player stats.
	return playerstate
end
