stock EnableGodmode(client)
{
	SetEntProp(client, Prop_Data, "m_takedamage", 0, 1);
	CPrintToChat(client, "[{green}Perks{default}] Godmode Enabled");
	bWasEnabled[client][0] = true;
}

stock DisableGodmode(client)
{
	SetEntProp(client, Prop_Data, "m_takedamage", 2, 1);
	CPrintToChat(client, "[{green}Perks{default}] Godmode Disabled");
}

stock IsGodmodeOn(client)
{
	if (GetEntProp(client, Prop_Data, "m_takedamage", 1) == 0)
	{
		return true;
	}
	else
	{
		return false;
	}
}

stock IsGodmodeOff(client)
{
	if (GetEntProp(client, Prop_Data, "m_takedamage", 1) != 0)
	{
		return true;
	}
	else
	{
		return false;
	}
}

stock ToggleGodmode(client)
{
	if (IsGodmodeOn(client))
	{
		DisableGodmode(client);
	}
	else if (IsGodmodeOff(client))
	{
		EnableGodmode(client);
	}
}
