#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <morecolors>
#include <tf2>
#include <tf2perks>

#define PLUGIN_VERSION		"1.0"

#define ENABLE_REGEN
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

#define ADMFLAG_ADMIN ADMFLAG_GENERIC
#define ADMFLAG_PERKS ADMFLAG_CUSTOM1

new OffAW = -1;

public Plugin:myinfo =
{
	name = "TF2 Perk Commands",
	author = "Patka",
	description = "TF2 Perk commands.",
	version = PLUGIN_VERSION,
	url = "http://forums.alliedmods.net"
};

public OnPluginStart()
{
	LoadTranslations("common.phrases");
	CreateConVar("tf_perk_commands_version", PLUGIN_VERSION, "TF2 Perk Commands plugin version.", FCVAR_PLUGIN|FCVAR_NOTIFY|FCVAR_REPLICATED);
	
	#if defined ENABLE_REGEN
	RegAdminCmd("sm_regen", Command_Regen, ADMFLAG_ADMIN, "Regenerate target(s).");
	RegAdminCmd("sm_regenme", Command_RegenMe, ADMFLAG_PERKS, "Regenerate client.");
	#endif
	
	#if defined ENABLE_GODMODE
	RegAdminCmd("sm_god", Command_God, ADMFLAG_ADMIN, "Toggle Godmode on target(s).");
	RegAdminCmd("sm_godmode", Command_Godmode, ADMFLAG_PERKS, "Toggle Godmode on client.");
	#endif
	
	#if defined ENABLE_BUDDHA
	RegAdminCmd("sm_buddha", Command_Buddha, ADMFLAG_ADMIN, "Toggle Buddha on target(s).");
	RegAdminCmd("sm_buddhamode", Command_Buddhamode, ADMFLAG_PERKS, "Toggle Buddha on client.");
	#endif
	
	#if defined ENABLE_NOCLIP
	RegAdminCmd("sm_noc", Command_Noc, ADMFLAG_PERKS, "Toggle Noclip on client.");
	#endif
	
	#if defined ENABLE_POWERPLAY
	RegAdminCmd("sm_power", Command_Power, ADMFLAG_ADMIN, "Toggle Powerplay on target(s).");
	RegAdminCmd("sm_powerplay", Command_Powerplay, ADMFLAG_PERKS, "Toggle Powerplay on client.");
	#endif
	
	#if defined ENABLE_THIRDPERSON
	RegAdminCmd("sm_setview", Command_SetView, ADMFLAG_ADMIN, "Toggle firstperson/thirdperson on target(s).");
	RegAdminCmd("sm_thirdperson", Command_ThirdPerson, ADMFLAG_PERKS, "Toggle firstperson/thirdperson on client.");
	#endif
	
	#if defined ENABLE_AMMO
	OffAW = FindSendPropInfo("CBasePlayer", "m_hActiveWeapon");
	RegAdminCmd("sm_infammo", Command_InfiniteAmmo, ADMFLAG_ADMIN, "Toggle infinite ammo on target(s).");
	RegAdminCmd("sm_ammo", Command_Ammo, ADMFLAG_PERKS, "Toggle infinite ammo on client.");
	RegAdminCmd("sm_setammo", Command_SetAmmo, ADMFLAG_ADMIN, "Set target's ammo.");
	RegAdminCmd("sm_setclip", Command_SetClip, ADMFLAG_ADMIN, "Set target's clip.");
	RegAdminCmd("sm_setmetal", Command_SetMetal, ADMFLAG_ADMIN, "Set target's metal.");
	RegAdminCmd("sm_setdrinkmeter", Command_SetDrinkMeter, ADMFLAG_ADMIN, "Set target's drink meter.");
	RegAdminCmd("sm_sethypemeter", Command_SetHypeMeter, ADMFLAG_ADMIN, "Set target's hype meter.");
	RegAdminCmd("sm_setragemeter", Command_SetRageMeter, ADMFLAG_ADMIN, "Set target's rage meter.");
	RegAdminCmd("sm_setchargemeter", Command_SetChargeMeter, ADMFLAG_ADMIN, "Set target's charge meter.");
	RegAdminCmd("sm_setubermeter", Command_SetUberMeter, ADMFLAG_ADMIN, "Set target's uber meter.");
	RegAdminCmd("sm_setcloakmeter", Command_SetCloakMeter, ADMFLAG_ADMIN, "Set target's cloak meter.");
	#endif
	
	#if defined ENABLE_HEALTH
	RegAdminCmd("sm_gethealth", Command_GetHealth, ADMFLAG_ADMIN, "Get health of target(s).");
	RegAdminCmd("sm_sethealth", Command_SetHealth, ADMFLAG_ADMIN, "Set health for target(s).");
	#endif
	
	#if defined ENABLE_TELEPORT
	RegAdminCmd("sm_tele", Command_Teleport, ADMFLAG_ADMIN, "Teleport target(s).");
	RegAdminCmd("sm_saveloc", Command_SaveLocation, ADMFLAG_ADMIN, "Save target(s) location.");
	RegAdminCmd("sm_teleloc", Command_TeleportLocation, ADMFLAG_ADMIN, "Teleport target(s) to saved location.");
	
	RegAdminCmd("sm_savemyloc", Command_SaveMyLocation, ADMFLAG_PERKS, "Save client's location.");
	RegAdminCmd("sm_telemyloc", Command_TeleportMyLocation, ADMFLAG_PERKS, "Teleport client to saved location.");
	#endif
	
	#if defined ENABLE_ROF
	RegAdminCmd("sm_rof", Command_RateOfFire, ADMFLAG_ADMIN, "Mod rate of fire for target(s).");
	#endif
	
	#if defined ENABLE_SIZE
	RegAdminCmd("sm_size", Command_Size, ADMFLAG_ADMIN, "Resize target(s).");
	#endif
}

