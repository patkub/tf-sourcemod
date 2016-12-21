#pragma semicolon 1
#include <sourcemod>
#include <tf2>

#define PLUGIN_VERSION		"1.0"

new Handle:RespawnTimeBlue = INVALID_HANDLE;
new Handle:RespawnTimeRed = INVALID_HANDLE;

public Plugin:myinfo =
{
	name = "[TF2] Respawn",
	author = "Patka",
	description = "Change respawn time.",
	version = PLUGIN_VERSION,
	url = "http://forums.alliedmods.net"
};

public OnPluginStart()
{
	LoadTranslations("common.phrases");
	HookEvent("player_death", EventPlayerDeath);
	CreateConVar("tf_respawn_version", PLUGIN_VERSION, "TF2 Respawn plugin version.", FCVAR_PLUGIN|FCVAR_NOTIFY|FCVAR_REPLICATED);
	RespawnTimeBlue = CreateConVar("sm_respawn_time_blue", "10.0", "Respawn time for Blue team", FCVAR_PLUGIN|FCVAR_NOTIFY);
	RespawnTimeRed = CreateConVar("sm_respawn_time_red", "10.0", "Respawn time for Red team", FCVAR_PLUGIN|FCVAR_NOTIFY);
}

public Action:EventPlayerDeath(Handle:event, const String:name[], bool:dontBroadcast)
{
	new userid = GetEventInt(event, "userid");
	new client = GetClientOfUserId(userid);
	new team = GetClientTeam(client);
	new Float:RespawnTime;
	
	switch(team)
	{
		case TFTeam_Blue:
		{
			RespawnTime = GetConVarFloat(RespawnTimeBlue);
		}
		
		case TFTeam_Red:
		{
			RespawnTime = GetConVarFloat(RespawnTimeRed);
		}
		
		default:
		{
			return Plugin_Continue;
		}
	}
	
	CreateTimer(RespawnTime, SpawnPlayerTimer, client, TIMER_FLAG_NO_MAPCHANGE);
	return Plugin_Continue;
}

public Action:SpawnPlayerTimer(Handle:timer, any:client)
{
    if (IsValidClient(client) && !IsPlayerAlive(client))
	{
		TF2_RespawnPlayer(client);
	}
    return Plugin_Continue;
}

/**
 * Checks if client is in-game/valid.
 *
 * @param iClient			Client Index.
 * @return					True if valid, false otherwise.
 */
stock bool:IsValidClient(iClient)
{
	if (iClient <= 0) return false;
	if (iClient > MaxClients) return false;
	return IsClientInGame(iClient);
}
