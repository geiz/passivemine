local ValuesByName = {}
local ComputationsByName = {}
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
	ValuesByName[var] = ComputationsByName[var](user)
	
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
	NowProcessingWorklist = true
	while #WorklistByIndex > 0 do
		local var = table.remove (WorklistByIndex, 1)
		WorklistByName [var] = nil
		compute (var)
	end
	NowProcessingWorklist = false
end

---

local function constant (value) return function () return value end end

local function value (var) return ValuesByName[var] end

local function define (var, computeFn, ...)
	-- problems to be solved: if the same variable is defined more than once, then old dependencies need to be cleared.
	ComputationsByName[var] = computeFn
	introduceDependencies (var, ...)
	scheduleComputation (var)
end

local function responder (var, computeFn, eventSender, eventName, initialValue)
	-- Defines a computation that responds to an event
	ValuesByName[var] = initialValue
	ComputationsByName[var] = computeFn
	eventSender:addEventListener (eventName, function(event) compute (var,event) end)
end

local function enterFrameEvent (event)
	doEntireWorklist ()
end

Runtime:addEventListener ("enterFrame", enterFrameEvent)

return {
	constant = constant,
	value = value,
	define = define,
	responder = responder,
}
