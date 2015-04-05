new bool:bInfiniteAmmo[MAXPLAYERS+1] = false;
new Ammo[MAXPLAYERS+1];
new Clip[MAXPLAYERS+1];
new Metal[MAXPLAYERS+1];

stock EnableAmmo(client)
{
	bInfiniteAmmo[client] = true;
	Metal[client] = GetMetal(client);
	SetChargeMeter(client, 100.0);
	CPrintToChat(client, "[{green}Perks{default}] Infinite Ammo Enabled");
}

stock DisableAmmo(client)
{
	bInfiniteAmmo[client] = false;
	CPrintToChat(client, "[{green}Perks{default}] Infinite Ammo Disabled");
}

stock ToggleAmmo(client)
{
	if (bInfiniteAmmo[client])
	{
		DisableAmmo(client);
	}
	else
	{
		EnableAmmo(client);
	}
}

stock GetAmmo(client, weapon)
{
	new ammo = -1;
	if (IsValidEntity(weapon))
	{
		new iOffset = GetEntProp(weapon, Prop_Send, "m_iPrimaryAmmoType", 1)*4;
		new iAmmoTable = FindSendPropInfo("CTFPlayer", "m_iAmmo");
		ammo = GetEntData(client, iAmmoTable+iOffset, 4);
	}
	return ammo;
}

stock SetAmmo(client, weapon, newAmmo)
{
	if (IsValidEntity(weapon))
	{
		new iOffset = GetEntProp(weapon, Prop_Send, "m_iPrimaryAmmoType", 1)*4;
		new iAmmoTable = FindSendPropInfo("CTFPlayer", "m_iAmmo");
		SetEntData(client, iAmmoTable+iOffset, newAmmo, 4, true);
	}
}

stock GetClip(client, weapon)
{
	new clip = -1;
	if (IsValidEntity(weapon))
	{
		new iAmmoTable = FindSendPropInfo("CTFWeaponBase", "m_iClip1");
		clip = GetEntData(weapon, iAmmoTable, 4);
	}
	return clip;
}

stock SetClip(client, weapon, newClip)
{
	if (IsValidEntity(weapon))
	{
		new iAmmoTable = FindSendPropInfo("CTFWeaponBase", "m_iClip1");
		SetEntData(weapon, iAmmoTable, newClip, 4, true);
	}
}

stock GetMetal(client)
{
	return GetEntProp(client, Prop_Data, "m_iAmmo", 4, 3);
}

stock SetMetal(client, NewMetal)
{
	SetEntProp(client, Prop_Data, "m_iAmmo", NewMetal, 4, 3);
}

stock Float:GetDrinkMeter(client)
{
	return GetEntPropFloat(client, Prop_Send, "m_flEnergyDrinkMeter");
}

stock SetDrinkMeter(client, Float:flNewDrink)
{
	SetEntPropFloat(client, Prop_Send, "m_flEnergyDrinkMeter", flNewDrink);
}

stock Float:GetHypeMeter(client)
{
	return GetEntPropFloat(client, Prop_Send, "m_flHypeMeter");
}

stock SetHypeMeter(client, Float:flNewHype)
{
	SetEntPropFloat(client, Prop_Send, "m_flHypeMeter", flNewHype);
}

stock Float:GetRageMeter(client)
{
	return GetEntPropFloat(client, Prop_Send, "m_flRageMeter");
}

stock SetRageMeter(client, Float:flNewRage)
{
	SetEntPropFloat(client, Prop_Send, "m_flRageMeter", flNewRage);
}

stock Float:GetChargeMeter(client)
{
	return GetEntPropFloat(client, Prop_Send, "m_flChargeMeter");
}

stock SetChargeMeter(client, Float:flNewChargeMeter)
{
	SetEntPropFloat(client, Prop_Send, "m_flChargeMeter", flNewChargeMeter);
}

stock Float:GetUberCharge(weapon)
{
	new Float:flCharge = 0.0;
	if (IsValidEntity(weapon))
	{
		flCharge = GetEntPropFloat(weapon, Prop_Send, "m_flChargeLevel");
	}
	return flCharge;
}

stock SetUberCharge(weapon, Float:flNewUberCharge)
{
	if (IsValidEntity(weapon))
	{
		if (GetEntPropFloat(weapon, Prop_Send, "m_flChargeLevel"))
		{
			SetEntPropFloat(weapon, Prop_Send, "m_flChargeLevel", flNewUberCharge);
		}
	}
}

stock Float:GetCloakMeter(client)
{
	return GetEntPropFloat(client, Prop_Send, "m_flCloakMeter");	
}

stock SetCloakMeter(client, Float:flNewCloak)
{
	SetEntPropFloat(client, Prop_Send, "m_flCloakMeter", flNewCloak);	
}
