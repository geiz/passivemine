-- upgrades.lua
-- Contains all the backend info for upgrades
require ("playerstate")

-- Specific function and effect for each upgradable icon.

local blacksmith_upgrade = {
		img_over = btn_img_folder.."blank.png", -- mouseover image of button 
		img_default = btn_img_folder.."blank.png", --  idle image of button 
		next_cost = 1, -- Next cost of upgrade
		next_effect = 1, -- Next effect of upgrade
		algorithm_cost = 1.5, -- Used to determine cost at a given level
		algorithm_effect = 5, -- used to determine effet at a given level
}

local blacksmith_skill = {
		img_over = btn_img_folder.. "blank.png",
		img_default = btn_img_folder.. "blank.png",
		next_cost = 1,
		next_effect = 1,
		algorithm_cost = 1.5, 
		algorithm_effect = 5,
}
	
local blacksmith_expertise = {
		img_over = btn_img_folder.. "blank.png",
		img_default = btn_img_folder.. "blank.png",
		next_cost = 1,
		next_effect = 1,
		algorithm_cost = 1.5, 
		algorithm_effect = 5,		
}

local blacksmith_efficiency = { 
		img_over = btn_img_folder.. "blank.png",
		img_default = btn_img_folder.. "blank.png",
		next_cost = 1,
		next_effect = 1,
		algorithm_cost = 1.5, 
		algorithm_effect = 5,
}

local manualclick_power = {
		img_over = btn_img_folder.. "blank.png",
		img_default = btn_img_folder.. "blank.png",
		next_cost = 1,
		next_effect = 1,
		algorithm_cost = 1.5, 
		algorithm_effect = 5,	
}

-- Primary Data Set/Get Functions
-------------------------------------
-- Upgrade
function setBSUpgradeNextCost(nc)
	blacksmith_upgrade.next_cost = nc
end

function setBSUpgradeNextEffect(ne)
	blacksmith_upgrade.next_effet = ne
end 

function getBSUpgradeNextCost ()
	return blacksmith_upgrade.next_cost
end

function getBSUpgradeNextEffect ()
	return blacksmith_upgrade.next_effect
end

function setBSUpgradeLevel (lvl)
	playerstate.bs_upgrade_level = lvl
	setBSUpgradeNextCost(getUpgradeNextCost() * blacksmith_upgrade.algorithm_cost * lvl )
	setBSUpgradeNextEffect(getUpgradeNextEffect() * blacksmith_upgrade.algorithm_effect * lvl ) -- TODO: next_effect algorithm
end

-- Skill
function setBSSkillNextCost(nc)
	blacksmith_skill.next_cost = nc
end

function setBSSkillNextEffect(ne)
	blacksmith_skill.next_effet = ne
end 

function getBSSkillNextCost ()
	return blacksmith_skill.next_cost
end

function getBSSkillNextEffect ()
	return blacksmith_skill.next_effect
end

function setBSSkillLevel (lvl)
	playerstate.bs_skill_level = lvl
	setBSSkillNextCost(getSkillNextCost() * blacksmith_skill.algorithm_cost * lvl)
	setBSSkillNextEffect(getSkillNextEffect() * blacksmith_skill.algorithm_effect * lvl) -- TODO: next_effect algorithm
end

-- Expertise
function setBSExpertiseNextCost(nc)
	blacksmith_skill.next_cost = nc
end

function setBSExpertiseNextEffect(ne)
	blacksmith_skill.next_effet = ne
end 

function getBSExpertiseNextCost ()
	return blacksmith_skill.next_cost
end

function getBSExpertiseNextEffect ()
	return blacksmith_skill.next_effect
end

function setBSExpertiseLevel (lvl)
	playerstate.bs_expertise_level = e
	setBSExpertiseNextCost(getBSExpertiseNextCost() * blacksmith_efficiency.algorithm_cost * lvl)
	setBSExpertiseNextEffect(getBSExpertiseNextEffect() * blacksmith_efficiency.algorithm_cost * lvl)
end

