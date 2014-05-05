-- upgrades.lua
-- Contains all the backend info for upgrades

local btn_img_folder = "btn_imgs/"

-- Specific function and effect for each upgradable icon.
local upgrades = { 
	blacksmith_base_power = {
		effect_prev = 3,
		effect_next = 3, -- for calculating next 
		img_over = ,
		xs
		cost_prev = 5,
		cost_next = cost_prev * 5,
		icon = nil,
	},
}

return upgrades

