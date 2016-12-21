#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <morecolors>
#include <tf2>
#include <tf2_stocks>
#undef REQUIRE_PLUGIN

#define PLUGIN_VERSION		"1.0"

#define ENABLE_GODMODE
#define ENABLE_BUDDHA
#define ENABLE_NOCLIP
#define ENABLE_POWERPLAY
#define ENABLE_THIRDPERSON
#define ENABLE_AMMO
#define ENABLE_HEALTH
#define ENABLE_TELEPORT
#define ENABLE_ROF
#define ENABLE_SIZE

new bool:bWasEnabled[MAXPLAYERS+1][5];

#if defined ENABLE_GODMODE
#include "tf2perks/godmode.sp"
#endif

#if defined ENABLE_BUDDHA
#include "tf2perks/buddha.sp"
#endif

#if defined ENABLE_NOCLIP
#include "tf2perks/noclip.sp"
#endif

#if defined ENABLE_POWERPLAY
#include "tf2perks/powerplay.sp"
#endif

#if defined ENABLE_THIRDPERSON
#include "tf2perks/thirdperson.sp"
#endif

#if defined ENABLE_AMMO
#include "tf2perks/ammo.sp"
#endif

#if defined ENABLE_HEALTH
#include "tf2perks/health.sp"
#endif

#if defined ENABLE_TELEPORT
#include "tf2perks/teleport.sp"
#endif

#if defined ENABLE_ROF
#include "tf2perks/rof.sp"
#endif

#if defined ENABLE_SIZE
#include "tf2perks/size.sp"
#endif

public Plugin:myinfo =
{
	name = "TF2 Perk Functions",
	author = "Patka",
	description = "TF2 perk functions.",
	version = PLUGIN_VERSION,
	url = "http://forums.alliedmods.net"
};

public OnPluginStart()
{
	LoadTranslations("common.phrases");
	CreateConVar("tf_perk_functions_version", PLUGIN_VERSION, "TF2 Perk Functions plugin version.", FCVAR_PLUGIN|FCVAR_NOTIFY|FCVAR_REPLICATED);
	#if defined ENABLE_AMMO || defined ENABLE_ROF
	OffAW = FindSendPropInfo("CBasePlayer", "m_hActiveWeapon");
	#endif
	HookEvent("player_spawn", Event_PlayerSpawn);
}

public OnClientPostAdminCheck(client)
{
	#if defined ENABLE_POWERPLAY
	g_bPowerPlayEnabled[client] = false;
	#endif
	
	#if defined ENABLE_THIRDPERSON
	g_bThirdPersonEnabled[client] = false;
	#endif
	
	#if defined ENABLE_AMMO
	SDKHook(client, SDKHook_PreThink, OnPreThink);
	bInfiniteAmmo[client] = false;
	Ammo[client] = -1;
	Clip[client] = -1;
	Metal[client] = -1;
	#endif
	
	#if defined ENABLE_ROF
	g_bROFSpeedEnabled[client] = false;
	g_fROFMulti[client] = 1.0;
	#endif
	
	for (new i = 0; i < 5; i++)
	{
		bWasEnabled[client][i] = false;
	}
}

public OnPreThink(client)
{
	#if defined ENABLE_AMMO
	new wep = GetEntDataEnt2(client, OffAW);
	if (wep != -1)
	{
		Ammo[client] = GetAmmo(client, wep);
		Clip[client] = GetClip(client, wep);
	}
	
	if (bInfiniteAmmo[client])
	{
		new TFClassType:class = TF2_GetPlayerClass(client);
		switch (class)
		{
			case TFClass_Scout:
			{
				SetDrinkMeter(client, 100.0);
				SetHypeMeter(client, 100.0);
			}
			
			case TFClass_Soldier:
			{
				if (!GetRageMeter(client))
				{
					SetRageMeter(client, 100.0);
				}
			}
			
			case TFClass_Engineer:
			{
				if (Metal[client] != -1)
				{
					SetMetal(client, Metal[client]);
				}
			}
			
			case TFClass_Medic:
			{
				SetUberCharge(wep, 100.0);
			}
			
			case TFClass_Spy:
			{
				SetCloakMeter(client, 100.0);
			}
		}
	}
	#endif
}

public OnGameFrame()
{
	#if defined ENABLE_ROF
	for (new i = 1; i <= MaxClients; i++)
	{
		if (g_bROFSpeedEnabled[i] && IsClientInGame(i) && IsPlayerAlive(i))
		{
			ModRateOfFire(i, g_fROFMulti[i]);
		}
	}
	#endif
}

