-- Copyright 2014 Opplet LLC   --
---------------------------------

-- MINEY!!! Game --

local _W, _H = display.contentWidth, display.contentHeight

display.setDefault ("background", 1)
display.setDefault ("fillColor", 0.5)
display.setDefault ("strokeColor", 0)
display.setDefault ("lineColor", 0)

local currentRock = nil
local autoMineVector = {}

function initialize ()
	setCurrentRock (rockdefs[1])
end

function abstractMine (skill, power, frequency, time)
end

function mine (skill, power)
	local hp = skill * power
	if currentRock then
		currentRock.hp = currentRock.hp - hp
		if currentRock.hp <= 0 then
			issueRewardForRock ()
			resetRock ()
		end
	end
end

function manualMine ()
	mine (1.0, 1.0)
end

function issueRewardForRock ()
end

function clearCurrentRock ()
	if currentRock then
		currentRock.displayImage:removeSelf ()
		currentRock.displayImage = nil
		currentRock = nil
	end
end

function setCurrentRock (r)
	if currentRock then clearCurrentRock () end
	r.displayImage = display.newImage ("images/" .. r.image, _W/2, _H/2)
	r.displayImage:addEventListener ("tap", manualMine) -- name, numTaps, x, y
	currentRock = r
end

function resetRock ()
	r.hp = r.startHP
end

-- Rock definitions
rockdefs = {
	{ name = "Dirt", startHP = 10, image = "dirt-pile.jpg" },
	{ name = "Clay", startHP = 10, image = "" },
	{ name = "Sand", startHP = 10, image = "" },
	{ name = "Gravel", startHP = 10, image = "" },
	{ name = "Rock", startHP = 10, image = "" },
	{ name = "FlagStone", startHP = 10, image = "" },
}

initialize ()
