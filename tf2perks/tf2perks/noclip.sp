stock EnableNoclip(client)
{
	SetEntProp(client, Prop_Send, "movetype", 8, 1);
	CPrintToChat(client, "[{green}Perks{default}] Noclip Enabled");
	bWasEnabled[client][2] = true;
}

stock DisableNoclip(client)
{
	SetEntProp(client, Prop_Send, "movetype", 2, 1);
	CPrintToChat(client, "[{green}Perks{default}] Noclip Disabled");
}

stock IsNoclipOn(client)
{
	if (GetEntProp(client, Prop_Send, "movetype", 1) == 8)
	{
		return true;
	}
	else
	{
		return false;
	}
}

stock IsNoclipOff(client)
{
	if (GetEntProp(client, Prop_Send, "movetype", 1) == 2)
	{
		return true;
	}
	else
	{
		return false;
	}
}

stock ToggleNoclip(client)
{
	if (IsNoclipOn(client))
	{
		DisableNoclip(client);
	}
	else if (IsNoclipOff(client))
	{
		EnableNoclip(client);
	}
}
