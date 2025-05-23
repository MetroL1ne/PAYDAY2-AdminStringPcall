-- // AdminStringPcall("managers.player:player_unit():character_damage():set_god_mode(true)")

function AdminStringPcall(func_str)
	local main, tb, func

	local main = string.match(func_str, "^([%w_]+)[%.%:]([%w_]+)")

	if main then
	    if main == "m" then
			main = "managers"
			func_str = string.gsub(func_str, "m", "managers", 1)
		elseif main == "exp_m" then
		    main = "managers"
			func_str = string.gsub(func_str, "exp_m", "managers.experience", 1)
		end

		tb = string.match(func_str, "^[%w_]+%.([^:]+):")
	end

	func = string.match(func_str, ":?([%w_]+)%(([^%)]*)%)") or
			string.match(func_str, ":([%w_]+)$") or
			string.match(func_str, "^([%w_]+)$")

	-- func
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
	elseif not main and func == "peer" then
	    main = "managers"
	    tb = "network._session"
		func = "peer"

		func_str = string.gsub(func_str, "peer", "managers.network._session:peer", 1)

	end

	func_str = FunctionStingGsub(func_str, "peer", "managers.network._session:peer")

	local chunk, err = loadstring("return " .. func_str)

	if chunk then
	    local success, result = pcall(chunk)
	    
	    if success and result then
			-- managers.mission._fading_debug_output:script().log(tostring(result), Color.white)
			managers.chat:send_message(1, managers.network.account:username() or "Offline", "Return: " .. tostring(result))
	    end
	else
		-- managers.mission._fading_debug_output:script().log(tostring(err), Color.white)
		managers.chat:send_message(1, managers.network.account:username() or "Offline", tostring(err))
	end
	managers.mission._fading_debug_output:script().log(tostring(func_str), Color.white)
end

function FunctionStingGsub(str, pattern, replacement)
	local org_long = #pattern
	local g_long = #replacement

	local pos = string.find(str, pattern, 1)
	local gsub_pos = 1

	local _gsub = function(_str, _pos, _pattern, _replacement)
		local prefix = string.sub(_str, 1, _pos - 1)
		local suffix = string.sub(_str, _pos)

		local replaced_suffix, n = string.gsub(suffix, _pattern, _replacement, 1)

		_str = prefix .. replaced_suffix

		_pos = _pos + #_replacement

		return _str, _pos
	end

	while pos do
		local i = 1
		::UP::
		if not string.match(string.sub(str, pos + org_long, pos + org_long), "%a") and 
		   not string.match(string.sub(str, pos + org_long, pos + org_long), "%d") 
		then
		        
			if string.sub(str, pos-i, pos-i) ~= "" then
				if string.sub(str, pos-i, pos-i) == "." or string.sub(str, pos-i, pos-i) == ":" then
					pos = pos + org_long
				elseif string.sub(str, pos-i, pos-i) == " " then
					i = i + 1
					goto UP
				elseif string.sub(str, pos-i, pos-i) == "," then
					str, pos = _gsub(str, pos, pattern, replacement)
				elseif string.match(string.sub(str, pos - 1, pos - 1), "%a") or 
		               string.match(string.sub(str, pos - 1, pos - 1), "%d") 
		        then
		               pos = pos + 1
				else
					str, pos = _gsub(str, pos, pattern, replacement)
				end
			else
				str, pos = _gsub(str, pos, pattern, replacement)
			end
		else
			pos = pos + org_long + 1
		end
		pos = string.find(str, pattern, pos)
	end
		
	return str
end