public Action:OnPlayerRunCmd(client, &buttons, &impulse, Float:vel[3], Float:angles[3], &weapon)
{
	#if defined ENABLE_AMMO
	if (bInfiniteAmmo[client])
	{
		if (buttons & IN_ATTACK)
		{
			new wep = GetEntDataEnt2(client, OffAW);
			if (wep != -1)
			{
				new index = GetEntProp(wep, Prop_Send, "m_iItemDefinitionIndex");
				switch (index)
				{
					//Ullapool Caber - Detonation Reset
					case 307:
					{
						SetEntProp(wep, Prop_Send, "m_bBroken", 0);
						SetEntProp(wep, Prop_Send, "m_iDetonated", 0);
					}
					
					//Spycicle - Recharge Time
					case 649:
					{
						SetEntPropFloat(wep, Prop_Send, "m_flKnifeRegenerateDuration", 0.0);
					}
					
					//Beggar's Bazooka
					case 730:
					{
						return Plugin_Continue;
					}
					
					default:
					{
						if (Ammo[client] != -1)
						{
							SetAmmo(client, wep, Ammo[client]);
						}
						
						if (Clip[client] != -1)
						{
							SetClip(client, wep, Clip[client]);
						}
					}
				}
			}
		}
		
		if (buttons & IN_ATTACK2)
		{
			new wep = GetEntDataEnt2(client, OffAW);
			if (wep != -1)
			{
				if (Ammo[client] != -1)
				{
					SetAmmo(client, wep, Ammo[client]);
				}
				
				if (Clip[client] != -1)
				{
					SetClip(client, wep, Clip[client]);
				}
			}
			
			TF2_RemoveCondition(client, TFCond_Bonked);
			TF2_RemoveCondition(client, TFCond_CritCola);
			TF2_RemoveCondition(client, TFCond_CritHype);
		}
	}
	
	return Plugin_Continue;
	#endif
}

public TF2_OnConditionRemoved(client, TFCond:condition)
{
	#if defined ENABLE_AMMO
	if (bInfiniteAmmo[client] && condition == TFCond_Charging)
	{
		SetChargeMeter(client, 100.0);
	}
	#endif
}

public Action:Event_PlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	new userid = GetEventInt(event, "userid");
	new client = GetClientOfUserId(userid);
	
	for (new i = 0; i < 5; i++)
	{
		bWasEnabled[client][i] = false;
	}
	
	if (g_bThirdPersonEnabled[client])
	{
		CreateTimer(0.2, SetViewOnSpawn, client);
	}
	
	return Plugin_Continue;
}

public Action:SetViewOnSpawn(Handle:timer, any:client)
{
	if (IsValidClient(client) && IsPlayerAlive(client))
	{
		EnableThirdPerson(client);
	}
}