#if defined ENABLE_REGEN
public Action:Command_Regen(client, args)
{
	if (args != 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_regen <client>");
		return Plugin_Handled;
	}
	
	new String:arg1[32];
	GetCmdArg(1, arg1, sizeof(arg1));
	
	decl String:target_name[MAX_TARGET_LENGTH];
	decl target_list[MAXPLAYERS], target_count, bool:tn_is_ml;
	
	if ((target_count = ProcessTargetString(
			arg1,
			client,
			target_list,
			MAXPLAYERS,
			COMMAND_FILTER_CONNECTED,
			target_name,
			sizeof(target_name),
			tn_is_ml)) <= 0)
	{
		ReplyToTargetError(client, target_count);
		return Plugin_Handled;
	}
	
	for (new i = 0; i < target_count; i++)
	{
		if (IsValidClient(target_list[i]))
		{
			TF2_RegeneratePlayer(target_list[i]);
			CPrintToChat(target_list[i], "[{green}TF2Perks{default}] You Have Been Regenerated");
		}
	}
	
	ReplyToCommand(client, "[TF2Perks] Player %s Has Been Regenerated", target_name);
	return Plugin_Handled;
}

public Action:Command_RegenMe(client, args)
{
	if (args != 0)
	{
		ReplyToCommand(client, "[SM] Usage: sm_regenme");
		return Plugin_Handled;
	}
	
	if (IsValidClient(client))
	{
		TF2_RegeneratePlayer(client);
		CPrintToChat(client, "[{green}TF2Perks{default}] You Have Been Regenerated");
	}
	else
	{
		ReplyToCommand(client, "[TF2Perks] You must be in-game to use this command.");
	}
	
	return Plugin_Handled;
}
#endif

#if defined ENABLE_GODMODE
public Action:Command_God(client, args)
{
	if (args < 1 || args > 2)
	{
		ReplyToCommand(client, "[SM] Usage: sm_god <client> or sm_god <client> <0|1>");
		return Plugin_Handled;
	}
	
	new String:arg1[32];
	new String:arg2[32];
	
	GetCmdArg(1, arg1, sizeof(arg1));
	if (args == 2)
	{
		GetCmdArg(2, arg2, sizeof(arg2));
	}
	
	decl String:target_name[MAX_TARGET_LENGTH];
	decl target_list[MAXPLAYERS], target_count, bool:tn_is_ml;
	
	if ((target_count = ProcessTargetString(
			arg1,
			client,
			target_list,
			MAXPLAYERS,
			COMMAND_FILTER_CONNECTED,
			target_name,
			sizeof(target_name),
			tn_is_ml)) <= 0)
	{
		ReplyToTargetError(client, target_count);
		return Plugin_Handled;
	}
	
	for (new i = 0; i < target_count; i++)
	{
		if (args == 1)
		{
			TF2Perks_TogglePerk(target_list[i], "godmode");
		}
		else
		{
			if (StringToInt(arg2))
			{
				TF2Perks_EnablePerk(target_list[i], "godmode");
			}
			else
			{
				TF2Perks_DisablePerk(target_list[i], "godmode");
			}
		}
	}
	
	if (args == 1)
	{
		ReplyToCommand(client, "[TF2Perks] Toggled Godmode For Player %s", target_name);
	}
	else
	{
		if (StringToInt(arg2))
		{
			ReplyToCommand(client, "[TF2Perks] Godmode Enabled For Player %s", target_name);
		}
		else
		{
			ReplyToCommand(client, "[TF2Perks] Godmode Disabled For Player %s", target_name);
		}
	}
	
	return Plugin_Handled;
}

public Action:Command_Godmode(client, args)
{
	if (args != 0)
	{
		ReplyToCommand(client, "[SM] Usage: sm_godmode");
		return Plugin_Handled;
	}
	
	TF2Perks_TogglePerk(client, "godmode");
	return Plugin_Handled;
}
#endif

