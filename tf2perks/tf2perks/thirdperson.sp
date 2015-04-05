new bool:g_bThirdPersonEnabled[MAXPLAYERS+1] = false;

stock EnableThirdPerson(client)
{
	SetVariantInt(1);
	AcceptEntityInput(client, "SetForcedTauntCam");
	g_bThirdPersonEnabled[client] = true;
	CPrintToChat(client, "[{green}Perks{default}] Third Person Enabled");
	bWasEnabled[client][4] = true;
}

stock DisableThirdPerson(client)
{
	SetVariantInt(0);
	AcceptEntityInput(client, "SetForcedTauntCam");
	g_bThirdPersonEnabled[client] = false;
	CPrintToChat(client, "[{green}Perks{default}] Third Person Disabled");
}

stock IsThirdPersonOn(client)
{
	if (g_bThirdPersonEnabled[client])
	{
		return true;
	}
	else
	{
		return false;
	}
}

stock IsThirdPersonOff(client)
{
	if (g_bThirdPersonEnabled[client])
	{
		return false;
	}
	else
	{
		return true;
	}
}

stock ToggleThirdPerson(client)
{
	if (g_bThirdPersonEnabled[client])
	{
		DisableThirdPerson(client);
	}
	else
	{
		EnableThirdPerson(client);
	}
}