public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	CreateNative("TF2Perks_EnablePerk", Native_EnablePerk);
	CreateNative("TF2Perks_DisablePerk", Native_DisablePerk);
	CreateNative("TF2Perks_IsPerkOn", Native_IsPerkOn);
	CreateNative("TF2Perks_IsPerkOff", Native_IsPerkOff);
	CreateNative("TF2Perks_TogglePerk", Native_TogglePerk);
	CreateNative("TF2Perks_bWasEnabled", Native_bWasEnabled);
	
	#if defined ENABLE_AMMO
	CreateNative("TF2Perks_EnableAmmo", Native_EnableAmmo);
	CreateNative("TF2Perks_DisableAmmo", Native_DisableAmmo);
	CreateNative("TF2Perks_ToggleAmmo", Native_ToggleAmmo);
	CreateNative("TF2Perks_GetAmmo", Native_GetAmmo);
	CreateNative("TF2Perks_SetAmmo", Native_SetAmmo);
	CreateNative("TF2Perks_GetClip", Native_GetClip);
	CreateNative("TF2Perks_SetClip", Native_SetClip);
	CreateNative("TF2Perks_GetMetal", Native_GetMetal);
	CreateNative("TF2Perks_SetMetal", Native_SetMetal);
	CreateNative("TF2Perks_GetDrinkMeter", Native_GetDrinkMeter);
	CreateNative("TF2Perks_SetDrinkMeter", Native_SetDrinkMeter);
	CreateNative("TF2Perks_GetHypeMeter", Native_GetHypeMeter);
	CreateNative("TF2Perks_SetHypeMeter", Native_SetHypeMeter);
	CreateNative("TF2Perks_GetRageMeter", Native_GetRageMeter);
	CreateNative("TF2Perks_SetRageMeter", Native_SetRageMeter);
	CreateNative("TF2Perks_GetChargeMeter", Native_GetChargeMeter);
	CreateNative("TF2Perks_SetChargeMeter", Native_SetChargeMeter);
	CreateNative("TF2Perks_GetUberCharge", Native_GetUberCharge);
	CreateNative("TF2Perks_SetUberCharge", Native_SetUberCharge);
	CreateNative("TF2Perks_GetCloakMeter", Native_GetCloakMeter);
	CreateNative("TF2Perks_SetCloakMeter", Native_SetCloakMeter);
	#endif
	
	#if defined ENABLE_HEALTH
	CreateNative("TF2Perks_GetHealth", Native_GetHealth);
	CreateNative("TF2Perks_SetHealth", Native_SetHealth);
	#endif
	
	#if defined ENABLE_TELEPORT
	CreateNative("TF2Perks_Teleport", Native_Teleport);
	CreateNative("TF2Perks_SaveLocation", Native_SaveLocation);
	CreateNative("TF2Perks_TeleportToSavedLocation", Native_TeleportToSavedLocation);
	#endif
	
	#if defined ENABLE_ROF
	CreateNative("TF2Perks_ModRateOfFire", Native_ModRateOfFire);
	#endif
	
	#if defined ENABLE_SIZE
	CreateNative("TF2Perks_ResizePlayer", Native_ResizePlayer);
	#endif
	
	RegPluginLibrary("tf2perks");
	return APLRes_Success;
}

public Native_EnablePerk(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new length;
	GetNativeStringLength(2, length);
	new String:strPerk[length+1];
	GetNativeString(2, strPerk, length+1);
	
	if (!(IsValidClient(client) || IsPlayerAlive(client)))
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Perks] Invalid/dead target (%d) at the moment", client);
	}
	
	#if defined ENABLE_GODMODE
	if (strcmp(strPerk, "godmode") == 0)
	{
		EnableGodmode(client);
	}
	#endif
	#if defined ENABLE_BUDDHA
	else if (strcmp(strPerk, "buddha") == 0)
	{
		EnableBuddha(client);
	}
	#endif
	#if defined ENABLE_NOCLIP
	else if (strcmp(strPerk, "noclip") == 0)
	{
		EnableNoclip(client);
	}
	#endif
	#if defined ENABLE_POWERPLAY
	else if (strcmp(strPerk, "powerplay") == 0)
	{
		EnablePowerPlay(client);
	}
	#endif
	#if defined ENABLE_THIRDPERSON
	else if (strcmp(strPerk, "thirdperson") == 0)
	{
		EnableThirdPerson(client);
	}
	#endif
	else
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Perks] Invalid Parameter 2 strPerk: %s", strPerk);
	}
}

public Native_DisablePerk(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new length;
	GetNativeStringLength(2, length);
	new String:strPerk[length+1];
	GetNativeString(2, strPerk, length+1);
	
	if (!(IsValidClient(client) || IsPlayerAlive(client)))
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Perks] Invalid/dead target (%d) at the moment", client);
	}
	
	#if defined ENABLE_GODMODE
	if (strcmp(strPerk, "godmode") == 0)
	{
		DisableGodmode(client);
	}
	#endif
	#if defined ENABLE_BUDDHA
	else if (strcmp(strPerk, "buddha") == 0)
	{
		DisableBuddha(client);
	}
	#endif
	#if defined ENABLE_NOCLIP
	else if (strcmp(strPerk, "noclip") == 0)
	{
		DisableNoclip(client);
	}
	#endif
	#if defined ENABLE_POWERPLAY
	else if (strcmp(strPerk, "powerplay") == 0)
	{
		DisablePowerPlay(client);
	}
	#endif
	#if defined ENABLE_THIRDPERSON
	else if (strcmp(strPerk, "thirdperson") == 0)
	{
		DisableThirdPerson(client);
	}
	#endif
	else
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Perks] Invalid Parameter 2 strPerk: %s", strPerk);
	}
}