#if defined ENABLE_BUDDHA
public Action:Command_Buddha(client, args)
{
	if (args < 1 || args > 2)
	{
		ReplyToCommand(client, "[SM] Usage: sm_buddha <client> or sm_buddha <client> <0|1>");
		return Plugin_Handled;
	}
	
	new String:arg1[32];
	new String:arg2[32];
	
	GetCmdArg(1, arg1, sizeof(arg1));
	if (args == 2)
	{
		GetCmdArg(2, arg2, sizeof(arg2));
	}
	
	decl String:target_name[MAX_TARGET_LENGTH];
	decl target_list[MAXPLAYERS], target_count, bool:tn_is_ml;
	
	if ((target_count = ProcessTargetString(
			arg1,
			client,
			target_list,
			MAXPLAYERS,
			COMMAND_FILTER_CONNECTED,
			target_name,
			sizeof(target_name),
			tn_is_ml)) <= 0)
	{
		ReplyToTargetError(client, target_count);
		return Plugin_Handled;
	}
	
	for (new i = 0; i < target_count; i++)
	{
		if (args == 1)
		{
			TF2Perks_TogglePerk(target_list[i], "buddha");
		}
		else
		{
			if (StringToInt(arg2))
			{
				TF2Perks_EnablePerk(target_list[i], "buddha");
			}
			else
			{
				TF2Perks_DisablePerk(target_list[i], "buddha");
			}
		}
	}
	
	if (args == 1)
	{
		ReplyToCommand(client, "[TF2Perks] Toggled Buddha For Player %s", target_name);
	}
	else
	{
		if (StringToInt(arg2))
		{
			ReplyToCommand(client, "[TF2Perks] Buddha Enabled For Player %s", target_name);
		}
		else
		{
			ReplyToCommand(client, "[TF2Perks] Buddha Disabled For Player %s", target_name);
		}
	}
	
	return Plugin_Handled;
}

public Action:Command_Buddhamode(client, args)
{
	if (args != 0)
	{
		ReplyToCommand(client, "[SM] Usage: sm_buddhamode");
		return Plugin_Handled;
	}
	
	TF2Perks_TogglePerk(client, "buddha");
	return Plugin_Handled;
}
#endif

#if defined ENABLE_NOCLIP
public Action:Command_Noc(client, args)
{
	if (args != 0)
	{
		ReplyToCommand(client, "[SM] Usage: sm_noc");
		return Plugin_Handled;
	}
	
	TF2Perks_TogglePerk(client, "noclip");
	return Plugin_Handled;
}
#endif

#if defined ENABLE_POWERPLAY
public Action:Command_Power(client, args)
{
	if (args < 1 || args > 2)
	{
		ReplyToCommand(client, "[SM] Usage: sm_power <client> or sm_power <client> <0|1>");
		return Plugin_Handled;
	}
	
	new String:arg1[32];
	new String:arg2[32];
	
	GetCmdArg(1, arg1, sizeof(arg1));
	if (args == 2)
	{
		GetCmdArg(2, arg2, sizeof(arg2));
	}
	
	decl String:target_name[MAX_TARGET_LENGTH];
	decl target_list[MAXPLAYERS], target_count, bool:tn_is_ml;
	
	if ((target_count = ProcessTargetString(
			arg1,
			client,
			target_list,
			MAXPLAYERS,
			COMMAND_FILTER_CONNECTED,
			target_name,
			sizeof(target_name),
			tn_is_ml)) <= 0)
	{
		ReplyToTargetError(client, target_count);
		return Plugin_Handled;
	}
	
	for (new i = 0; i < target_count; i++)
	{
		if (args == 1)
		{
			TF2Perks_TogglePerk(target_list[i], "powerplay");
		}
		else
		{
			if (StringToInt(arg2))
			{
				TF2Perks_EnablePerk(target_list[i], "powerplay");
			}
			else
			{
				TF2Perks_DisablePerk(target_list[i], "powerplay");
			}
		}
	}
	
	if (args == 1)
	{
		ReplyToCommand(client, "[TF2Perks] Toggled Powerplay For Player %s", target_name);
	}
	else
	{
		if (StringToInt(arg2))
		{
			ReplyToCommand(client, "[TF2Perks] Powerplay Enabled For Player %s", target_name);
		}
		else
		{
			ReplyToCommand(client, "[TF2Perks] Powerplay Disabled For Player %s", target_name);
		}
	}
	
	return Plugin_Handled;
}

public Action:Command_Powerplay(client, args)
{
	if (args != 0)
	{
		ReplyToCommand(client, "[SM] Usage: sm_powerplay");
		return Plugin_Handled;
	}
	
	TF2Perks_TogglePerk(client, "powerplay");
	return Plugin_Handled;
}
#endif

#if defined ENABLE_THIRDPERSON
public Action:Command_SetView(client, args)
{
	if (args < 1 || args > 2)
	{
		ReplyToCommand(client, "[SM] Usage: sm_setview <client> or sm_setview <client> <0|1>");
		return Plugin_Handled;
	}
	
	new String:arg1[32];
	new String:arg2[32];
	
	GetCmdArg(1, arg1, sizeof(arg1));
	if (args == 2)
	{
		GetCmdArg(2, arg2, sizeof(arg2));
	}
	
	decl String:target_name[MAX_TARGET_LENGTH];
	decl target_list[MAXPLAYERS], target_count, bool:tn_is_ml;
	
	if ((target_count = ProcessTargetString(
			arg1,
			client,
			target_list,
			MAXPLAYERS,
			COMMAND_FILTER_CONNECTED,
			target_name,
			sizeof(target_name),
			tn_is_ml)) <= 0)
	{
		ReplyToTargetError(client, target_count);
		return Plugin_Handled;
	}
	
	for (new i = 0; i < target_count; i++)
	{
		if (args == 1)
		{
			TF2Perks_TogglePerk(target_list[i], "thirdperson");
		}
		else
		{
			if (StringToInt(arg2))
			{
				TF2Perks_EnablePerk(target_list[i], "thirdperson");
			}
			else
			{
				TF2Perks_DisablePerk(target_list[i], "thirdperson");
			}
		}
	}
	
	if (args == 1)
	{
		ReplyToCommand(client, "[TF2Perks] Toggled Thirdperson For Player %s", target_name);
	}
	else
	{
		if (StringToInt(arg2))
		{
			ReplyToCommand(client, "[TF2Perks] Thirdperson Enabled For Player %s", target_name);
		}
		else
		{
			ReplyToCommand(client, "[TF2Perks] Thirdperson Disabled For Player %s", target_name);
		}
	}
	
	return Plugin_Handled;
}

