new Float:g_pos[3];
new Float:g_flOrigin[MAXPLAYERS+1][3];

stock TeleportToFront(player1, player2)
{
	new Float:velocity[3];
	velocity[0] = 0.0;
	velocity[1] = 0.0;
	velocity[2] = 0.0;
	
	decl Float:location[3], Float:ang[3], Float:location2[3];
	GetClientAbsOrigin(player1, location);
	GetClientEyeAngles(player1, ang);
	
	location2[0] = (location[0]+(50*(Cosine(DegToRad(ang[1])))));
	location2[1] = (location[1]+(50*(Sine(DegToRad(ang[1])))));
	location2[2] = location[2] - 1.0;
	
	if (!IsPlayerAlive(player2))
	{
		TF2_RespawnPlayer(player2);
	}
	
	TeleportEntity(player2, location2, NULL_VECTOR, velocity);
}

stock TeleportToEye(player1, player2)
{
	if (!SetTeleportEndPoint(player1))
	{
		CPrintToChat(player1, "[{green}Perks{default}] Could not find spawn point.");
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Perks] Could not find spawn point.");
	}
	
	g_pos[2] -= 10.0;
	if (!IsPlayerAlive(player2))
	{
		TF2_RespawnPlayer(player2);
	}
	
	TeleportEntity(player2, g_pos, NULL_VECTOR, NULL_VECTOR);
}

stock TeleportPlayerToSavedLocation(client)
{
	if (!IsPlayerAlive(client))
	{
		TF2_RespawnPlayer(client);
	}
	
	TeleportEntity(client, g_flOrigin[client], NULL_VECTOR, NULL_VECTOR);
}

stock SavePlayerLocation(client)
{
	if (IsValidClient(client) && IsPlayerAlive(client))
	{
		GetClientAbsOrigin(client, g_flOrigin[client]);
	}
}

stock SetTeleportEndPoint(client)
{
	decl Float:vAngles[3];
	decl Float:vOrigin[3];
	decl Float:vBuffer[3];
	decl Float:vStart[3];
	decl Float:Distance;
	
	GetClientEyePosition(client,vOrigin);
	GetClientEyeAngles(client, vAngles);
	
    //get endpoint for teleport
	new Handle:trace = TR_TraceRayFilterEx(vOrigin, vAngles, MASK_SHOT, RayType_Infinite, TraceEntityFilterPlayer);

	if(TR_DidHit(trace))
	{   	 
   	 	TR_GetEndPosition(vStart, trace);
		GetVectorDistance(vOrigin, vStart, false);
		Distance = -35.0;
   	 	GetAngleVectors(vAngles, vBuffer, NULL_VECTOR, NULL_VECTOR);
		g_pos[0] = vStart[0] + (vBuffer[0]*Distance);
		g_pos[1] = vStart[1] + (vBuffer[1]*Distance);
		g_pos[2] = vStart[2] + (vBuffer[2]*Distance);
	}
	else
	{
		CloseHandle(trace);
		return false;
	}
	
	CloseHandle(trace);
	return true;
}

public bool:TraceEntityFilterPlayer(entity, contentsMask)
{
	return entity > GetMaxClients() || !entity;
}