public Native_IsPerkOn(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new length;
	GetNativeStringLength(2, length);
	new String:strPerk[length+1];
	GetNativeString(2, strPerk, length+1);
	
	if (!(IsValidClient(client) || IsPlayerAlive(client)))
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Perks] Invalid/dead target (%d) at the moment", client);
	}
	
	#if defined ENABLE_GODMODE
	if (strcmp(strPerk, "godmode") == 0)
	{
		IsGodmodeOn(client);
	}
	#endif
	#if defined ENABLE_BUDDHA
	else if (strcmp(strPerk, "buddha") == 0)
	{
		IsBuddhaOn(client);
	}
	#endif
	#if defined ENABLE_NOCLIP
	else if (strcmp(strPerk, "noclip") == 0)
	{
		IsNoclipOn(client);
	}
	#endif
	#if defined ENABLE_POWERPLAY
	else if (strcmp(strPerk, "powerplay") == 0)
	{
		IsPowerPlayOn(client);
	}
	#endif
	#if defined ENABLE_THIRDPERSON
	else if (strcmp(strPerk, "thirdperson") == 0)
	{
		IsThirdPersonOn(client);
	}
	#endif
	else
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Perks] Invalid Parameter 2 strPerk: %s", strPerk);
	}
}

public Native_IsPerkOff(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new length;
	GetNativeStringLength(2, length);
	new String:strPerk[length+1];
	GetNativeString(2, strPerk, length+1);
	
	if (!(IsValidClient(client) || IsPlayerAlive(client)))
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Perks] Invalid/dead target (%d) at the moment", client);
	}
	
	#if defined ENABLE_GODMODE
	if (strcmp(strPerk, "godmode") == 0)
	{
		IsGodmodeOff(client);
	}
	#endif
	#if defined ENABLE_BUDDHA
	else if (strcmp(strPerk, "buddha") == 0)
	{
		IsBuddhaOff(client);
	}
	#endif
	#if defined ENABLE_NOCLIP
	else if (strcmp(strPerk, "noclip") == 0)
	{
		IsNoclipOff(client);
	}
	#endif
	#if defined ENABLE_POWERPLAY
	else if (strcmp(strPerk, "powerplay") == 0)
	{
		IsPowerPlayOff(client);
	}
	#endif
	#if defined ENABLE_THIRDPERSON
	else if (strcmp(strPerk, "thirdperson") == 0)
	{
		IsThirdPersonOff(client);
	}
	#endif
	else
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Perks] Invalid Parameter 2 strPerk: %s", strPerk);
	}
}

public Native_TogglePerk(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new length;
	GetNativeStringLength(2, length);
	new String:strPerk[length+1];
	GetNativeString(2, strPerk, length+1);
	
	if (!(IsValidClient(client) || IsPlayerAlive(client)))
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Perks] Invalid/dead target (%d) at the moment", client);
	}
	
	#if defined ENABLE_GODMODE
	if (strcmp(strPerk, "godmode") == 0)
	{
		ToggleGodmode(client);
	}
	#endif
	#if defined ENABLE_BUDDHA
	else if (strcmp(strPerk, "buddha") == 0)
	{
		ToggleBuddha(client);
	}
	#endif
	#if defined ENABLE_NOCLIP
	else if (strcmp(strPerk, "noclip") == 0)
	{
		ToggleNoclip(client);
	}
	#endif
	#if defined ENABLE_POWERPLAY
	else if (strcmp(strPerk, "powerplay") == 0)
	{
		TogglePowerPlay(client);
	}
	#endif
	#if defined ENABLE_THIRDPERSON
	else if (strcmp(strPerk, "thirdperson") == 0)
	{
		ToggleThirdPerson(client);
	}
	#endif
	else
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Perks] Invalid Parameter 2 strPerk: %s", strPerk);
	}
}