public Action:Command_ThirdPerson(client, args)
{
	if (args != 0)
	{
		ReplyToCommand(client, "[SM] Usage: sm_thirdperson");
		return Plugin_Handled;
	}
	
	TF2Perks_TogglePerk(client, "thirdperson");
	return Plugin_Handled;
}
#endif


#if defined ENABLE_AMMO
public Action:Command_InfiniteAmmo(client, args)
{
	if (args < 1 || args > 2)
	{
		ReplyToCommand(client, "[SM] Usage: sm_infammo <client> or sm_infammo <client> <0|1>");
		return Plugin_Handled;
	}
	
	new String:arg1[32];
	new String:arg2[32];
	
	GetCmdArg(1, arg1, sizeof(arg1));
	if (args == 2)
	{
		GetCmdArg(2, arg2, sizeof(arg2));
	}
	
	decl String:target_name[MAX_TARGET_LENGTH];
	decl target_list[MAXPLAYERS], target_count, bool:tn_is_ml;
	
	if ((target_count = ProcessTargetString(
			arg1,
			client,
			target_list,
			MAXPLAYERS,
			COMMAND_FILTER_CONNECTED,
			target_name,
			sizeof(target_name),
			tn_is_ml)) <= 0)
	{
		ReplyToTargetError(client, target_count);
		return Plugin_Handled;
	}
	
	for (new i = 0; i < target_count; i++)
	{
		if (args == 1)
		{
			TF2Perks_ToggleAmmo(target_list[i]);
		}
		else
		{
			if (StringToInt(arg2))
			{
				TF2Perks_EnableAmmo(target_list[i]);
			}
			else
			{
				TF2Perks_DisableAmmo(target_list[i]);
			}
		}
	}
	
	if (args == 1)
	{
		ReplyToCommand(client, "[TF2Perks] Toggled Infinite Ammo For Player %s", target_name);
	}
	else
	{
		if (StringToInt(arg2))
		{
			ReplyToCommand(client, "[TF2Perks] Infinite Ammo Enabled For Player %s", target_name);
		}
		else
		{
			ReplyToCommand(client, "[TF2Perks] Infinite Ammo Disabled For Player %s", target_name);
		}
	}
	
	return Plugin_Handled;
}

public Action:Command_Ammo(client, args)
{
	if (args != 0)
	{
		ReplyToCommand(client, "[SM] Usage: sm_ammo");
		return Plugin_Handled;
	}
	
	TF2Perks_ToggleAmmo(client);
	return Plugin_Handled;
}

public Action:Command_SetAmmo(client, args)
{
	if (args < 3)
	{
		ReplyToCommand(client, "[SM] Usage: sm_setammo <client> <slot> <ammo>");
		return Plugin_Handled;
	}
	
	new String:arg1[32];
	new String:arg2[32];
	new String:arg3[32];
	
	GetCmdArg(1, arg1, sizeof(arg1));
	GetCmdArg(2, arg2, sizeof(arg2));
	GetCmdArg(3, arg3, sizeof(arg3));
	
	decl String:target_name[MAX_TARGET_LENGTH];
	decl target_list[MAXPLAYERS], target_count, bool:tn_is_ml;
	
	if ((target_count = ProcessTargetString(
			arg1,
			client,
			target_list,
			MAXPLAYERS,
			COMMAND_FILTER_CONNECTED,
			target_name,
			sizeof(target_name),
			tn_is_ml)) <= 0)
	{
		ReplyToTargetError(client, target_count);
		return Plugin_Handled;
	}
	
	new slot = StringToInt(arg2);
	new ammo = StringToInt(arg3);
	new weapon;
	for (new i = 0; i < target_count; i++)
	{
		weapon = GetPlayerWeaponSlot(target_list[i], slot);
		TF2Perks_SetAmmo(target_list[i], weapon, ammo);
	}
	
	ReplyToCommand(client, "[TF2Perks] Ammo Set To %i For Player %s", ammo, target_name);
	return Plugin_Handled;
}