-- Efficiency
function setBSEfficiencyNextCost(nc)
	blacksmith_skill.next_cost = nc
end

function setBSEfficiencyNextEffect(ne)
	blacksmith_skill.next_effet = ne
end 

function getBSEfficiencyNextCost ()
	return blacksmith_skill.next_cost
end

function getBSEfficiencyNextEffect ()
	return blacksmith_skill.next_effect
end

function setLevel_Efficiency (lvl)
	setPlayerBSEfficiencyLevel(lvl)
	blacksmith_efficiency.next_cost = blacksmith_efficiency.algorithm_cost * lvl -- TODO: next_cost algorithm
	blacksmith_efficiency.next_effect = blacksmith_efficiency.algorithm_effect * lvl -- TODO: next_effect algorithm
end

-- Manual Click Power
function setMCPowerNextCost(nc)
	manualclick_power.next_cost = nc
end

function setMCPowerNextEffect(ne)
	manualclick_power.next_effet = ne
end 

function getMCPowerNextCost ()
	return manualclick_power.next_cost
end

function getMCPowerNextEffect ()
	return manualclick_power.next_effect
end

function setLevel_MCPower ()
	setPlayerBSEfficiencyLevel(lvl)
	blacksmith_efficiency.next_cost = blacksmith_efficiency.algorithm_cost * lvl -- TODO: next_cost algorithm
	blacksmith_efficiency.next_effect = blacksmith_efficiency.algorithm_effect * lvl -- TODO: next_effect algorithm
end
function setLevel_Efficiency (lvl)
	setPlayerBSEfficiencyLevel(lvl)
	blacksmith_efficiency.next_cost = blacksmith_efficiency.algorithm_cost * lvl -- TODO: next_cost algorithm
	blacksmith_efficiency.next_effect = blacksmith_efficiency.algorithm_effect * lvl -- TODO: next_effect algorithm
end

-- Should not be local scope
BS_Upgrade = function  ()
	local currentDollar = getPlayerState().dollar
	local requiredDollar = getBSUpgradeNextCost()

	if currentDollar >= requiredDollar then
		
		-- Updates stored values
		setPlayerstateDollars(currentDollar - requiredDollar)
		
		setBSUpgradeLevel(getPlayerBSUpgradeLevel() + 1)
		print("should Trigger")
	else
		print("Not enough money")
	end
end

BS_Skill = function ()
	local currentDollar = getPlayerState().dollar
	local requiredDollar = getBSSkillNextCost()

	if currentDollar >= requiredDollar then
		
		-- Updates stored values
		setPlayerstateDollars(currentDollar - requiredDollar)
		
		getPlayerBSSkillLevel(setBS() + 1)
		print("BS_SKILL" )
	else
		print("Not enough money")
	end
end

BS_Expertise = function ()
	local currentDollar = getPlayerState().dollar
	local requiredDollar = getBSSkillNextCost()

	if currentDollar >= requiredDollar then
		
		-- Updates stored values
		setPlayerstateDollars(currentDollar - requiredDollar)
		
		setBSExpertiseLevel(getPlayerBSExpertiseLevel() + 1)
		print("BS_SKILL")
	else
		print("Not enough money")
	end
end

BS_Efficiency = function ()
	local currentDollar = getPlayerState().dollar
	local requiredDollar = getSkillNextCost()

	if currentDollar >= requiredDollar then
		
		-- Updates stored values
		setPlayerstateDollars(currentDollar - requiredDollar)
		
		setLevel_Efficiency(getPlayerBSEfficiencyLevel() + 1)
		print("BS_SKILL")
	else
		print("Not enough money")
	end
end

MC_Power = function ()
	local currentDollar = getPlayerState().dollar
	local requiredDollar = getSkillNextCost()

	if currentDollar >= requiredDollar then
		
		-- Updates stored values
		setPlayerstateDollars(currentDollar - requiredDollar)
		
		setLevel_Efficiency(getPlayerBSEfficiencyLevel() + 1)
		print("BS_SKILL")
	else
		print("Not enough money")
	end
end

return upgrades