public Native_bWasEnabled(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new length;
	GetNativeStringLength(2, length);
	new String:strPerk[length+1];
	GetNativeString(2, strPerk, length+1);
	
	if (!(IsValidClient(client) || IsPlayerAlive(client)))
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Perks] Invalid/dead target (%d) at the moment", client);
	}
	
	#if defined ENABLE_GODMODE
	if (strcmp(strPerk, "godmode", false) == 0)
	{
		if (bWasEnabled[client][0])
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	#endif
	#if defined ENABLE_BUDDHA
	else if (strcmp(strPerk, "buddha", false) == 0)
	{
		if (bWasEnabled[client][1])
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	#endif
	#if defined ENABLE_NOCLIP
	else if (strcmp(strPerk, "noclip", false) == 0)
	{
		if (bWasEnabled[client][2])
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	#endif
	#if defined ENABLE_POWERPLAY
	else if (strcmp(strPerk, "powerplay", false) == 0)
	{
		if (bWasEnabled[client][3])
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	#endif
	#if defined ENABLE_THIRDPERSON
	else if (strcmp(strPerk, "thirdperson", false) == 0)
	{
		if (bWasEnabled[client][4])
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	#endif
	else
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Perks] Invalid Parameter 2: %s", strPerk);
		return 0;
	}
	
	#if !defined ENABLE_GODMODE && !defined ENABLE_BUDDHA && !defined ENABLE_NOCLIP && !defined ENABLE_POWERPLAY && !defined ENABLE_THIRDPERSON
	return 0;
	#endif
}


#if defined ENABLE_AMMO
public Native_EnableAmmo(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	
	if (!(IsValidClient(client) || IsPlayerAlive(client)))
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Perks] Invalid/dead target (%d) at the moment", client);
	}
	
	EnableAmmo(client);
}

public Native_DisableAmmo(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	
	if (!(IsValidClient(client) || IsPlayerAlive(client)))
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Perks] Invalid/dead target (%d) at the moment", client);
	}
	
	DisableAmmo(client);
}

public Native_ToggleAmmo(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	
	if (!(IsValidClient(client) || IsPlayerAlive(client)))
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Perks] Invalid/dead target (%d) at the moment", client);
	}
	
	ToggleAmmo(client);
}

public Native_GetAmmo(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new weapon = GetNativeCell(2);
	
	if (!(IsValidClient(client) || IsPlayerAlive(client)))
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Perks] Invalid/dead target (%d) at the moment", client);
	}
	
	return GetAmmo(client, weapon);
}

public Native_SetAmmo(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new weapon = GetNativeCell(2);
	new newAmmo = GetNativeCell(3);
	
	if (!(IsValidClient(client) || IsPlayerAlive(client)))
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Perks] Invalid/dead target (%d) at the moment", client);
	}
	
	SetAmmo(client, weapon, newAmmo);
}

public Native_GetClip(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new weapon = GetNativeCell(2);
	
	if (!(IsValidClient(client) || IsPlayerAlive(client)))
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Perks] Invalid/dead target (%d) at the moment", client);
	}
	
	return GetClip(client, weapon);
}

public Native_SetClip(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new weapon = GetNativeCell(2);
	new newClip = GetNativeCell(3);
	
	if (!(IsValidClient(client) || IsPlayerAlive(client)))
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Perks] Invalid/dead target (%d) at the moment", client);
	}
	
	SetClip(client, weapon, newClip);
}

public Native_GetMetal(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	
	if (!(IsValidClient(client) || IsPlayerAlive(client)))
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Perks] Invalid/dead target (%d) at the moment", client);
	}
	
	return GetMetal(client);
}

public Native_SetMetal(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new newMetal = GetNativeCell(2);
	
	if (!(IsValidClient(client) || IsPlayerAlive(client)))
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Perks] Invalid/dead target (%d) at the moment", client);
	}
	
	SetMetal(client, newMetal);
}

public Native_GetDrinkMeter(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	
	if (!(IsValidClient(client) || IsPlayerAlive(client)))
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Perks] Invalid/dead target (%d) at the moment", client);
	}
	
	return _:GetDrinkMeter(client);
}

public Native_SetDrinkMeter(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new Float:flNewDrink = GetNativeCell(2);
	
	if (!(IsValidClient(client) || IsPlayerAlive(client)))
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Perks] Invalid/dead target (%d) at the moment", client);
	}
	
	SetDrinkMeter(client, flNewDrink);
}

public Native_GetHypeMeter(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	
	if (!(IsValidClient(client) || IsPlayerAlive(client)))
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Perks] Invalid/dead target (%d) at the moment", client);
	}
	
	return _:GetHypeMeter(client);
}

public Native_SetHypeMeter(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new Float:flNewHype = GetNativeCell(2);
	
	if (!(IsValidClient(client) || IsPlayerAlive(client)))
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Perks] Invalid/dead target (%d) at the moment", client);
	}
	
	SetHypeMeter(client, flNewHype);
}

public Native_GetRageMeter(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	
	if (!(IsValidClient(client) || IsPlayerAlive(client)))
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Perks] Invalid/dead target (%d) at the moment", client);
	}
	
	return _:GetRageMeter(client);
}

