-- Copyright 2014 Opplet LLC   --
---------------------------------

-- MINEY!!! Game --

local _W, _H = display.contentWidth, display.contentHeight

display.setDefault ("background", 1)
display.setDefault ("fillColor", 0.5)
display.setDefault ("strokeColor", 0)
display.setDefault ("lineColor", 0)

local boxNameRock = display.newText ({ text="", x=_W/2, y=_H/2-240, font=native.systemFont, fontSize=48 })
boxNameRock:setFillColor (0)

local boxDollarsRock = display.newText ({ text="", x=_W/2, y=_H/2-180, font=native.systemFont, fontSize=48 })
boxDollarsRock:setFillColor (0)

local boxHpRock = display.newText ({ text="", x=_W/2, y=_H/2+200, font=native.systemFont, fontSize=48 })
boxHpRock:setFillColor (0)

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
		if currentRock.hp > 0 then
			boxHpRock.text = "HP: " .. currentRock.hp
			boxDollarsRock.text = "$" .. currentRock.actualDollars
		else
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
		boxNameRock.text = ""
		currentRock.displayImage:removeSelf ()
		currentRock.displayImage = nil
		currentRock = nil
	end
end

function setCurrentRock (r)
	if currentRock then clearCurrentRock () end
	boxNameRock.text = r.name
	r.displayImage = display.newImage ("images/" .. r.image, _W/2, _H/2)
	r.displayImage:toBack ()
	r.displayImage:addEventListener ("tap", manualMine) -- name, numTaps, x, y
	currentRock = r
	resetRock ()
end

function resetRock ()
	currentRock.hp = currentRock.startHP
	currentRock.actualDollars = math.random (math.round(currentRock.dollars * 0.9), math.round(currentRock.dollars * 1.10))
	
	boxHpRock.text = "HP: " .. currentRock.hp
	boxDollarsRock.text = "$" .. currentRock.actualDollars
end

-- Rock definitions
rockdefs = {
	{ name = "Dirt", startHP = 10, dollars = 1, image = "dirt-pile.jpg" },
	{ name = "Clay", startHP = 10, image = "" },
	{ name = "Sand", startHP = 10, image = "" },
	{ name = "Gravel", startHP = 10, image = "" },
	{ name = "Rock", startHP = 10, image = "" },
	{ name = "FlagStone", startHP = 10, image = "" },
}

initialize ()
