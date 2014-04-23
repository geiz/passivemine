function copy (t)  -- returns a copy of table t. Preserves metatable reference and list length property.
	local u = {}
	
	setmetatable (u, getmetatable (t))  -- copy metatable reference
	
	local i = 1
	while rawget (t, i) ~= nil do   -- numeric indices
		table.insert (u, rawget(t, i))
		i = i + 1
	end
	
	for k, v in pairs (t) do  -- all other indices
		if u[k] == nil then u[k] = v end  -- copy value if index k is not already in the table
	end
	
	return u
	--[[ It is possible to get unusual results from this function if there are unusual things
		in t's metatable. Particularly, overriding __next, __pairs, or __metatable in the metatable
		could lead to unusual results. For example, anything returned from pairs() ends up
		in u, whether or not the pair was literally present in t. This may or may not be a
		problem depending on whether the operations of __index and __newindex are consistent
		with the operation of __pairs. Also, if __metatable is present, it is assigned as u's
		metatable directly.
		]]
end

return {
	copy = copy
}
