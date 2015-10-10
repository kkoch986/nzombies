function nz.Doors.Functions.OpenDoor( ent )
	//Open the door and any other door with the same link
	ent:DoorUnlock()
	ent:SetNoDraw(true)
	ent:SetNotSolid(true)
	
	//Sync
	if ent.link != nil then
		nz.Doors.Data.OpenedLinks[ent.link] = true
		nz.Doors.Functions.SendSync()
	end
end

function nz.Doors.Functions.OpenLinkedDoors( link )
	//Go through all the doors
	for k,v in pairs(ents.GetAll()) do
		if v:IsDoor() or v:IsBuyableProp() then
			if v.link != nil then
				if link == v.link then
					nz.Doors.Functions.OpenDoor( v )
				end
			end
		end					
	end
end

function nz.Doors.Functions.LockAllDoors()
	//Force all doors to lock and stay open when opened
	for k,v in pairs(ents.GetAll()) do
		if v:IsDoor() or v:IsBuyableProp() then
			v:SetUseType( SIMPLE_USE )
			v:DoorLock()
			v:SetKeyValue("wait",-1)

			v:SetNoDraw(false)
			v:SetNotSolid(false)
		end
	end	
end

function nz.Doors.Functions.UnlockFreeDoors()
	//Force all doors to lock and stay open when opened
	for k,v in pairs(ents.GetAll()) do
		if v:IsDoor() or v:IsBuyableProp() then
			local price = v.price
			local req_elec = v.elec
			local link = v.link
			//If it has a price
			if (price == 0 or price == nil) and req_elec == 0 then
				if link == nil then
					nz.Doors.Functions.OpenDoor( v )
				else
					nz.Doors.Functions.OpenLinkedDoors( link )
				end
			end
		end
	end
end

function nz.Doors.Functions.BuyDoor( ply, ent )
	local price = ent.price
	local req_elec = ent.elec
	local link = ent.link
	//If it has a price
	if price != nil then
		if ply:CanAfford(price) and ent.Locked == true then
			//If this door doesnt require electricity or if it does, then if the electricity is on at the same time
			if (req_elec == 0 or (req_elec == 1 and IsElec())) then
				ply:TakePoints(price)
				if link == nil then
					nz.Doors.Functions.OpenDoor( ent )
				else
					nz.Doors.Functions.OpenLinkedDoors( link )
				end
			end
		end
	else
		nz.Doors.Functions.OpenDoor( ent )
	end
end


//Hooks

function nz.Doors.Functions.OnUseDoor( ply, ent )
	if ent:IsDoor() or ent:IsBuyableProp() then
		nz.Doors.Functions.BuyDoor( ply, ent )
	end
end

hook.Add( "PlayerUse", "player_buydoors", nz.Doors.Functions.OnUseDoor )