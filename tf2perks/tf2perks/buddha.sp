stock EnableBuddha(client)
{
	SetEntProp(client, Prop_Data, "m_takedamage", 1, 1);
	CPrintToChat(client, "[{green}Perks{default}] Buddha Enabled");
	bWasEnabled[client][1] = true;
}

stock DisableBuddha(client)
{
	SetEntProp(client, Prop_Data, "m_takedamage", 2, 1);
	CPrintToChat(client, "[{green}Perks{default}] Buddha Disabled");
}

stock IsBuddhaOn(client)
{
	if (GetEntProp(client, Prop_Data, "m_takedamage", 1) == 1)
	{
		return true;
	}
	else
	{
		return false;
	}
}

stock IsBuddhaOff(client)
{
	if (GetEntProp(client, Prop_Data, "m_takedamage", 1) != 1)
	{
		return true;
	}
	else
	{
		return false;
	}
}

stock ToggleBuddha(client)
{
	if (IsBuddhaOn(client))
	{
		DisableBuddha(client);
	}
	else if (IsBuddhaOff(client))
	{
		EnableBuddha(client);
	}
}
