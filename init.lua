dofile(minetest.get_modpath("redsand").."/conf.lua")

-- !!! FUNCTIONS !!! --

-- Getting the player object.
function get_player_obj (name)
	goodname = string.match(name, "^([^ ]+) *$")
	if goodname == nil then
		print("ERROR!")
		return nil
	end

	-- Looping trough all the players currently online
	for _,player in ipairs(minetest.get_connected_players()) do
		local name = player:get_player_name()

		-- Caring about letters or not?
		if not careLetters then
			if string.lower(name) == string.lower(goodname) then
				return player
			end
		else
			if name == goodname then
				return player
			end
		end
	end
	return nil
end

-- !!! COMMANDS !!! ---

--[[ List function. ]]--
if useList then
	minetest.register_chatcommand("list", {
		params = "", -- short parameter description
		description = "List connected players", -- full description
		privs = listprivs, -- require the "privs" privilege to run
		func = function(name, param)
			local namelist, count = "", 0
			for _,player in ipairs(minetest.get_connected_players()) do
				local name = player:get_player_name()
				namelist = namelist .. string.format("%s, ", name)
				count = count + 1
			end
			minetest.chat_send_player(name, string.format("Current players online: %d", count))
			minetest.chat_send_player(name, string.format("Names: \[%s\]", namelist))
		end,
	})
end

--[[ Kill command ]]---
if useKill then
	minetest.register_chatcommand("kill", {
		params = "",
		description = "Kills you :(",
		privs = killprivs,
		func = function(name, param)
			local player = get_player_obj(name)
			player:set_hp(0.0)
		end,
	})
end

--[[ MSG command ]]---
if useMSG then
	minetest.register_chatcommand("msg", {
		params = "<target> <text>",
		description = "Talk to someone!",
		privs = msgprivs,
		func = function(name, param)
			if string.match(param, "([^ ]+) (.+)") == nil then
				minetest.chat_send_player(name, "Missing parameters")
				return
			end

			-- Generating the variables out of the parameters
			local targetName, msg = string.match(param, "([^ ]+) (.+)")
			target = get_player_obj(targetName)

			-- Checking if the target exists
			if not target then
				minetest.chat_send_player(name, "The target was not found")
				return
			end

			-- Sending the message
			minetest.chat_send_player(target:get_player_name(), string.format("From %s: %s", name, msg))
		end,
	})
end
-- !!! EVENTS !!! --

--[[ What happens when a player joins? ]]--
if useMOTD then
	minetest.register_on_joinplayer( function(player)
		minetest.after( 2.0, function(param)
			minetest.chat_send_player(player:get_player_name(), string.format(MOTD, player:get_player_name()))
		end )
	end )
end

--[[ What happens when a player die? ]]--
if useDeathMSG then
	minetest.register_on_dieplayer( function(player)
		minetest.chat_send_all(string.format(DEATH_MSG, player:get_player_name()))
	end )
end

--[[ What happens when a player respawn ]]--
if useReviveMSG then
	minetest.register_on_respawnplayer( function(player)
		minetest.chat_send_all(string.format(REVIVE_MSG, player:get_player_name()))
	end )
end
