local ValuesByName = {}
local ComputationsByName = {}
local LazyComputationsByName = {}  -- lazy computations are accumulated, then applied sequentially at the next compute cycle
local DependsOnMe = {}
local UndefinedDependencies = {}
local UndefinedDependencyCount = {}

local WorklistByName = {}   -- worklist contains computable variables (which have values, but whose dependencies may have changed)
local WorklistByIndex = {}
local NowProcessingWorklist = false

local function introduceDependencies (var, ...)
	if not UndefinedDependencies[var] then UndefinedDependencies[var] = {} end
	if not UndefinedDependencyCount[var] then UndefinedDependencyCount[var] = 0 end
	for i=1,select("#",...) do
		local dep = select(i,...)
		if not DependsOnMe[dep] then DependsOnMe[dep] = {} end
		DependsOnMe[dep][var] = true
		if not ValuesByName[dep] then
			UndefinedDependencies[var][dep] = true
			UndefinedDependencyCount[var] = UndefinedDependencyCount[var] + 1
		end
	end
end

local function scheduleComputation (var)
	-- A computation will only be scheduled if: not already scheduled; and all input values have been defined.
	if not WorklistByName [var] and UndefinedDependencyCount[var] == 0 then
		WorklistByName [var] = true
		table.insert (WorklistByIndex, var)
	end
end

local function compute (var,user)
	-- do defined computation
	local result = ComputationsByName[var](user)
	if result then
		ValuesByName[var] = result
	end
	
	-- do accumulated lazy computations
	for i, c in ipairs (LazyComputationsByName[var] or {}) do
		local result = c ()
		if result then ValuesByName[var] = result end
	end
	LazyComputationsByName[var] = nil
	
	-- to do:merge function?
	
	-- Schedule each dependent computation, provided the computation has all necessary input values defined
	for nxt, _ in pairs (DependsOnMe[var] or {}) do
		if UndefinedDependencies[nxt][var] then
			UndefinedDependencies[nxt][var] = nil
			UndefinedDependencyCount[nxt] = UndefinedDependencyCount[nxt] - 1
		end
		scheduleComputation (nxt)
	end
end

local function doEntireWorklist ()
	local entryTime = system.getTimer()
	--NowProcessingWorklist = true
	while #WorklistByIndex > 0 do
		local var = table.remove (WorklistByIndex, 1)
		WorklistByName [var] = nil
		compute (var,ValuesByName[var])
		if system.getTimer() - entryTime > 30 then return end
	end
	--NowProcessingWorklist = false
end

---

function constant (value) return function () return value end end

function value (var) return ValuesByName[var] end

--function increment (var) return function () return value(var) + 1 end end

function define (var, computeFn, ...)
	-- problems to be solved: if the same variable is defined more than once, then old dependencies need to be cleared.
	ComputationsByName[var] = computeFn
	introduceDependencies (var, ...)
	scheduleComputation (var)
end

function responder_old (var, computeFn, eventSender, eventName, initialValue)
	-- Defines a computation that responds to an event
	ValuesByName[var] = initialValue
	ComputationsByName[var] = computeFn
	eventSender:addEventListener (eventName, function(event) compute (var,event) end)
end

function responder (eventSender, eventName, responseFn)
	eventSender:addEventListener (eventName, responseFn)
end

function application (var, fn)
	return function(event)
		if not LazyComputationsByName[var] then LazyComputationsByName[var] = {} end
		table.insert (LazyComputationsByName[var], fn)
		scheduleComputation (var)
	end
end

function enterFrameEvent (event)
	doEntireWorklist ()
end

Runtime:addEventListener ("enterFrame", enterFrameEvent)


---

display.setStatusBar( display.HiddenStatusBar )

local widget = require ("widget")

display.setDefault ("background", 1)
display.setDefault ("fillColor", 0.5)
display.setDefault ("strokeColor", 0)
display.setDefault ("lineColor", 0)

--local gemprobability_textbox = display.newText { text="...", font=native.systemFont, fontSize=36, align="left" }
--gemprobability_textbox:setFillColor (0)
--gemprobability_textbox.anchorX = 0
--gemprobability_textbox.anchorY = 0

--[[define ("gemprobability_output",
	function()
		gemprobability_textbox.text = value("gemprobability")
		end,
	"gemprobability")
	]]

define ("gemprobability_textbox", function(self)
	if not self then
		self = display.newText { text="...", font=native.systemFont, fontSize=36, align="left" }
		self:setFillColor (0)
		self.colorChangeTrigger = true
		self.anchorX = 0
		self.anchorY = 0
	end
	if self.colorChangeTrigger and value("framecount") >= 100 then
		print ("Changing color!")
		self:setFillColor (0,0,1)
		self.colorChangeTrigger = false
	end
	return self
	--[[if value("framecount") == 1 then
		self = display.newText { text="...", font=native.systemFont, fontSize=36, align="left" }
		self:setFillColor (0)
		self.anchorX = 0
		self.anchorY = 0
	elseif value("framecount") == 100 then
		self:setFillColor (0,0,1)
	end
	return self]]
	end,
	"framecount")

define ("gemprobability_out", function() value("gemprobability_textbox").text = value("gemprobability") end,
	"gemprobability", "gemprobability_textbox")


--externalLink ("gemprobability_textbox.text", function(v) value("gemprobability_textbox").text = v end,
--	"gemprobability_textbox")



define ("gemprobability",
	function() return value ("basegemprobability") + value("rockgemprobability") + value("framecount") end,
	"basegemprobability", "rockgemprobability", "framecount"
)

define ("basegemprobability", constant (0.01))

define ("rockgemprobability", constant (0.02))

define ("framecount", function(self) if not self then return 0 else return self+1 end end, "framecount")
compute ("framecount") -- force initial computation
--responder ("tag", function(event) application ("framecount", function() return value("framecount") + 1 end) end, Runtime, "enterFrame")
--responder (Runtime, "enterFrame", application("framecount", function() return value("framecount") + 1 end))
