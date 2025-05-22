function AdminStringPcall(func_str)
	local main, tb, func

	local main = string.match(func_str, "^([%w_]+)%.([%w_]+)")

	if main then
	    if main == "m" then
			func_str = string.gsub(func_str, "m", "managers", 1)
			main = "managers"
		end

		tb = string.match(func_str, "^[%w_]+%.([^:]+):")
	end
	    
	func = string.match(func_str, ":?([%w_]+)%(([^%)]*)%)") or
			string.match(func_str, ":([%w_]+)$") or
			string.match(func_str, "^([%w_]+)$")

	if func == "pu" then
	    main = "managers"
	    tb = "player"
	    func = "player_unit"

	    func_str = string.gsub(func_str, "pu", "managers.player:player_unit", 1)
	elseif func == "cd" then
	    main = "managers"
	    tb = "player"
	    func = "player_unit"

	    func_str = string.gsub(func_str, "cd", "managers.player:player_unit():character_damage", 1)
	elseif func == "peer" then
	    main = "managers"
	    tb = "network._session"
		func = "peer"

		func_str = string.gsub(func_str, "peer", "managers.network._session:peer", 1)
	end


	local chunk, err = loadstring("return " .. func_str)

	if chunk then
	    local success, result = pcall(chunk)
	    
	    if success and result then
			-- managers.mission._fading_debug_output:script().log(tostring(result), Color.white)
			managers.chat:send_message(1, managers.network.account:username() or "Offline", tostring(result))
	    end
	else
		-- managers.mission._fading_debug_output:script().log(tostring(err), Color.white)
		managers.chat:send_message(1, managers.network.account:username() or "Offline", tostring(err))
	end
end