public Action:Command_SetClip(client, args)
{
	if (args < 3)
	{
		ReplyToCommand(client, "[SM] Usage: sm_setclip <client> <slot> <ammo>");
		return Plugin_Handled;
	}
	
	new String:arg1[32];
	new String:arg2[32];
	new String:arg3[32];
	
	GetCmdArg(1, arg1, sizeof(arg1));
	GetCmdArg(2, arg2, sizeof(arg2));
	GetCmdArg(3, arg3, sizeof(arg3));
	
	decl String:target_name[MAX_TARGET_LENGTH];
	decl target_list[MAXPLAYERS], target_count, bool:tn_is_ml;
	
	if ((target_count = ProcessTargetString(
			arg1,
			client,
			target_list,
			MAXPLAYERS,
			COMMAND_FILTER_CONNECTED,
			target_name,
			sizeof(target_name),
			tn_is_ml)) <= 0)
	{
		ReplyToTargetError(client, target_count);
		return Plugin_Handled;
	}
	
	new slot = StringToInt(arg2);
	new ammo = StringToInt(arg3);
	new weapon;
	for (new i = 0; i < target_count; i++)
	{
		weapon = GetPlayerWeaponSlot(target_list[i], slot);
		TF2Perks_SetClip(target_list[i], weapon, ammo);
	}
	
	ReplyToCommand(client, "[TF2Perks] Clip Set To %i For Player %s", ammo, target_name);
	return Plugin_Handled;
}

public Action:Command_SetMetal(client, args)
{
	if (args < 2)
	{
		ReplyToCommand(client, "[SM] Usage: sm_setmetal <client> <metal>");
		return Plugin_Handled;
	}
	
	new String:arg1[32];
	new String:arg2[32];
	
	GetCmdArg(1, arg1, sizeof(arg1));
	GetCmdArg(2, arg2, sizeof(arg2));
	
	decl String:target_name[MAX_TARGET_LENGTH];
	decl target_list[MAXPLAYERS], target_count, bool:tn_is_ml;
	
	if ((target_count = ProcessTargetString(
			arg1,
			client,
			target_list,
			MAXPLAYERS,
			COMMAND_FILTER_CONNECTED,
			target_name,
			sizeof(target_name),
			tn_is_ml)) <= 0)
	{
		ReplyToTargetError(client, target_count);
		return Plugin_Handled;
	}
	
	new metal = StringToInt(arg2);
	for (new i = 0; i < target_count; i++)
	{
		TF2Perks_SetMetal(target_list[i], metal);
	}
	
	ReplyToCommand(client, "[TF2Perks] Metal Set To %i For Player %s", metal, target_name);
	return Plugin_Handled;
}

public Action:Command_SetDrinkMeter(client, args)
{
	if (args < 2)
	{
		ReplyToCommand(client, "[SM] Usage: sm_setdrinkmeter <client> <drink 0 - 100>");
		return Plugin_Handled;
	}
	
	new String:arg1[32];
	new String:arg2[32];
	
	GetCmdArg(1, arg1, sizeof(arg1));
	GetCmdArg(2, arg2, sizeof(arg2));
	
	decl String:target_name[MAX_TARGET_LENGTH];
	decl target_list[MAXPLAYERS], target_count, bool:tn_is_ml;
	
	if ((target_count = ProcessTargetString(
			arg1,
			client,
			target_list,
			MAXPLAYERS,
			COMMAND_FILTER_CONNECTED,
			target_name,
			sizeof(target_name),
			tn_is_ml)) <= 0)
	{
		ReplyToTargetError(client, target_count);
		return Plugin_Handled;
	}
	
	new Float:flDrink = StringToFloat(arg2);
	if (flDrink < 0 || flDrink > 100)
	{
		ReplyToCommand(client, "[TF2Perks] Drink Meter Out Of Bounds");
		return Plugin_Handled;
	}
	
	for (new i = 0; i < target_count; i++)
	{
		TF2Perks_SetDrinkMeter(target_list[i], flDrink);
	}
	
	ReplyToCommand(client, "[TF2Perks] Drink Meter Set To %f For Player %s", flDrink, target_name);
	return Plugin_Handled;
}

public Action:Command_SetHypeMeter(client, args)
{
	if (args < 2)
	{
		ReplyToCommand(client, "[SM] Usage: sm_sethypemeter <client> <hype 0 - 100>");
		return Plugin_Handled;
	}
	
	new String:arg1[32];
	new String:arg2[32];
	
	GetCmdArg(1, arg1, sizeof(arg1));
	GetCmdArg(2, arg2, sizeof(arg2));
	
	decl String:target_name[MAX_TARGET_LENGTH];
	decl target_list[MAXPLAYERS], target_count, bool:tn_is_ml;
	
	if ((target_count = ProcessTargetString(
			arg1,
			client,
			target_list,
			MAXPLAYERS,
			COMMAND_FILTER_CONNECTED,
			target_name,
			sizeof(target_name),
			tn_is_ml)) <= 0)
	{
		ReplyToTargetError(client, target_count);
		return Plugin_Handled;
	}
	
	new Float:flHype = StringToFloat(arg2);
	if (flHype < 0 || flHype > 100)
	{
		ReplyToCommand(client, "[TF2Perks] Hype Meter Out Of Bounds");
		return Plugin_Handled;
	}
	
	for (new i = 0; i < target_count; i++)
	{
		TF2Perks_SetHypeMeter(target_list[i], flHype);
	}
	
	ReplyToCommand(client, "[TF2Perks] Hype Meter Set To %f For Player %s", flHype, target_name);
	return Plugin_Handled;
}

