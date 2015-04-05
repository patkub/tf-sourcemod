new OffAW = -1;
new bool:g_bROFSpeedEnabled[MAXPLAYERS+1] = false;
new Float:g_fROFMulti[MAXPLAYERS+1] = 1.0;

stock ModRateOfFire(client, Float:ROFMulti)
{
	if (ROFMulti == 1)
	{
		g_bROFSpeedEnabled[client] = false;
	}
	else
	{
		g_bROFSpeedEnabled[client] = true;
	}
	g_fROFMulti[client] = ROFMulti;
	
	new ent = GetEntDataEnt2(client, OffAW);
	if (ent != -1)
	{
		new Float:m_flNextPrimaryAttack = GetEntPropFloat(ent, Prop_Send, "m_flNextPrimaryAttack");
		new Float:m_flNextSecondaryAttack = GetEntPropFloat(ent, Prop_Send, "m_flNextSecondaryAttack");
		
		if (ROFMulti > 12)
		{
			SetEntPropFloat(ent, Prop_Send, "m_flPlaybackRate", 12.0);
		}
		else
		{
			SetEntPropFloat(ent, Prop_Send, "m_flPlaybackRate", ROFMulti);
		}
		
		new Float:GameTime = GetGameTime();
		
		new Float:PeTime = (m_flNextPrimaryAttack - GameTime) - ((ROFMulti - 1.0) / 50);
		new Float:SeTime = (m_flNextSecondaryAttack - GameTime) - ((ROFMulti - 1.0) / 50);
		new Float:FinalP = PeTime+GameTime;
		new Float:FinalS = SeTime+GameTime;
		
		SetEntPropFloat(ent, Prop_Send, "m_flNextPrimaryAttack", FinalP);
		SetEntPropFloat(ent, Prop_Send, "m_flNextSecondaryAttack", FinalS);
	}
}
