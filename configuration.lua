-- Configuration module.
-- KEY IDEA: Anything that accesses saved data goes in this module.

local rockdefs = require ("rockdefs")
local util = require ("util")
 btn_img_folder = "btn_imgs/"

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
		current_rock_id = 1,
		pickaxe_power = 1,
		pickaxe_quality = 1,
		active_multiplier = 1, -- Bonus multiplier for active player clicks
		passive_multiplier = 1, -- Bonus multiplier for passive player clicks
		bs_upgrade_level = 1,
		bs_skill_level = 1, 
		bs_expertise_level = 1,
		bs_efficiency_level = 1,
	}
end

function savePlayerStats (t)
	-- TODO: save stats table t
end

return {
	getRockDefinition = getRockDefinition,
	loadPlayerStats = loadPlayerStats,
	savePlayerStats = savePlayerStats,
}