public Action:Command_SetRageMeter(client, args)
{
	if (args < 2)
	{
		ReplyToCommand(client, "[SM] Usage: sm_setragemeter <client> <rage 0 - 100>");
		return Plugin_Handled;
	}
	
	new String:arg1[32];
	new String:arg2[32];
	
	GetCmdArg(1, arg1, sizeof(arg1));
	GetCmdArg(2, arg2, sizeof(arg2));
	
	decl String:target_name[MAX_TARGET_LENGTH];
	decl target_list[MAXPLAYERS], target_count, bool:tn_is_ml;
	
	if ((target_count = ProcessTargetString(
			arg1,
			client,
			target_list,
			MAXPLAYERS,
			COMMAND_FILTER_CONNECTED,
			target_name,
			sizeof(target_name),
			tn_is_ml)) <= 0)
	{
		ReplyToTargetError(client, target_count);
		return Plugin_Handled;
	}
	
	new Float:flRage = StringToFloat(arg2);
	if (flRage < 0 || flRage > 100)
	{
		ReplyToCommand(client, "[TF2Perks] Rage Meter Out Of Bounds");
		return Plugin_Handled;
	}
	
	for (new i = 0; i < target_count; i++)
	{
		TF2Perks_SetRageMeter(target_list[i], flRage);
	}
	
	ReplyToCommand(client, "[TF2Perks] Rage Meter Set To %f For Player %s", flRage, target_name);
	return Plugin_Handled;
}

public Action:Command_SetChargeMeter(client, args)
{
	if (args < 2)
	{
		ReplyToCommand(client, "[SM] Usage: sm_setchargemeter <client> <charge>");
		return Plugin_Handled;
	}
	
	new String:arg1[32];
	new String:arg2[32];
	
	GetCmdArg(1, arg1, sizeof(arg1));
	GetCmdArg(2, arg2, sizeof(arg2));
	
	decl String:target_name[MAX_TARGET_LENGTH];
	decl target_list[MAXPLAYERS], target_count, bool:tn_is_ml;
	
	if ((target_count = ProcessTargetString(
			arg1,
			client,
			target_list,
			MAXPLAYERS,
			COMMAND_FILTER_CONNECTED,
			target_name,
			sizeof(target_name),
			tn_is_ml)) <= 0)
	{
		ReplyToTargetError(client, target_count);
		return Plugin_Handled;
	}
	
	new Float:flCharge = StringToFloat(arg2);
	if (flCharge < 0 || flCharge > 100)
	{
		ReplyToCommand(client, "[TF2Perks] Charge Meter Out Of Bounds");
		return Plugin_Handled;
	}
	
	for (new i = 0; i < target_count; i++)
	{
		TF2Perks_SetChargeMeter(target_list[i], flCharge);
	}
	
	ReplyToCommand(client, "[TF2Perks] Charge Meter Set To %f For Player %s", flCharge, target_name);
	return Plugin_Handled;
}

public Action:Command_SetUberMeter(client, args)
{
	if (args < 2)
	{
		ReplyToCommand(client, "[SM] Usage: sm_setubermeter <client> <charge>");
		return Plugin_Handled;
	}
	
	new String:arg1[32];
	new String:arg2[32];
	
	GetCmdArg(1, arg1, sizeof(arg1));
	GetCmdArg(2, arg2, sizeof(arg2));
	
	decl String:target_name[MAX_TARGET_LENGTH];
	decl target_list[MAXPLAYERS], target_count, bool:tn_is_ml;
	
	if ((target_count = ProcessTargetString(
			arg1,
			client,
			target_list,
			MAXPLAYERS,
			COMMAND_FILTER_CONNECTED,
			target_name,
			sizeof(target_name),
			tn_is_ml)) <= 0)
	{
		ReplyToTargetError(client, target_count);
		return Plugin_Handled;
	}
	
	new Float:flUber = StringToFloat(arg2);
	if (flUber < 0 || flUber > 1)
	{
		ReplyToCommand(client, "[TF2Perks] Uber Meter Out Of Bounds");
		return Plugin_Handled;
	}
	
	new wep = -1;
	for (new i = 0; i < target_count; i++)
	{
		wep = GetEntDataEnt2(target_list[i], OffAW);
		if (IsValidEntity(wep))
		{
			new index = GetEntProp(wep, Prop_Send, "m_iItemDefinitionIndex");
			if (index == 35)	//The Kritzkrieg
			{
				TF2Perks_SetUberCharge(wep, flUber);
			}
		}
	}
	
	ReplyToCommand(client, "[TF2Perks] Uber Meter Set To %f For Player %s", flUber, target_name);
	return Plugin_Handled;
}