public Native_SetRageMeter(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new Float:flNewRage = GetNativeCell(2);
	
	if (!(IsValidClient(client) || IsPlayerAlive(client)))
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Perks] Invalid/dead target (%d) at the moment", client);
	}
	
	SetRageMeter(client, flNewRage);
}

public Native_GetChargeMeter(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	
	if (!(IsValidClient(client) || IsPlayerAlive(client)))
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Perks] Invalid/dead target (%d) at the moment", client);
	}
	
	return _:GetChargeMeter(client);
}

public Native_SetChargeMeter(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new Float:flNewCharge = GetNativeCell(2);
	
	if (!(IsValidClient(client) || IsPlayerAlive(client)))
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Perks] Invalid/dead target (%d) at the moment", client);
	}
	
	SetChargeMeter(client, flNewCharge);
}

public Native_GetUberCharge(Handle:plugin, numParams)
{
	new weapon = GetNativeCell(1);
	
	if (!IsValidEntity(weapon))
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Perks] Invalid Weapon Entity %i", weapon);
	}
	
	return _:GetUberCharge(weapon);
}

public Native_SetUberCharge(Handle:plugin, numParams)
{
	new weapon = GetNativeCell(1);
	new Float:flNewUberCharge = GetNativeCell(2);
	
	if (!IsValidEntity(weapon))
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Perks] Invalid Weapon Entity %i", weapon);
	}
	
	SetUberCharge(weapon, flNewUberCharge);
}

public Native_GetCloakMeter(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	
	if (!(IsValidClient(client) || IsPlayerAlive(client)))
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Perks] Invalid/dead target (%d) at the moment", client);
	}
	
	return _:GetCloakMeter(client);
}

public Native_SetCloakMeter(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new Float:flNewCloak = GetNativeCell(2);
	
	if (!(IsValidClient(client) || IsPlayerAlive(client)))
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Perks] Invalid/dead target (%d) at the moment", client);
	}
	
	SetCloakMeter(client, flNewCloak);
}
#endif


#if defined ENABLE_HEALTH
public Native_GetHealth(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	if (!(IsValidClient(client) || IsPlayerAlive(client)))
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Perks] Invalid/dead target (%d) at the moment", client);
	}
	
	return GetHealth(client);
}

public Native_SetHealth(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new health = GetNativeCell(2);
	
	if (!(IsValidClient(client) || IsPlayerAlive(client)))
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Perks] Invalid/dead target (%d) at the moment", client);
	}
	
	SetHealth(client, health);
}
#endif


#if defined ENABLE_TELEPORT
public Native_Teleport(Handle:plugin, numParams)
{
	new player1 = GetNativeCell(1);
	new player2 = GetNativeCell(2);
	
	new length;
	GetNativeStringLength(3, length);
	new String:strMode[length+1];
	GetNativeString(3, strMode, length+1);
	
	if (!(IsValidClient(player1) || IsValidClient(player2)))
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Perks] Invalid/dead target (%d) at the moment", player1);
	}
	
	if (strcmp(strMode, "infront", false) == 0)
	{
		TeleportToFront(player1, player2);
	}
	else if (strcmp(strMode, "look", false) == 0)
	{
		TeleportToEye(player1, player2);
	}
	else
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Perks] Invalid Parameter 3: %s", strMode);
	}
}

public Native_SaveLocation(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	if (!(IsValidClient(client) || IsPlayerAlive(client)))
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Perks] Invalid/dead target (%d) at the moment", client);
	}
	
	SavePlayerLocation(client);
}

public Native_TeleportToSavedLocation(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Perks] Invalid/dead target (%d) at the moment", client);
	}
	
	TeleportPlayerToSavedLocation(client);
}
#endif


#if defined ENABLE_ROF
public Native_ModRateOfFire(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new Float:multi = GetNativeCell(2);
	if (!(IsValidClient(client) || IsPlayerAlive(client)))
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Perks] Invalid/dead target (%d) at the moment", client);
	}
	
	ModRateOfFire(client, multi);
}
#endif

#if defined ENABLE_SIZE
public Native_ResizePlayer(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new Float:scale = GetNativeCell(2);
	if (!(IsValidClient(client) || IsPlayerAlive(client)))
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Perks] Invalid/dead target (%d) at the moment", client);
	}
	
	ResizePlayer(client, scale);
}
#endif


stock bool:IsValidClient(client)
{
	if (client <= 0) return false;
	if (client > MaxClients) return false;
	return IsClientInGame(client);
}
