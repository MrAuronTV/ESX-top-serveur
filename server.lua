ESX             = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TOKEN = "TON TOKEN TOP SERVEUR"

RegisterServerEvent('vote:info')
AddEventHandler('vote:info', function(pseudo,id)
	-- Si les votant sont connecté au moment du cron vote
	local xPlayer = ESX.GetPlayerFromId(id)
	-- Give au Joueur
	xPlayer.addInventoryItem('bread', 1) -- Donne 1 Pain
	xPlayer.addMoney(500) -- Donne 500$
	-- Notification au Joueur
	TriggerClientEvent('esx:showNotification', id, 'Merci pour ton vote!')
end)

RegisterServerEvent('vote:offline')
AddEventHandler('vote:offline', function(pseudo,id) 
	-- Si les votant sont pas connecté au moment du cron vote
	local test = MySQL.Sync.fetchAll('SELECT * from users WHERE name = @name', {
	['@name'] = pseudo
	})
	
	for i=1, #test, 1 do
	money = test[1].money + 850 -- Ajoute 850$ au porte monnaie
	-- MISE A JOUR EN BDD
	MySQL.Sync.execute('UPDATE users SET money = @money WHERE name = @name', {
	['@money'] = money,
	['@name'] = pseudo
	})	
	end
end)

function vote(d,m,h)
	-- On télécharge les votes et extrait depuis l'api top serveur
	PerformHttpRequest("https://api.top-serveurs.net/v1/votes/last?server_token=".. TOKEN, function (errorCode, resultData, resultHeaders)	
		SaveResourceFile(GetCurrentResourceName(), "last.txt",resultData)
		local tbl = {}
		local loadFile = LoadResourceFile(GetCurrentResourceName(), "last.txt")
		local extract = {}
		extract = json.decode(loadFile)
		for k,v in pairs(extract) do
			if k == "votes" then
				for a,b in pairs(v) do
					table.insert(tbl, b.playername)
				end
			end
		end
		
		-- On check si des gens sont connecté ou si le serveur est vide
		local onlinePlayers = GetNumPlayerIndices()
		
		if onlinePlayers ~= 0 then
			-- Il y a au moins une personne sur le serveur
			for _, playerId in ipairs(GetPlayers()) do
				player = playerId
				name = GetPlayerName(playerId)
				if name ~= nil or name == 0 then
					for _, user in ipairs(tbl) do
						if user == name then
							-- Give au votant en ligne
							TriggerEvent('vote:info',name,player)
						else
							-- Give au votant hors ligne
							TriggerEvent('vote:offline',user,player)
						end
					end
				end
			end
		else
			-- Il y a personne sur le serveur
			-- Give au votant hors ligne
			for _, user in ipairs(tbl) do
				TriggerEvent('vote:offline',user)
			end 
		end
	end)
end

--VOTE A L'HEURE AVEC CRON
TriggerEvent('cron:runAt', 0, 30, vote)
TriggerEvent('cron:runAt', 1, 30, vote)
TriggerEvent('cron:runAt', 2, 30, vote)
TriggerEvent('cron:runAt', 3, 30, vote)
TriggerEvent('cron:runAt', 4, 30, vote)
TriggerEvent('cron:runAt', 5, 30, vote)
TriggerEvent('cron:runAt', 6, 30, vote)
TriggerEvent('cron:runAt', 7, 30, vote)
TriggerEvent('cron:runAt', 8, 30, vote)
TriggerEvent('cron:runAt', 9, 30, vote)
TriggerEvent('cron:runAt', 13, 30, vote)
TriggerEvent('cron:runAt', 11, 30, vote)
TriggerEvent('cron:runAt', 12, 30, vote)
TriggerEvent('cron:runAt', 13, 30, vote)
TriggerEvent('cron:runAt', 14, 30, vote)
TriggerEvent('cron:runAt', 15, 30, vote)
TriggerEvent('cron:runAt', 16, 30, vote)
TriggerEvent('cron:runAt', 17, 30, vote)
TriggerEvent('cron:runAt', 18, 30, vote)
TriggerEvent('cron:runAt', 19, 30, vote)
TriggerEvent('cron:runAt', 23, 30, vote)
TriggerEvent('cron:runAt', 21, 30, vote)
TriggerEvent('cron:runAt', 22, 30, vote)
TriggerEvent('cron:runAt', 23, 30, vote)