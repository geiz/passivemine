local rockdefs = require ("rockdefs")
local util = require ("util")

function getRockDefinition (n)
	if rockdefs[n] then
		return copy (rockdefs[n])
	else
		return nil
	end
end

function loadPlayerStats ()
	-- TODO: check for saved info
	
	-- If no saved info, return default stats
	return {
		name = "george",
		dollar = 0,
		gem = 0,
		pickaxe_power = 1,
		pickaxe_quality = 1,
		active_multiplier = 1, -- Bonus multiplier for active player clicks
		passive_multiplier = 1, -- Bonus multiplier for passive player clicks

	}
end

function savePlayerStats (t)
	-- TODO: save stats table t
end

return {
	getRockDefinition = getRockDefinition,
	loadPlayerStats = loadPlayerStats,
	savePlayerStats = savePlayerStats
}