//


function nz.Enemies.Functions.OnEnemyKilled(enemy, attacker)

	if attacker:IsPlayer() then
		attacker:GivePoints(nz.Config.PointsForKill)
		attacker:AddFrags(1)
	end

	nz.Rounds.Data.KilledZombies = nz.Rounds.Data.KilledZombies + 1
	//nz.Rounds.Data.ZombiesSpawned = nz.Rounds.Data.ZombiesSpawned - 1

	//Chance a powerup spawning
	if nz.PowerUps.Functions.IsPowerupActive("insta") == false and enemy:IsValid() then //Dont spawn powerups during instakill
		nz.PowerUps.Functions.SpawnPowerUp(enemy:GetPos())
	end

	print("Killed Enemy: " .. nz.Rounds.Data.KilledZombies .. "/" .. nz.Rounds.Data.MaxZombies )
end

function nz.Enemies.Functions.OnEnemyHurt(enemy, attacker, hitgroup, dmginfo)
	if attacker:IsPlayer() and enemy:IsValid() then

		if hitgroup == HITGROUP_HEAD then
			attacker:GivePoints(nz.Config.PointsForHeadshot)
		else
			attacker:GivePoints(nz.Config.PointsForHit)
		end

		hook.Run("EntityTakeDamagePost", enemy, dmginfo);

		if nz.PowerUps.Functions.IsPowerupActive("insta") then
			local insta = DamageInfo()
			insta:SetDamage(enemy:Health())
			insta:SetAttacker(attacker)
			insta:SetDamageType(DMG_BLAST_SURFACE)
			//Delay so it doesnt "die" twice
			timer.Simple(0.1, function() 
				if enemy:IsValid() and enemy:Health() > 0 then 
					enemy:TakeDamageInfo( insta ) 
					hook.Run("EntityTakeDamagePost", enemy, insta) 
				end 
			end)
		end
	end
end


function nz.Enemies.Functions.OnEntityCreated( ent )
	if ( ent:GetClass() == "prop_ragdoll" ) then
		ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	end
end

hook.Add("OnEntityCreated", "nz.Enemies.OnEntityCreated", nz.Enemies.Functions.OnEntityCreated)