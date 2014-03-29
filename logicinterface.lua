-- Copyright 2014 Opplet LLC
---------------------------------

display.setStatusBar( display.HiddenStatusBar ) 

local widget = require ("widget")

local _W, _H = display.contentWidth, display.contentHeight

displayMayNeedUpdate = true

display.setDefault ("background", 1)
display.setDefault ("fillColor", 0.5)
display.setDefault ("strokeColor", 0)
display.setDefault ("lineColor", 0)

local scrollView = widget.newScrollView
{
	left = 10,
	top = 10,
	width = display.contentWidth - 10,
	height = display.contentHeight - 10,
	bottomPadding = 50,
	id = "",
	horizontalScrollDisabled = true,
	verticalScrollDisabled = false,
	listener = nil,
}

True = function()return true end
False = function()return false end

-- STATS

local statsByIndex = {}

function addStat (name, initialValue, onUpdate)
	local s = {
		name = name,
		value = initialValue,
		stringvalue = function (self) return self.name .. " " .. tostring (self.value) end,
		update = function (self, value)
			self.value = value
			if self.textbox then self.textbox.text = self:stringvalue() end
			if self.onUpdate then self:onUpdate (value) end
			displayMayNeedUpdate = true
		end,
		onUpdate = onUpdate
	}
	table.insert (statsByIndex, s)
	return s
end

-- ACTIONS

local actionSet = {}

function addAction (name, actionFn, isAllowedFn)
	table.insert (actionSet, {
		name = name,
		action = actionFn,
		allowed = isAllowedFn
		})
end


StatsLabel = nil
ActionsLabel = nil

function updateDisplay ()
	displayMayNeedUpdate = false
	
	local top = 0
	
	if not StatsLabel then
		StatsLabel = display.newText { text="STATS",font=native.systemFontBold,fontSize=36,align="left"}
		StatsLabel:setFillColor (0.5)
		StatsLabel.anchorX = 0
		StatsLabel.anchorY = 0
	end
	StatsLabel.y = top
	top = top + 50
	
	for i, s in pairs (statsByIndex) do
		if s.textbox then
			s.textbox:removeSelf()
			s.textbox = nil
		end
		s.textbox = display.newText {
			text=s:stringvalue(),y=top,
			font=native.systemFont,fontSize=36,align="left"
		}
		s.textbox:setFillColor (0)
		s.textbox.anchorX = 0
		s.textbox.anchorY = 0
		scrollView:insert (s.textbox)
		top = top + 50
	end
	
	if not ActionsLabel then
		ActionsLabel = display.newText { text="ACTIONS",font=native.systemFontBold,fontSize=36,align="left"}
		ActionsLabel:setFillColor (0.5)
		ActionsLabel.anchorX = 0
		ActionsLabel.anchorY = 0
	end
	ActionsLabel.y = top + 30
	top = top + 80
	
	for i, a in pairs (actionSet) do
		if a.button then
			a.button:removeSelf()
			a.button = nil
		end
		if a.allowed() then
			a.button = widget.newButton {
				left=2, top=top, label=a.name, labelAlign="left", onRelease=function(event) a.action(a,event) end,
				font=native.systemFont,
				fontSize=36, emboss=true, labelColor={default={0,0,0}, over={0,0,0,0.5}}
			}
			scrollView:insert (a.button)
			top = top + 50
		end
	end
end

local rockdefs = require ("rockdefs")

local dollars = addStat ("$")
local gems = addStat ("Gems")
local pick = addStat ("Pick Strength")
local rocklevel = addStat ("Mining Rock Level")
local rockdollars = addStat ("Rock $")
local rockhp = addStat ("Rock HP")
local rockdef = addStat ("Rock Def")
local maxunlocklevel = addStat ("Max Unlocked Rock Level")
local gemprobability = addStat ("Total Gem Probability")
local basegemprobability = addStat ("Base Gem Probability")
local rockgemprobability = addStat ("Rock Gem Probability")
basegemprobability.onUpdate = function (self, value)
	gemprobability:update (basegemprobability.value + rockgemprobability.value)
end
rockgemprobability.onUpdate = basegemprobability.onUpdate

function init ()
	dollars.value = (0)
	gems.value = (1)
	pick.value = (100)
	maxunlocklevel.value = (1)
	basegemprobability.value = (0)
	newRock (1)
end

function newRock (level)
	if level > #rockdefs then
		-- do something unlimited!
	else
		rocklevel.value = level
		rockdollars.value = (rockdefs[level].dollars)
		rockhp.value = (rockdefs[level].startHP)
		rockdef.value = (rockdefs[level].def or 0)
		rockgemprobability.value = (rockdefs[level].gemprob or 0)
	end
	for i, s in pairs (statsByIndex) do
		s:update (s.value)  -- trigger any updates that need triggering
	end
end

function actionNextLevel ()
	newRock (rocklevel.value + 1)
end

function actionPrevLevel ()
	newRock (rocklevel.value - 1)
end

function actionHit (action,event)
	local hitamt = math.max (pick.value - rockdef.value, 0)
	rockhp:update (math.max (rockhp.value - hitamt, 0))
	if rockhp.value == 0 then
		dollars:update (dollars.value + rockdollars.value)
		if rocklevel.value >= maxunlocklevel.value then maxunlocklevel:update (rocklevel.value + 1) end
		newRock (rocklevel.value)
	end
end

addAction ("Hit", actionHit, function () return true end)
addAction ("Mine Higher Level Rock", actionNextLevel, function () return maxunlocklevel.value > rocklevel.value end)
addAction ("Mine Lower Level Rock", actionPrevLevel, function () return rocklevel.value > 1 end)
addAction ("Upgrade Pick", function () end, function () return true end)

init()

for i, s in pairs (statsByIndex) do
	s:update (s.value)  -- trigger any updates that need triggering
end

Runtime:addEventListener ("enterFrame", function (event) if displayMayNeedUpdate then updateDisplay () end end)