public Action:Command_SetCloakMeter(client, args)
{
	if (args < 2)
	{
		ReplyToCommand(client, "[SM] Usage: sm_setcloakmeter <client> <charge>");
		return Plugin_Handled;
	}
	
	new String:arg1[32];
	new String:arg2[32];
	
	GetCmdArg(1, arg1, sizeof(arg1));
	GetCmdArg(2, arg2, sizeof(arg2));
	
	decl String:target_name[MAX_TARGET_LENGTH];
	decl target_list[MAXPLAYERS], target_count, bool:tn_is_ml;
	
	if ((target_count = ProcessTargetString(
			arg1,
			client,
			target_list,
			MAXPLAYERS,
			COMMAND_FILTER_CONNECTED,
			target_name,
			sizeof(target_name),
			tn_is_ml)) <= 0)
	{
		ReplyToTargetError(client, target_count);
		return Plugin_Handled;
	}
	
	new Float:flCloak = StringToFloat(arg2);
	if (flCloak < 0 || flCloak > 100)
	{
		ReplyToCommand(client, "[TF2Perks] Cloak Meter Out Of Bounds");
		return Plugin_Handled;
	}
	
	for (new i = 0; i < target_count; i++)
	{
		TF2Perks_SetCloakMeter(target_list[i], flCloak);
	}
	
	ReplyToCommand(client, "[TF2Perks] Cloak Meter Set To %f For Player %s", flCloak, target_name);
	return Plugin_Handled;
}
#endif


#if defined ENABLE_HEALTH
public Action:Command_GetHealth(client, args)
{
	if (args != 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_gethealth <client>");
		return Plugin_Handled;
	}
	
	new String:arg1[32];
	GetCmdArg(1, arg1, sizeof(arg1));
	
	decl String:target_name[MAX_TARGET_LENGTH];
	decl target_list[MAXPLAYERS], target_count, bool:tn_is_ml;
	
	if ((target_count = ProcessTargetString(
			arg1,
			client,
			target_list,
			MAXPLAYERS,
			COMMAND_FILTER_CONNECTED,
			target_name,
			sizeof(target_name),
			tn_is_ml)) <= 0)
	{
		ReplyToTargetError(client, target_count);
		return Plugin_Handled;
	}
	
	new health;
	for (new i = 0; i < target_count; i++)
	{
		health = TF2Perks_GetHealth(target_list[i]);
		ReplyToCommand(client, "[TF2Perks] %N Has %i Health", target_list[i], health);
	}
	
	return Plugin_Handled;
}

public Action:Command_SetHealth(client, args)
{
	if (args != 2)
	{
		ReplyToCommand(client, "[SM] Usage: sm_sethealth <client> <health>");
		return Plugin_Handled;
	}
	
	new String:arg1[32];
	GetCmdArg(1, arg1, sizeof(arg1));
	
	new String:arg2[32];
	GetCmdArg(2, arg2, sizeof(arg2));
	
	decl String:target_name[MAX_TARGET_LENGTH];
	decl target_list[MAXPLAYERS], target_count, bool:tn_is_ml;
	
	if ((target_count = ProcessTargetString(
			arg1,
			client,
			target_list,
			MAXPLAYERS,
			COMMAND_FILTER_CONNECTED,
			target_name,
			sizeof(target_name),
			tn_is_ml)) <= 0)
	{
		ReplyToTargetError(client, target_count);
		return Plugin_Handled;
	}
	
	new health = StringToInt(arg2);
	for (new i = 0; i < target_count; i++)
	{
		TF2Perks_SetHealth(target_list[i], health);
		ReplyToCommand(client, "[TF2Perks] %N's Health Set To %i", target_list[i], health);
	}
	
	return Plugin_Handled;
}
#endif


#if defined ENABLE_TELEPORT
public Action:Command_Teleport(client, args)
{
	if (args != 3)
	{
		ReplyToCommand(client, "[SM] Usage: sm_tele <client> <teleport to client> <mode: infront or look>");
		return Plugin_Handled;
	}
	
	new String:arg1[32];
	GetCmdArg(1, arg1, sizeof(arg1));
	
	new String:arg2[32];
	GetCmdArg(2, arg2, sizeof(arg2));
	
	new String:arg3[32];
	GetCmdArg(3, arg3, sizeof(arg3));
	
	decl String:target_name1[MAX_TARGET_LENGTH];
	decl target_list1[MAXPLAYERS], target_count1, bool:tn_is_ml1;
	
	if ((target_count1 = ProcessTargetString(
			arg1,
			client,
			target_list1,
			MAXPLAYERS,
			COMMAND_FILTER_CONNECTED,
			target_name1,
			sizeof(target_name1),
			tn_is_ml1)) <= 0)
	{
		ReplyToTargetError(client, target_count1);
		return Plugin_Handled;
	}
	
	decl String:target_name2[MAX_TARGET_LENGTH];
	decl target_list2[MAXPLAYERS], target_count2, bool:tn_is_ml2;
	
	if ((target_count2 = ProcessTargetString(
			arg2,
			client,
			target_list2,
			MAXPLAYERS,
			COMMAND_FILTER_CONNECTED,
			target_name2,
			sizeof(target_name2),
			tn_is_ml2)) <= 0)
	{
		ReplyToTargetError(client, target_count2);
		return Plugin_Handled;
	}
	
	for (new i = 0; i < target_count1+target_count2; i++)
	{
		if (IsValidClient(target_list1[i]) && IsValidClient(target_list2[i]))
		{
			TF2Perks_Teleport(target_list1[i], target_list2[i], arg3);
		}
	}
	
	return Plugin_Handled;
}

