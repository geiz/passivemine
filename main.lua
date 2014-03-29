-- Copyright 2014 Opplet LLC   --
---------------------------------

local defsys = require("logicinterface")
if true then return nil end


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

local boxDollarsTotal = display.newText ({ text="", x=_W/2, y=100, font=native.systemFont, fontSize=48, align="left", width=_W })
boxHpRock:setFillColor (0)

local buttonNewPickaxe = display.newImage ("images/axe_icon.png", 60, _H - 60)
buttonNewPickaxe:addEventListener ("tap", function(event)
	tryAddAxe ()
	end)

local currentRock = nil
local dollars = 0
local axeGenPower = 0
local axeGenImprove = 0
local minerFrequency = {}   -- average hits per second, per miner
local minerPower = {}       -- average hp reduction per hit, per miner
local minerSkill = {}       -- hp reduction multipler, per miner

function initialize ()
	local lockedIndex = 1
	
	-- add prev/next links to rock defintions
	for i=1,#rockdefs do
		if i > 1 then rockdefs[i].prev = rockdefs[i-1] end
		if i < #rockdefs then rockdefs[i].next = rockdefs[i+1] end
		if i >= lockedIndex then rockdefs[i].lockNext = true end
		rockdefs[i].index = i
	end
	
	
	dollars = 0
	axeGenPower = 10        -- minimum power of next axe
	axeGenImprove = 0.5
	minerFrequency = { 0 }
	minerPower = { 1.0 }
	minerSkill = { 1.0 }
	setCurrentRock (rockdefs[1])
	
	updateDisplay ()
end

function updateDisplay ()
	boxDollarsTotal.text = "$" .. dollars
end

function randomVariance (n, variance)
	return math.random (math.round(n * (1 - variance)), math.round(n * (1 + variance)))
end

function abstractMine (skill, power, frequency, time)
end

function mine (power, skill)
	local hp = skill * power
	if currentRock then
		currentRock.hp = currentRock.hp - hp
		if currentRock.hp > 0 then
			boxHpRock.text = "HP: " .. currentRock.hp
			boxDollarsRock.text = "$" .. currentRock.actualDollars
		else
			currentRock.lockNext = false
			issueRewardForRock ()
			resetRock ()
		end
	end
end

function manualMine ()
	mine (minerPower[1], minerSkill[1])
end

function issueRewardForRock ()
	dollars = dollars + currentRock.actualDollars
	updateDisplay ()
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
	if r.image and r.image ~= "" then
		r.displayImage = display.newImage ("images/" .. r.image, _W/2, _H/2)
	else
		r.displayImage = display.newImage ("images/blank.png", _W/2, _H/2)
	end
	r.displayImage:toBack ()
	r.displayImage:addEventListener ("tap", manualMine) -- name, numTaps, x, y
	currentRock = r
	resetRock ()
end

function resetRock ()
	currentRock.hp = randomVariance (currentRock.startHP, 0.10)
	currentRock.actualDollars = randomVariance (currentRock.dollars, 0.20)
	
	showArrows ()
	
	boxHpRock.text = "HP: " .. currentRock.hp
	boxDollarsRock.text = "$" .. currentRock.actualDollars
end

function tryAddAxe ()
	local newPower = axeGenPower + randomVariance (axeGenPower, axeGenImprove)
	minerPower[1] = newPower
end

local leftArrow = nil
local rightArrow = nil
function showArrows ()
	if leftArrow then
		leftArrow:removeSelf ()
		leftArrow = nil
	end
	if rightArrow then
		rightArrow:removeSelf ()
		rightArrow = nil
	end
	if currentRock.prev then
		leftArrow = display.newImage ("images/Backward Arrow.png", 128, _H/2)
		leftArrow:addEventListener ("tap", function (event)
			setCurrentRock (currentRock.prev)
			end)
	end
	if currentRock.next and not currentRock.lockNext then
		rightArrow = display.newImage ("images/Forward Arrow.png", _W-128, _H/2)
		rightArrow:addEventListener ("tap", function (event)
			setCurrentRock (currentRock.next)
			end)
	end
end

-- Rock definitions
rockdefs = {
	{ name = "Dirt", startHP = 10, dollars = 1, image = "dirt-pile.jpg" },
	{ name = "Clay", startHP = 50, dollars = 10, image = "clay.jpg" },
	{ name = "Sand", startHP = 500, dollars = 100, image = "" },
	{ name = "Gravel", startHP = 20000, dollars = 3000, image = "" },
	{ name = "Rock", startHP = 1000000, dollars = 40000, image = "" },
	{ name = "FlagStone", startHP = 2500000, dollars = 100000, image = "" },
}

initialize ()
