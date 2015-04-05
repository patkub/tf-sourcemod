new bool:g_bPowerPlayEnabled[MAXPLAYERS+1] = false;

stock EnablePowerPlay(client)
{
	TF2_SetPlayerPowerPlay(client, true);
	g_bPowerPlayEnabled[client] = true;
	CPrintToChat(client, "[{green}Perks{default}] PowerPlay Enabled");
	bWasEnabled[client][3] = true;
}

stock DisablePowerPlay(client)
{
	TF2_SetPlayerPowerPlay(client, false);
	g_bPowerPlayEnabled[client] = false;
	CPrintToChat(client, "[{green}Perks{default}] PowerPlay Disabled");
}

stock IsPowerPlayOn(client)
{
	if (g_bPowerPlayEnabled[client])
	{
		return true;
	}
	else
	{
		return false;
	}
}

stock IsPowerPlayOff(client)
{
	if (g_bPowerPlayEnabled[client])
	{
		return false;
	}
	else
	{
		return true;
	}
}

stock TogglePowerPlay(client)
{
	if (IsPowerPlayOn(client))
	{
		DisablePowerPlay(client);
	}
	else if (IsPowerPlayOff(client))
	{
		EnablePowerPlay(client);
	}
}
