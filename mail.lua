--[[
	Setup: Have a file called "mails.txt" and have it store all the messages as they are sent.
	Problems: If this is exploited, say by sending to many messages, it could severly slowdown
			  the server. Need to find a regex to keep track of this, but just once per server
			  life cycle.
			  
	Solving: It would read from the file once a player logs on and send him a message if there is any
			 Messages in there for him. Messages would also have to be restricted in some way, so people
			 can't send extremly large messages to spam out the system. Then once  player does /mails it would
			 list them and the player could do /mail read <number> to read them. Doing this would clear the line
			 from the "mails.txt" file so that it doesn't stack up.
]]--

lol = io.open (minetest.get_modpath("redsand").."mails.txt")