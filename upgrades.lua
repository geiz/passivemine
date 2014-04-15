-- upgrades.lua
-- Contains all the backend info for upgrades

local upgrades = {
	blacksmith_base_power = {
		effect_prev = 3,
		effect_next = 3, -- for calculating next 
		cost_prev = 5,
		cost_next = cost_prev * 5, 
		icon = nil,
	} 
}

return upgrades