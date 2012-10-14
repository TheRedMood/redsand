dofile(minetest.get_modpath("redsand").."/conf.lua")

-- !!! COMMANDS !!! ---

--[[ List function. ]]--
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
