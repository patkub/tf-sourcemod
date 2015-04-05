#pragma semicolon 1
#include <sourcemod>
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
#define ENABLE_TELEPORT

#include "tf2perksmenu/menu.sp"
#define ADMFLAG_DONOR ADMFLAG_CUSTOM1

public Plugin:myinfo =
{
	name = "TF2 Perks Menu",
	author = "Patka",
	description = "TF2 perks menu.",
	version = PLUGIN_VERSION,
	url = "http://forums.alliedmods.net"
};

public OnPluginStart()
{
	LoadTranslations("common.phrases");
	CreateConVar("tf_perks_menu_version", PLUGIN_VERSION, "TF2 Perks Menu plugin version.", FCVAR_PLUGIN|FCVAR_NOTIFY|FCVAR_REPLICATED);
	RegAdminCmd("sm_perks", Command_Perks, ADMFLAG_DONOR, "Open perks menu.");
}

public Action:Command_Perks(client, args)
{
	if (args != 0)
	{
		ReplyToCommand(client, "[SM] Usage: sm_donor");
		return Plugin_Handled;
	}
	
	if (!IsValidClient(client))
	{
		ReplyToCommand(client, "[TF2Perks] You must be in-game to use this command.");
		return Plugin_Handled;
	}
	
	ShowPerksMenu(client);
	return Plugin_Handled;
}

stock bool:IsValidClient(client)
{
	if (client <= 0) return false;
	if (client > MaxClients) return false;
	return IsClientInGame(client);
}
