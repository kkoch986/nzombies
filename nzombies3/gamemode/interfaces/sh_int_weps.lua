//

if SERVER then
	function nz.Interfaces.Functions.WepBuyHandler( ply, data )
		if ply:IsSuperAdmin() then
			nz.Mapping.Functions.WallBuy(data.vec, data.class, tonumber(data.price), data.ang)
		end
	end

	function nz.Interfaces.Functions.GiveWepHandler( ply, data )
		print(ply)
		ply:Give(data["Row1"])
	end
end

if CLIENT then
	function nz.Interfaces.Functions.WepBuy( data )

		local valz = {}
		valz["Row1"] = "weapon_class"
		valz["Row2"] = 500

		local DermaPanel = vgui.Create( "DFrame" )
		DermaPanel:SetPos( 100, 100 )
		DermaPanel:SetSize( 300, 180 )
		DermaPanel:SetTitle( "Add New Weapon" )
		DermaPanel:SetVisible( true )
		DermaPanel:SetDraggable( true )
		DermaPanel:ShowCloseButton( true )
		DermaPanel:MakePopup()
		DermaPanel:Center()

		local DProperties = vgui.Create( "DProperties", DermaPanel )
		DProperties:SetSize( 280, 220 )
		DProperties:SetPos( 10, 30 )

		local Row1 = DProperties:CreateRow( "Weapon Settings", "Weapon Class" )
		Row1:Setup( "Combo", {} )
		Row1:SetValue( valz["Row1"] )
		for k,v in pairs( weapons.GetList() ) do 
			if v.Spawnable then
				Row1:AddChoice(v.ClassName, v)
			end
		end
		Row1.DataChanged = function( _, val ) 
			PrintTable(val) 
			valz["Row1"] = val.ClassName 
		end


		local Row2 = DProperties:CreateRow( "Weapon Settings", "Price" )
		Row2:Setup( "Integer" )
		Row2:SetValue( valz["Row2"] )
		Row2.DataChanged = function( _, val ) valz["Row2"] = val end

		local GrabButton = vgui.Create( "DButton" )
		GrabButton:SetParent( DermaPanel )
		GrabButton:SetText( "Test Drive" )
		GrabButton:SetPos( 10, 100 )
		GrabButton:SetSize( 280, 30 )
		GrabButton.DoClick = function()

			//Check the weapon class is fine first
			if weapons.Get( valz["Row1"] ) != nil then
				nz.Interfaces.Functions.SendRequests( "GiveWep", valz )
			end

		end


		local DermaButton = vgui.Create( "DButton" )
		DermaButton:SetParent( DermaPanel )
		DermaButton:SetText( "Submit" )
		DermaButton:SetPos( 10, 140 )
		DermaButton:SetSize( 280, 30 )
		DermaButton.DoClick = function()

			//Check the weapon class is fine first
			if weapons.Get( valz["Row1"] ) != nil then
				data.class = valz["Row1"]
				data.price = tostring(valz["Row2"])
				PrintTable(data)
				nz.Interfaces.Functions.SendRequests( "WepBuy", data )

				DermaPanel:Close()
			end

		end
	end
end