public Action:Command_SaveLocation(client, args)
{
	if (args != 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_saveloc <client>");
		return Plugin_Handled;
	}
	
	new String:arg1[32];
	GetCmdArg(1, arg1, sizeof(arg1));
	
	decl String:target_name[MAX_TARGET_LENGTH];
	decl target_list[MAXPLAYERS], target_count, bool:tn_is_ml;
	
	if ((target_count = ProcessTargetString(
			arg1,
			client,
			target_list,
			MAXPLAYERS,
			COMMAND_FILTER_CONNECTED,
			target_name,
			sizeof(target_name),
			tn_is_ml)) <= 0)
	{
		ReplyToTargetError(client, target_count);
		return Plugin_Handled;
	}
	
	for (new i = 0; i < target_count; i++)
	{
		TF2Perks_SaveLocation(target_list[i]);
	}
	
	return Plugin_Handled;
}

public Action:Command_TeleportLocation(client, args)
{
	if (args != 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_teleloc <client>");
		return Plugin_Handled;
	}
	
	new String:arg1[32];
	GetCmdArg(1, arg1, sizeof(arg1));
	
	decl String:target_name[MAX_TARGET_LENGTH];
	decl target_list[MAXPLAYERS], target_count, bool:tn_is_ml;
	
	if ((target_count = ProcessTargetString(
			arg1,
			client,
			target_list,
			MAXPLAYERS,
			COMMAND_FILTER_CONNECTED,
			target_name,
			sizeof(target_name),
			tn_is_ml)) <= 0)
	{
		ReplyToTargetError(client, target_count);
		return Plugin_Handled;
	}
	
	for (new i = 0; i < target_count; i++)
	{
		if (IsPlayerAlive(target_list[i]))
		{
			TF2Perks_TeleportToSavedLocation(target_list[i]);
		}
	}
	
	return Plugin_Handled;
}

public Action:Command_SaveMyLocation(client, args)
{
	if (args != 0)
	{
		ReplyToCommand(client, "[SM] Usage: sm_savemyloc");
		return Plugin_Handled;
	}
	
	TF2Perks_SaveLocation(client);
	return Plugin_Handled;
}

public Action:Command_TeleportMyLocation(client, args)
{
	if (args != 0)
	{
		ReplyToCommand(client, "[SM] Usage: sm_telemyloc");
		return Plugin_Handled;
	}
	
	TF2Perks_TeleportToSavedLocation(client);
	return Plugin_Handled;
}
#endif


#if defined ENABLE_ROF
public Action:Command_RateOfFire(client, args)
{
	if (args < 2)
	{
		ReplyToCommand(client, "[SM] Usage: sm_rof <client> <amount>");
		return Plugin_Handled;
	}
	
	new String:arg1[32];
	new String:arg2[32];
	
	GetCmdArg(1, arg1, sizeof(arg1));
	GetCmdArg(2, arg2, sizeof(arg2));
	
	decl String:target_name[MAX_TARGET_LENGTH];
	decl target_list[MAXPLAYERS], target_count, bool:tn_is_ml;
	
	if ((target_count = ProcessTargetString(
			arg1,
			client,
			target_list,
			MAXPLAYERS,
			COMMAND_FILTER_CONNECTED,
			target_name,
			sizeof(target_name),
			tn_is_ml)) <= 0)
	{
		ReplyToTargetError(client, target_count);
		return Plugin_Handled;
	}
	
	new Float:flROFMulti = StringToFloat(arg2);
	for (new i = 0; i < target_count; i++)
	{
		TF2Perks_ModRateOfFire(target_list[i], flROFMulti);
	}
	
	if (flROFMulti == 1)
	{
		ReplyToCommand(client, "[TF2Perks] ROF disabled for %s", target_name);
	}
	else
	{
		ReplyToCommand(client, "[TF2Perks] ROF set to: %s for %s", arg2, target_name);
	}
	
	return Plugin_Handled;
}
#endif

#if defined ENABLE_SIZE
public Action:Command_Size(client, args)
{
	if (args < 2)
	{
		ReplyToCommand(client, "[SM] Usage: sm_size <client> <scale>");
		return Plugin_Handled;
	}
	
	new String:arg1[32];
	new String:arg2[32];
	
	GetCmdArg(1, arg1, sizeof(arg1));
	GetCmdArg(2, arg2, sizeof(arg2));
	
	decl String:target_name[MAX_TARGET_LENGTH];
	decl target_list[MAXPLAYERS], target_count, bool:tn_is_ml;
	
	if ((target_count = ProcessTargetString(
			arg1,
			client,
			target_list,
			MAXPLAYERS,
			COMMAND_FILTER_CONNECTED,
			target_name,
			sizeof(target_name),
			tn_is_ml)) <= 0)
	{
		ReplyToTargetError(client, target_count);
		return Plugin_Handled;
	}
	
	new Float:flScale = StringToFloat(arg2);
	for (new i = 0; i < target_count; i++)
	{
		TF2Perks_ResizePlayer(target_list[i], flScale);
	}
	
	if (flScale == 1)
	{
		ReplyToCommand(client, "[TF2Perks] Size disabled for %s", target_name);
	}
	else
	{
		ReplyToCommand(client, "[TF2Perks] Size set to: %s for %s", arg2, target_name);
	}
	
	return Plugin_Handled;
}
#endif


stock bool:IsValidClient(client)
{
	if (client <= 0) return false;
	if (client > MaxClients) return false;
	return IsClientInGame(client);
}
