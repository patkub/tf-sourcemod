#pragma semicolon 1
#include <sourcemod>
#include <clientprefs>
#include <tf2>
#include <tf2_stocks>
#include <tf2items>
#include <tf2idb>
#undef REQUIRE_PLUGIN

#define PLUGIN_VERSION		"1.0"

#define MENU_UNUSUALS						(1 << 1)
#define MENU_UNUSUAL_EFFECTS				(1 << 2)
#define MENU_UNUSUAL_EFFECT_SLOT			(1 << 3)
#define MENU_UNUSUAL_TAUNTS					(1 << 4)
#define MENU_UNUSUAL_TAUNT_SLOT				(1 << 5)

#define MENU_AUSTRALIUM						(1 << 1)
#define MENU_AUSTRALIUM_SLOT				(1 << 2)

#define MENU_KILLSTREAK						(1 << 1)
#define MENU_KILLSTREAK_TIERS				(1 << 2)
#define MENU_KILLSTREAK_SHEENS				(1 << 3)
#define MENU_KILLSTREAK_TIER_SLOT			(1 << 4)
#define MENU_KILLSTREAK_SHEEN_SLOT			(1 << 5)

new Handle:g_hClientHats[3] = INVALID_HANDLE;						//0 - Head, 1 - Misc, 2 - Action
new Handle:g_hClientParticles[8] = INVALID_HANDLE;					//0 - Primary, 1 - Secondary, 2 - Melee, 3 - PDA1, 4 - PDA2, 5 - Hat, 6 - Misc, 7 - Action
new Handle:g_hClientAustralium[5] = INVALID_HANDLE;					//0 - Primary, 1 - Secondary, 2 - Melee, 3 - PDA1, 4 - PDA2
new Handle:g_hClientKillstreakTier[5] = INVALID_HANDLE;				//0 - Primary, 1 - Secondary, 2 - Melee, 3 - PDA1, 4 - PDA2
new Handle:g_hClientKillstreakSheen[5] = INVALID_HANDLE;			//0 - Primary, 1 - Secondary, 2 - Melee, 3 - PDA1, 4 - PDA2

new Float:g_fParticleValue[MAXPLAYERS+1];
new Float:g_fTauntValue[MAXPLAYERS+1];
new String:g_strAustraliumValue[MAXPLAYERS+1][256];
new String:g_strKillstreakTierValue[MAXPLAYERS+1][256];
new String:g_strKillstreakSheenValue[MAXPLAYERS+1][256];

new String:strUnusualName[256][256];
new String:strUnusualEffect[256][256];
new UnusualCount;

new String:strUnusualTauntName[256][256];
new String:strUnusualTauntEffect[256][256];
new UnusualTauntCount;

new g_iHealth[MAXPLAYERS+1];

public Plugin:myinfo =
{
	name = "[TF2Items] Wearables",
	author = "Patka",
	description = "TF2Items Wearables Mod.",
	version = PLUGIN_VERSION,
	url = "http://forums.alliedmods.net"
};

public OnPluginStart()
{
	LoadTranslations("common.phrases");
	
	g_hClientHats[0] = RegClientCookie("tf2items_wearables_index_head", "", CookieAccess_Private);
	g_hClientHats[1] = RegClientCookie("tf2items_wearables_index_misc", "", CookieAccess_Private);
	g_hClientHats[2] = RegClientCookie("tf2items_wearables_index_action", "", CookieAccess_Private);
	
	g_hClientParticles[0] = RegClientCookie("tf2items_wearables_particle_primary", "", CookieAccess_Private);
	g_hClientParticles[1] = RegClientCookie("tf2items_wearables_particle_secondary", "", CookieAccess_Private);
	g_hClientParticles[2] = RegClientCookie("tf2items_wearables_particle_melee", "", CookieAccess_Private);
	g_hClientParticles[3] = RegClientCookie("tf2items_wearables_particle_pda1", "", CookieAccess_Private);
	g_hClientParticles[4] = RegClientCookie("tf2items_wearables_particle_pda2", "", CookieAccess_Private);
	g_hClientParticles[5] = RegClientCookie("tf2items_wearables_particle_hat", "", CookieAccess_Private);
	g_hClientParticles[6] = RegClientCookie("tf2items_wearables_particle_misc", "", CookieAccess_Private);
	g_hClientParticles[7] = RegClientCookie("tf2items_wearables_particle_action", "", CookieAccess_Private);
	
	g_hClientAustralium[0] = RegClientCookie("tf2items_wearables_australium_primary", "", CookieAccess_Private);
	g_hClientAustralium[1] = RegClientCookie("tf2items_wearables_australium_secondary", "", CookieAccess_Private);
	g_hClientAustralium[2] = RegClientCookie("tf2items_wearables_australium_melee", "", CookieAccess_Private);
	g_hClientAustralium[3] = RegClientCookie("tf2items_wearables_australium_pda1", "", CookieAccess_Private);
	g_hClientAustralium[4] = RegClientCookie("tf2items_wearables_australium_pda2", "", CookieAccess_Private);
	
	g_hClientKillstreakTier[0] = RegClientCookie("tf2items_wearables_killstreak_tier_primary", "", CookieAccess_Private);
	g_hClientKillstreakTier[1] = RegClientCookie("tf2items_wearables_killstreak_tier_secondary", "", CookieAccess_Private);
	g_hClientKillstreakTier[2] = RegClientCookie("tf2items_wearables_killstreak_tier_melee", "", CookieAccess_Private);
	g_hClientKillstreakTier[3] = RegClientCookie("tf2items_wearables_killstreak_tier_pda1", "", CookieAccess_Private);
	g_hClientKillstreakTier[4] = RegClientCookie("tf2items_wearables_killstreak_tier_pda2", "", CookieAccess_Private);
	
	g_hClientKillstreakSheen[0] = RegClientCookie("tf2items_wearables_killstreak_sheen_primary", "", CookieAccess_Private);
	g_hClientKillstreakSheen[1] = RegClientCookie("tf2items_wearables_killstreak_sheen_secondary", "", CookieAccess_Private);
	g_hClientKillstreakSheen[2] = RegClientCookie("tf2items_wearables_killstreak_sheen_melee", "", CookieAccess_Private);
	g_hClientKillstreakSheen[3] = RegClientCookie("tf2items_wearables_killstreak_sheen_pda1", "", CookieAccess_Private);
	g_hClientKillstreakSheen[4] = RegClientCookie("tf2items_wearables_killstreak_sheen_pda2", "", CookieAccess_Private);
	
	HookEvent("player_spawn", Event_PlayerSpawn);
	CreateConVar("tf_wearables_version", PLUGIN_VERSION, "[TF2Items] Wearables plugin version.", FCVAR_PLUGIN|FCVAR_NOTIFY|FCVAR_REPLICATED);
	
	RegAdminCmd("sm_unusuals", Command_Unusuals, ADMFLAG_CUSTOM6);
	RegAdminCmd("sm_australium", Command_Australium, ADMFLAG_CUSTOM6);
	RegAdminCmd("sm_killstreak", Command_Killstreak, ADMFLAG_CUSTOM6);
	RegAdminCmd("sm_givehat", Command_GiveHat, ADMFLAG_CUSTOM6);
	RegAdminCmd("sm_giveunusual", Command_GiveUnusual, ADMFLAG_CUSTOM6);
	RegAdminCmd("sm_forcegive", Command_ForceGive, ADMFLAG_CUSTOM6);
	RegAdminCmd("sm_removehats", Command_RemoveHats, ADMFLAG_CUSTOM6);
}

public OnClientPostAdminCheck(client)
{
	decl i;
	g_iHealth[client] = -1;
	g_fParticleValue[client] = 0.0;
	g_fTauntValue[client] = 0.0;
	g_strAustraliumValue[client] = "0.0";
	
	for (i = 0; i < sizeof(g_hClientHats); i++)
	{
		SetClientCookie(client, g_hClientHats[i], "-1");
	}
	
	for (i = 0; i < sizeof(g_hClientParticles); i++)
	{
		SetClientCookie(client, g_hClientParticles[i], "0.0");
	}
	
	for (i = 0; i < sizeof(g_hClientAustralium); i++)
	{
		SetClientCookie(client, g_hClientAustralium[i], "0.0");
	}
	
	for (i = 0; i < sizeof(g_hClientKillstreakTier); i++)
	{
		SetClientCookie(client, g_hClientKillstreakTier[i], "0.0");
	}
	
	for (i = 0; i < sizeof(g_hClientKillstreakSheen); i++)
	{
		SetClientCookie(client, g_hClientKillstreakSheen[i], "0.0");
	}
}

public Action:Event_PlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	new userid = GetEventInt(event, "userid");
	new client = GetClientOfUserId(userid);
	TF2_ForceGive(client);
	
	return Plugin_Continue;
}

public Action:Command_Unusuals(client, args)
{
	ShowUnusualsMenu(client, MENU_UNUSUALS);
	return Plugin_Handled;
}

public ShowUnusualsMenu(client, menutype)
{
	decl Handle:menu;
	
	if (menutype & MENU_UNUSUALS)
	{
		menu = CreateMenu(hUnusualMenuCallback);
		SetMenuTitle(menu, "TF2 Unusuals Menu:");
		AddMenuItem(menu, "0", "Effects");
		AddMenuItem(menu, "1", "Taunts");
	}
	
	if (menutype & MENU_UNUSUAL_EFFECTS)
	{
		menu = CreateMenu(hUnusualEffectMenuCallback);
		SetMenuTitle(menu, "TF2 Unusual Effects:");
		SetMenuExitBackButton(menu, true);
		AddMenuItem(menu, "0.0", "Remove Effect");
		
		ReloadUnusualCFG();
		for (new i = 0; i < UnusualCount; i++)
		{
			AddMenuItem(menu, strUnusualEffect[i], strUnusualName[i]);
		}
	}
	
	if (menutype & MENU_UNUSUAL_EFFECT_SLOT)
	{
		menu = CreateMenu(hUnusualEffectSlotMenuCallback);
		SetMenuTitle(menu, "TF2 Unusual Effect Slot:");
		SetMenuExitBackButton(menu, true);
		
		AddMenuItem(menu, "0", "Primary Weapon Slot");
		AddMenuItem(menu, "1", "Secondary Weapon Slot");
		AddMenuItem(menu, "2", "Melee Weapon Slot");
		AddMenuItem(menu, "3", "PDA 1 Slot");
		AddMenuItem(menu, "4", "PDA 2 Slot");
		AddMenuItem(menu, "5", "Hat Slot");
		AddMenuItem(menu, "6", "Misc Slot");
		AddMenuItem(menu, "7", "Action Slot");
	}
	
	if (menutype & MENU_UNUSUAL_TAUNTS)
	{
		menu = CreateMenu(hUnusualTauntMenuCallback);
		SetMenuTitle(menu, "TF2 Unusual Taunts:");
		SetMenuExitBackButton(menu, true);
		AddMenuItem(menu, "0.0", "Remove Effect");
		
		ReloadUnusualTauntCFG();
		for (new i = 0; i < UnusualTauntCount; i++)
		{
			AddMenuItem(menu, strUnusualTauntEffect[i], strUnusualTauntName[i]);
		}
	}
	
	if (menutype & MENU_UNUSUAL_TAUNT_SLOT)
	{
		menu = CreateMenu(hUnusualTauntSlotMenuCallback);
		SetMenuTitle(menu, "TF2 Unusual Taunt Slot:");
		SetMenuExitBackButton(menu, true);
		
		AddMenuItem(menu, "0", "Primary Weapon Slot");
		AddMenuItem(menu, "1", "Secondary Weapon Slot");
		AddMenuItem(menu, "2", "Melee Weapon Slot");
		AddMenuItem(menu, "3", "PDA 1 Slot");
		AddMenuItem(menu, "4", "PDA 2 Slot");
		AddMenuItem(menu, "5", "Hat Slot");
		AddMenuItem(menu, "6", "Misc Slot");
		AddMenuItem(menu, "7", "Action Slot");
	}
	
	DisplayMenu(menu, client, MENU_TIME_FOREVER);
}

public hUnusualMenuCallback(Handle:menu, MenuAction:action, client, param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			new String:info[16];
			GetMenuItem(menu, param2, info, sizeof(info));
			new index = StringToInt(info);
			
			switch (index)
			{
				case 0:
				{
					ShowUnusualsMenu(client, MENU_UNUSUAL_EFFECTS);
				}
				
				case 1:
				{
					ShowUnusualsMenu(client, MENU_UNUSUAL_TAUNTS);
				}
			}
		}

		case MenuAction_End:
		{
			CloseHandle(menu);
		}
	}
}

public hUnusualEffectMenuCallback(Handle:menu, MenuAction:action, client, param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			new String:info[16];
			GetMenuItem(menu, param2, info, sizeof(info));
			g_fParticleValue[client] = StringToFloat(info);
			
			ShowUnusualsMenu(client, MENU_UNUSUAL_EFFECT_SLOT);
		}
		
		case MenuAction_Cancel:
		{
			if (param2 == MenuCancel_ExitBack)
			{
				ShowUnusualsMenu(client, MENU_UNUSUALS);
			}
		}
		
		case MenuAction_End:
		{
			CloseHandle(menu);
		}
	}
}

public hUnusualEffectSlotMenuCallback(Handle:menu, MenuAction:action, client, param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			new String:info[16];
			GetMenuItem(menu, param2, info, sizeof(info));
			new EffectSlotIndex = StringToInt(info);
			
			new String:strParticle[65];
			FloatToString(g_fParticleValue[client], strParticle, sizeof(strParticle));
			SetClientCookie(client, g_hClientParticles[EffectSlotIndex], strParticle);
			TF2_ForceGive(client);
			
			ShowUnusualsMenu(client, MENU_UNUSUAL_EFFECTS);
		}
	
		case MenuAction_Cancel:
		{
			if (param2 == MenuCancel_ExitBack)
			{
				ShowUnusualsMenu(client, MENU_UNUSUAL_EFFECTS);
			}
		}
		
		case MenuAction_End:
		{
			CloseHandle(menu);
		}
	}
}

public hUnusualTauntMenuCallback(Handle:menu, MenuAction:action, client, param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			new String:info[16];
			GetMenuItem(menu, param2, info, sizeof(info));
			g_fTauntValue[client] = StringToFloat(info);
			
			ShowUnusualsMenu(client, MENU_UNUSUAL_TAUNT_SLOT);
		}
		
		case MenuAction_Cancel:
		{
			if (param2 == MenuCancel_ExitBack)
			{
				ShowUnusualsMenu(client, MENU_UNUSUALS);
			}
		}
		
		case MenuAction_End:
		{
			CloseHandle(menu);
		}
	}
}

public hUnusualTauntSlotMenuCallback(Handle:menu, MenuAction:action, client, param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			new String:info[16];
			GetMenuItem(menu, param2, info, sizeof(info));
			new EffectSlotIndex = StringToInt(info);
			
			new String:strParticle[65];
			FloatToString(g_fTauntValue[client], strParticle, sizeof(strParticle));
			SetClientCookie(client, g_hClientParticles[EffectSlotIndex], strParticle);
			TF2_ForceGive(client);
			
			ShowUnusualsMenu(client, MENU_UNUSUAL_TAUNTS);
		}
	
		case MenuAction_Cancel:
		{
			if (param2 == MenuCancel_ExitBack)
			{
				ShowUnusualsMenu(client, MENU_UNUSUALS);
			}
		}
		
		case MenuAction_End:
		{
			CloseHandle(menu);
		}
	}
}

public Action:Command_Australium(client, args)
{
	ShowAustraliumMenu(client, MENU_AUSTRALIUM);
	return Plugin_Handled;
}

public ShowAustraliumMenu(client, menutype)
{
	decl Handle:menu;
	
	if (menutype & MENU_AUSTRALIUM)
	{
		menu = CreateMenu(hAustraliumMenuCallback);
		SetMenuTitle(menu, "TF2 Australium Menu:");
		AddMenuItem(menu, "1.0", "Attach");
		AddMenuItem(menu, "0.0", "Remove");
	}
	
	if (menutype & MENU_AUSTRALIUM_SLOT)
	{
		menu = CreateMenu(hAustraliumSlotMenuCallback);
		SetMenuExitBackButton(menu, true);
		SetMenuTitle(menu, "TF2 Australium Slot:");
		AddMenuItem(menu, "0", "Primary Weapon Slot");
		AddMenuItem(menu, "1", "Secondary Weapon Slot");
		AddMenuItem(menu, "2", "Melee Weapon Slot");
		AddMenuItem(menu, "3", "PDA 1 Slot");
		AddMenuItem(menu, "4", "PDA 2 Slot");
	}
	
	DisplayMenu(menu, client, MENU_TIME_FOREVER);
}

public hAustraliumMenuCallback(Handle:menu, MenuAction:action, client, param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			new String:info[16];
			GetMenuItem(menu, param2, info, sizeof(info));
			g_strAustraliumValue[client] = info;
			ShowAustraliumMenu(client, MENU_AUSTRALIUM_SLOT);
		}

		case MenuAction_End:
		{
			CloseHandle(menu);
		}
	}
}

public hAustraliumSlotMenuCallback(Handle:menu, MenuAction:action, client, param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			new String:info[16];
			GetMenuItem(menu, param2, info, sizeof(info));
			new AustraliumSlotIndex = StringToInt(info);
			
			SetClientCookie(client, g_hClientAustralium[AustraliumSlotIndex], g_strAustraliumValue[client]);
			TF2_ForceGive(client);
			
			ShowAustraliumMenu(client, MENU_AUSTRALIUM);
		}
		
		case MenuAction_End:
		{
			CloseHandle(menu);
		}
	}
}

public Action:Command_Killstreak(client, args)
{
	ShowKillstreakMenu(client, MENU_KILLSTREAK);
	return Plugin_Handled;
}

public ShowKillstreakMenu(client, menutype)
{
	decl Handle:menu;
	
	if (menutype & MENU_KILLSTREAK)
	{
		menu = CreateMenu(hKillsteakMenuCallback);
		SetMenuTitle(menu, "TF2 Killsteaks Menu:");
		AddMenuItem(menu, "0", "Tiers");
		AddMenuItem(menu, "1", "Sheens");
	}
	
	if (menutype & MENU_KILLSTREAK_TIERS)
	{
		menu = CreateMenu(hKillsteakTierMenuCallback);
		SetMenuExitBackButton(menu, true);
		SetMenuTitle(menu, "TF2 Killsteak Tiers:");
		AddMenuItem(menu, "0", "None");
		AddMenuItem(menu, "1", "Normal");
		AddMenuItem(menu, "2", "Specialized");
		AddMenuItem(menu, "3", "Professional");
	}
	
	if (menutype & MENU_KILLSTREAK_SHEENS)
	{
		menu = CreateMenu(hKillsteakSheenMenuCallback);
		SetMenuExitBackButton(menu, true);
		SetMenuTitle(menu, "TF2 Killsteak Sheens:");
		AddMenuItem(menu, "0", "None");
		AddMenuItem(menu, "1", "Team Shine");
		AddMenuItem(menu, "2", "Deadly Daffodil");
		AddMenuItem(menu, "3", "Manndarin");
		AddMenuItem(menu, "4", "Mean Green");
		AddMenuItem(menu, "5", "Agonizing Emerald");
		AddMenuItem(menu, "6", "Villainous Violet");
		AddMenuItem(menu, "7", "Hot Rod");
	}
	
	if (menutype & MENU_KILLSTREAK_TIER_SLOT)
	{
		menu = CreateMenu(hKillsteakTierSlotMenuCallback);
		SetMenuTitle(menu, "TF2 Killsteak Tier Slot:");
		AddMenuItem(menu, "0", "Primary Weapon Slot");
		AddMenuItem(menu, "1", "Secondary Weapon Slot");
		AddMenuItem(menu, "2", "Melee Weapon Slot");
		AddMenuItem(menu, "3", "PDA 1 Slot");
		AddMenuItem(menu, "4", "PDA 2 Slot");
	}
	
	if (menutype & MENU_KILLSTREAK_SHEEN_SLOT)
	{
		menu = CreateMenu(hKillsteakSheenSlotMenuCallback);
		SetMenuTitle(menu, "TF2 Killsteak Sheen Slot:");
		AddMenuItem(menu, "0", "Primary Weapon Slot");
		AddMenuItem(menu, "1", "Secondary Weapon Slot");
		AddMenuItem(menu, "2", "Melee Weapon Slot");
		AddMenuItem(menu, "3", "PDA 1 Slot");
		AddMenuItem(menu, "4", "PDA 2 Slot");
	}
	
	DisplayMenu(menu, client, MENU_TIME_FOREVER);
}

public hKillsteakMenuCallback(Handle:menu, MenuAction:action, client, param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			new String:info[16];
			GetMenuItem(menu, param2, info, sizeof(info));
			new index = StringToInt(info);
			
			switch (index)
			{
				case 0:
				{
					ShowKillstreakMenu(client, MENU_KILLSTREAK_TIERS);
				}
				
				case 1:
				{
					ShowKillstreakMenu(client, MENU_KILLSTREAK_SHEENS);
				}
			}
		}
		
		case MenuAction_End:
		{
			CloseHandle(menu);
		}
	}
}

public hKillsteakTierMenuCallback(Handle:menu, MenuAction:action, client, param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			new String:info[16];
			GetMenuItem(menu, param2, info, sizeof(info));
			g_strKillstreakTierValue[client] = info;
			ShowKillstreakMenu(client, MENU_KILLSTREAK_TIER_SLOT);
		}
		
		case MenuAction_Cancel:
		{
			if (param2 == MenuCancel_ExitBack)
			{
				ShowKillstreakMenu(client, MENU_KILLSTREAK);
			}
		}
		
		case MenuAction_End:
		{
			CloseHandle(menu);
		}
	}
}

public hKillsteakTierSlotMenuCallback(Handle:menu, MenuAction:action, client, param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			new String:info[16];
			GetMenuItem(menu, param2, info, sizeof(info));
			new KillstreakSlotIndex = StringToInt(info);
			
			SetClientCookie(client, g_hClientKillstreakTier[KillstreakSlotIndex], g_strKillstreakTierValue[client]);
			TF2_ForceGive(client);
			
			ShowKillstreakMenu(client, MENU_KILLSTREAK_TIERS);
		}
		
		case MenuAction_End:
		{
			CloseHandle(menu);
		}
	}
}

public hKillsteakSheenMenuCallback(Handle:menu, MenuAction:action, client, param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			new String:info[16];
			GetMenuItem(menu, param2, info, sizeof(info));
			g_strKillstreakSheenValue[client] = info;
			ShowKillstreakMenu(client, MENU_KILLSTREAK_SHEEN_SLOT);
		}
		
		case MenuAction_Cancel:
		{
			if (param2 == MenuCancel_ExitBack)
			{
				ShowKillstreakMenu(client, MENU_KILLSTREAK);
			}
		}
		
		case MenuAction_End:
		{
			CloseHandle(menu);
		}
	}
}

public hKillsteakSheenSlotMenuCallback(Handle:menu, MenuAction:action, client, param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			new String:info[16];
			GetMenuItem(menu, param2, info, sizeof(info));
			new KillstreakSlotIndex = StringToInt(info);
			
			SetClientCookie(client, g_hClientKillstreakSheen[KillstreakSlotIndex], g_strKillstreakSheenValue[client]);
			TF2_ForceGive(client);
			
			ShowKillstreakMenu(client, MENU_KILLSTREAK_SHEENS);
		}
		
		case MenuAction_End:
		{
			CloseHandle(menu);
		}
	}
}

public Action:Command_GiveHat(client, args)
{
	if (args != 3)
	{
		ReplyToCommand(client, "[SM] Usage: sm_givehat <client> <slot id: 0 - hat, 1 - misc, 2 - action> <index, -1 for no hat>");
		return Plugin_Handled;
	}
	
	new String:arg1[32];
	GetCmdArg(1, arg1, sizeof(arg1));
	
	new String:arg2[32];
	GetCmdArg(2, arg2, sizeof(arg2));
	
	new String:arg3[32];
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
	if (slot != 0 && slot != 1 && slot != 2)
	{
		PrintToChat(client, "[SM] Invalid Slot ID. Valid IDs are 0 for Hat, 1 for Misc, or 2 for Action.");
		return Plugin_Handled;
	}
	
	for (new i = 0; i < target_count; i++)
	{
		SetClientCookie(target_list[i], g_hClientHats[slot], arg3);
		TF2_ForceGive(target_list[i]);
	}
	
	return Plugin_Handled;
}

public Action:Command_GiveUnusual(client, args)
{
	if (args != 3)
	{
		ReplyToCommand(client, "[SM] Usage: sm_giveunusual <client> <slot id: 0 - primary, 1 - secondary, 2 - melee, 3 - pda1, 4 - pda2, 5 - hat, 6 - misc, or 7 - action> <effect value, 0 for no effect>");
		return Plugin_Handled;
	}
	
	new String:arg1[32];
	GetCmdArg(1, arg1, sizeof(arg1));
	
	new String:arg2[32];
	GetCmdArg(2, arg2, sizeof(arg2));
	
	new String:arg3[32];
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
	if (slot < 0 || slot > 7)
	{
		PrintToChat(client, "[SM] Invalid Slot ID. Valid IDs are 0 for Primary, 1 for Secondary, 2 for Melee, 3 for PDA1, 4 for PDA2, 5 for Hat, 6 for Misc, or 7 for Action.");
		return Plugin_Handled;
	}
	
	for (new i = 0; i < target_count; i++)
	{
		SetClientCookie(target_list[i], g_hClientParticles[slot], arg3);
		TF2_ForceGive(target_list[i]);
	}
	
	return Plugin_Handled;
}

public Action:Command_ForceGive(client, args)
{
	if (args != 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_forcegive <client>");
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
		TF2_ForceGive(target_list[i]);
		PrintToChat(target_list[i], "[SM] Items Regiven");
	}
	
	return Plugin_Handled;
}

public Action:Command_RemoveHats(client, args)
{
	if (args != 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_removehats <client>");
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
		TF2_RemoveAllWearables(client);
		PrintToChat(target_list[i], "[SM] Wearables Removed");
	}
	
	return Plugin_Handled;
}

public Action:TF2Items_OnGiveNamedItem(client, String:classname[], iItemDefinitionIndex, &Handle:hItem)
{
	decl i;
	new String:strHats[3][65];
	new HatIndex[3];
	
	new String:strParticles[8][65];
	new Float:flParticles[8];
	
	new String:strAustralium[5][65];
	new Float:flAustralium[5];
	
	new String:strKillstreakTier[5][65];
	new Float:flKillstreakTier[5];
	
	new String:strKillstreakSheen[5][65];
	new Float:flKillstreakSheen[5];
	
	for (i = 0; i < sizeof(g_hClientHats); i++)
	{
		GetClientCookie(client, g_hClientHats[i], strHats[i], 65);
	}
	
	for (i = 0; i < sizeof(HatIndex); i++)
	{
		HatIndex[i] = StringToInt(strHats[i]);
	}
	
	for (i = 0; i < sizeof(g_hClientParticles); i++)
	{
		GetClientCookie(client, g_hClientParticles[i], strParticles[i], 65);
	}
	
	for (i = 0; i < sizeof(flParticles); i++)
	{
		flParticles[i] = StringToFloat(strParticles[i]);
	}
	
	for (i = 0; i < sizeof(g_hClientAustralium); i++)
	{
		GetClientCookie(client, g_hClientAustralium[i], strAustralium[i], 65);
	}
	
	for (i = 0; i < sizeof(flAustralium); i++)
	{
		flAustralium[i] = StringToFloat(strAustralium[i]);
	}
	
	for (i = 0; i < sizeof(g_hClientKillstreakTier); i++)
	{
		GetClientCookie(client, g_hClientKillstreakTier[i], strKillstreakTier[i], 65);
	}
	
	for (i = 0; i < sizeof(flKillstreakTier); i++)
	{
		flKillstreakTier[i] = StringToFloat(strKillstreakTier[i]);
	}
	
	for (i = 0; i < sizeof(g_hClientKillstreakSheen); i++)
	{
		GetClientCookie(client, g_hClientKillstreakSheen[i], strKillstreakSheen[i], 65);
	}
	
	for (i = 0; i < sizeof(flKillstreakSheen); i++)
	{
		flKillstreakSheen[i] = StringToFloat(strKillstreakSheen[i]);
	}
	
	new TF2ItemSlot:slot = TF2IDB_GetItemSlot(iItemDefinitionIndex);
	switch (slot)
	{
		case 0, 1, 2, 3, 4:
		{
			if (flParticles[slot] != 0.0 && flAustralium[slot] != 0.0 && flKillstreakTier[slot] != 0.0 && flKillstreakSheen[slot] != 0.0)
			{
				hItem = TF2Items_CreateItem(OVERRIDE_ATTRIBUTES|PRESERVE_ATTRIBUTES);
				TF2Items_SetNumAttributes(hItem, 6);
				TF2Items_SetAttribute(hItem, 0, 134, flParticles[slot]);
				TF2Items_SetAttribute(hItem, 1, 542, flAustralium[slot]);
				TF2Items_SetAttribute(hItem, 2, 2022, flAustralium[slot]);
				TF2Items_SetAttribute(hItem, 3, 2027, flAustralium[slot]);
				TF2Items_SetAttribute(hItem, 4, 2025, flKillstreakTier[slot]);
				TF2Items_SetAttribute(hItem, 5, 2014, flKillstreakSheen[slot]);
				TF2Items_SetFlags(hItem, OVERRIDE_ATTRIBUTES|PRESERVE_ATTRIBUTES);
				return Plugin_Changed;
			}
			
			if (flParticles[slot] != 0.0 && flAustralium[slot] != 0.0 && flKillstreakTier[slot] != 0.0)
			{
				hItem = TF2Items_CreateItem(OVERRIDE_ATTRIBUTES|PRESERVE_ATTRIBUTES);
				TF2Items_SetNumAttributes(hItem, 5);
				TF2Items_SetAttribute(hItem, 0, 134, flParticles[slot]);
				TF2Items_SetAttribute(hItem, 1, 542, flAustralium[slot]);
				TF2Items_SetAttribute(hItem, 2, 2022, flAustralium[slot]);
				TF2Items_SetAttribute(hItem, 3, 2027, flAustralium[slot]);
				TF2Items_SetAttribute(hItem, 4, 2025, flKillstreakTier[slot]);
				TF2Items_SetFlags(hItem, OVERRIDE_ATTRIBUTES|PRESERVE_ATTRIBUTES);
				return Plugin_Changed;
			}
			
			if (flParticles[slot] != 0.0 && flAustralium[slot] != 0.0 && flKillstreakSheen[slot] != 0.0)
			{
				hItem = TF2Items_CreateItem(OVERRIDE_ATTRIBUTES|PRESERVE_ATTRIBUTES);
				TF2Items_SetNumAttributes(hItem, 5);
				TF2Items_SetAttribute(hItem, 0, 134, flParticles[slot]);
				TF2Items_SetAttribute(hItem, 1, 542, flAustralium[slot]);
				TF2Items_SetAttribute(hItem, 2, 2022, flAustralium[slot]);
				TF2Items_SetAttribute(hItem, 3, 2027, flAustralium[slot]);
				TF2Items_SetAttribute(hItem, 4, 2014, flKillstreakSheen[slot]);
				TF2Items_SetFlags(hItem, OVERRIDE_ATTRIBUTES|PRESERVE_ATTRIBUTES);
				return Plugin_Changed;
			}
			
			if (flParticles[slot] != 0.0 && flAustralium[slot] != 0.0)
			{
				hItem = TF2Items_CreateItem(OVERRIDE_ATTRIBUTES|PRESERVE_ATTRIBUTES);
				TF2Items_SetNumAttributes(hItem, 4);
				TF2Items_SetAttribute(hItem, 0, 134, flParticles[slot]);
				TF2Items_SetAttribute(hItem, 1, 542, flAustralium[slot]);
				TF2Items_SetAttribute(hItem, 2, 2022, flAustralium[slot]);
				TF2Items_SetAttribute(hItem, 3, 2027, flAustralium[slot]);
				TF2Items_SetFlags(hItem, OVERRIDE_ATTRIBUTES|PRESERVE_ATTRIBUTES);
				return Plugin_Changed;
			}
			
			if (flParticles[slot] != 0.0 && flKillstreakTier[slot] != 0.0 && flKillstreakSheen[slot] != 0.0)
			{
				hItem = TF2Items_CreateItem(OVERRIDE_ATTRIBUTES|PRESERVE_ATTRIBUTES);
				TF2Items_SetNumAttributes(hItem, 3);
				TF2Items_SetAttribute(hItem, 0, 134, flParticles[slot]);
				TF2Items_SetAttribute(hItem, 1, 2025, flKillstreakTier[slot]);
				TF2Items_SetAttribute(hItem, 2, 2014, flKillstreakSheen[slot]);
				TF2Items_SetFlags(hItem, OVERRIDE_ATTRIBUTES|PRESERVE_ATTRIBUTES);
				return Plugin_Changed;
			}
			
			if (flParticles[slot] != 0.0 && flKillstreakTier[slot] != 0.0)
			{
				hItem = TF2Items_CreateItem(OVERRIDE_ATTRIBUTES|PRESERVE_ATTRIBUTES);
				TF2Items_SetNumAttributes(hItem, 2);
				TF2Items_SetAttribute(hItem, 0, 134, flParticles[slot]);
				TF2Items_SetAttribute(hItem, 1, 2025, flKillstreakTier[slot]);
				TF2Items_SetFlags(hItem, OVERRIDE_ATTRIBUTES|PRESERVE_ATTRIBUTES);
				return Plugin_Changed;
			}
			
			if (flParticles[slot] != 0.0 && flKillstreakSheen[slot] != 0.0)
			{
				hItem = TF2Items_CreateItem(OVERRIDE_ATTRIBUTES|PRESERVE_ATTRIBUTES);
				TF2Items_SetNumAttributes(hItem, 2);
				TF2Items_SetAttribute(hItem, 0, 134, flParticles[slot]);
				TF2Items_SetAttribute(hItem, 1, 2014, flKillstreakSheen[slot]);
				TF2Items_SetFlags(hItem, OVERRIDE_ATTRIBUTES|PRESERVE_ATTRIBUTES);
				return Plugin_Changed;
			}
			
			if (flAustralium[slot] != 0.0 && flKillstreakTier[slot] != 0.0 && flKillstreakSheen[slot] != 0.0)
			{
				hItem = TF2Items_CreateItem(OVERRIDE_ATTRIBUTES|PRESERVE_ATTRIBUTES);
				TF2Items_SetNumAttributes(hItem, 5);
				TF2Items_SetAttribute(hItem, 0, 542, flAustralium[slot]);
				TF2Items_SetAttribute(hItem, 1, 2022, flAustralium[slot]);
				TF2Items_SetAttribute(hItem, 2, 2027, flAustralium[slot]);
				TF2Items_SetAttribute(hItem, 3, 2025, flKillstreakTier[slot]);
				TF2Items_SetAttribute(hItem, 4, 2014, flKillstreakSheen[slot]);
				TF2Items_SetFlags(hItem, OVERRIDE_ATTRIBUTES|PRESERVE_ATTRIBUTES);
				return Plugin_Changed;
			}
			
			if (flAustralium[slot] != 0.0 && flKillstreakTier[slot] != 0.0)
			{
				hItem = TF2Items_CreateItem(OVERRIDE_ATTRIBUTES|PRESERVE_ATTRIBUTES);
				TF2Items_SetNumAttributes(hItem, 4);
				TF2Items_SetAttribute(hItem, 0, 542, flAustralium[slot]);
				TF2Items_SetAttribute(hItem, 1, 2022, flAustralium[slot]);
				TF2Items_SetAttribute(hItem, 2, 2027, flAustralium[slot]);
				TF2Items_SetAttribute(hItem, 3, 2025, flKillstreakTier[slot]);
				TF2Items_SetFlags(hItem, OVERRIDE_ATTRIBUTES|PRESERVE_ATTRIBUTES);
				return Plugin_Changed;
			}
			
			if (flAustralium[slot] != 0.0 && flKillstreakSheen[slot] != 0.0)
			{
				hItem = TF2Items_CreateItem(OVERRIDE_ATTRIBUTES|PRESERVE_ATTRIBUTES);
				TF2Items_SetNumAttributes(hItem, 4);
				TF2Items_SetAttribute(hItem, 0, 542, flAustralium[slot]);
				TF2Items_SetAttribute(hItem, 1, 2022, flAustralium[slot]);
				TF2Items_SetAttribute(hItem, 2, 2027, flAustralium[slot]);
				TF2Items_SetAttribute(hItem, 3, 2014, flKillstreakSheen[slot]);
				TF2Items_SetFlags(hItem, OVERRIDE_ATTRIBUTES|PRESERVE_ATTRIBUTES);
				return Plugin_Changed;
			}
			
			if (flKillstreakTier[slot] != 0.0 && flKillstreakSheen[slot] != 0.0)
			{
				hItem = TF2Items_CreateItem(OVERRIDE_ATTRIBUTES|PRESERVE_ATTRIBUTES);
				TF2Items_SetNumAttributes(hItem, 2);
				TF2Items_SetAttribute(hItem, 0, 2025, flKillstreakTier[slot]);
				TF2Items_SetAttribute(hItem, 1, 2014, flKillstreakSheen[slot]);
				TF2Items_SetFlags(hItem, OVERRIDE_ATTRIBUTES|PRESERVE_ATTRIBUTES);
				return Plugin_Changed;
			}
			
			if (flParticles[slot] != 0.0)
			{
				hItem = OnGive(hItem, _, flParticles[slot], OVERRIDE_ATTRIBUTES|PRESERVE_ATTRIBUTES);
				return Plugin_Changed;
			}
			
			if (flAustralium[slot] != 0.0)
			{
				hItem = TF2Items_CreateItem(OVERRIDE_ATTRIBUTES|PRESERVE_ATTRIBUTES);
				TF2Items_SetNumAttributes(hItem, 3);
				TF2Items_SetAttribute(hItem, 0, 542, flAustralium[slot]);
				TF2Items_SetAttribute(hItem, 1, 2022, flAustralium[slot]);
				TF2Items_SetAttribute(hItem, 2, 2027, flAustralium[slot]);
				TF2Items_SetFlags(hItem, OVERRIDE_ATTRIBUTES|PRESERVE_ATTRIBUTES);
				return Plugin_Changed;
			}
			
			if (flKillstreakTier[slot] != 0.0)
			{
				hItem = TF2Items_CreateItem(OVERRIDE_ATTRIBUTES|PRESERVE_ATTRIBUTES);
				TF2Items_SetNumAttributes(hItem, 1);
				TF2Items_SetAttribute(hItem, 0, 2025, flKillstreakTier[slot]);
				TF2Items_SetFlags(hItem, OVERRIDE_ATTRIBUTES|PRESERVE_ATTRIBUTES);
				return Plugin_Changed;
			}
			
			if (flKillstreakSheen[slot] != 0.0)
			{
				hItem = TF2Items_CreateItem(OVERRIDE_ATTRIBUTES|PRESERVE_ATTRIBUTES);
				TF2Items_SetNumAttributes(hItem, 1);
				TF2Items_SetAttribute(hItem, 0, 2014, flKillstreakSheen[slot]);
				TF2Items_SetFlags(hItem, OVERRIDE_ATTRIBUTES|PRESERVE_ATTRIBUTES);
				return Plugin_Changed;
			}
		}
		
		case 5:
		{
			if (HatIndex[0] != -1 && flParticles[slot] != 0.0)
			{
				hItem = OnGive(hItem, HatIndex[0], flParticles[slot], OVERRIDE_ITEM_DEF|OVERRIDE_ATTRIBUTES|PRESERVE_ATTRIBUTES);
				return Plugin_Changed;
			}
			
			if (HatIndex[0] != -1)
			{
				hItem = OnGive(hItem, HatIndex[0], _, OVERRIDE_ITEM_DEF|PRESERVE_ATTRIBUTES);
				return Plugin_Changed;
			}
			
			if (flParticles[slot] != 0.0)
			{
				hItem = OnGive(hItem, _, flParticles[slot], OVERRIDE_ATTRIBUTES|PRESERVE_ATTRIBUTES);
				return Plugin_Changed;
			}
		}
		
		case 6:
		{
			if (HatIndex[1] != -1 && flParticles[slot] != 0.0)
			{
				hItem = OnGive(hItem, HatIndex[1], flParticles[slot], OVERRIDE_ITEM_DEF|OVERRIDE_ATTRIBUTES|PRESERVE_ATTRIBUTES);
				return Plugin_Changed;
			}
			
			if (HatIndex[1] != -1)
			{
				hItem = OnGive(hItem, HatIndex[1], _, OVERRIDE_ITEM_DEF|PRESERVE_ATTRIBUTES);
				return Plugin_Changed;
			}
			
			if (flParticles[slot] != 0.0)
			{
				hItem = OnGive(hItem, _, flParticles[slot], OVERRIDE_ATTRIBUTES|PRESERVE_ATTRIBUTES);
				return Plugin_Changed;
			}
		}
		
		case 7:
		{			
			if (HatIndex[2] != -1 && flParticles[slot] != 0.0)
			{
				hItem = OnGive(hItem, HatIndex[2], flParticles[slot], OVERRIDE_ITEM_DEF|OVERRIDE_ATTRIBUTES|PRESERVE_ATTRIBUTES);
				return Plugin_Changed;				
			}
			
			if (HatIndex[2] != -1)
			{
				hItem = OnGive(hItem, HatIndex[2], _, OVERRIDE_ITEM_DEF|PRESERVE_ATTRIBUTES);
				return Plugin_Changed;
			}
			
			if (flParticles[slot] != 0.0)
			{
				hItem = OnGive(hItem, _, flParticles[slot], OVERRIDE_ATTRIBUTES|PRESERVE_ATTRIBUTES);
				return Plugin_Changed;
			}
		}
	}
	
	return Plugin_Continue;
}

public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	CreateNative("TF2Items_GiveWearable", Native_GiveWearable);
	CreateNative("TF2Items_AttachEffect", Native_AttachEffect);
	CreateNative("TF2Items_MakeAustralium", Native_MakeAustralium);
	CreateNative("TF2Items_SetKillstreakTier", Native_SetKillstreakTier);
	CreateNative("TF2Items_SetKillstreakSheen", Native_SetKillstreakSheen);
	CreateNative("TF2_ForceGive", Native_ForceGive);
	CreateNative("TF2_RemoveAllWearables", Native_RemoveAllWearables);
	RegPluginLibrary("tf2items_wearables");
	return APLRes_Success;
}

public Native_GiveWearable(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	if (!(IsValidClient(client) || IsPlayerAlive(client)))
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Items] Invalid/dead target (%d) at the moment", client);
	}
	new index = GetNativeCell(2);
	new slot = GetNativeCell(3);
	
	if (slot >= 0 && slot <= 2)
	{
		new String:strIndex[65];
		IntToString(index, strIndex, sizeof(strIndex));
		SetClientCookie(client, g_hClientHats[slot], strIndex);
	}
	else
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Items] Invalid Item Slot (%d)", slot);
	}
	
	TF2_ForceGive(client);
}

public Native_AttachEffect(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	if (!(IsValidClient(client) || IsPlayerAlive(client)))
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Items] Invalid/dead target (%d) at the moment", client);
	}
	new slot = GetNativeCell(2);
	new Float:flEffect = GetNativeCell(3);
	
	if (slot >= 0 && slot <= 7)
	{
		new String:strEffect[65];
		FloatToString(flEffect, strEffect, sizeof(strEffect));
		SetClientCookie(client, g_hClientParticles[slot], strEffect);
	}
	else
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Items] Invalid Item Slot (%d)", slot);
	}
	
	TF2_ForceGive(client);
}

public Native_MakeAustralium(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	if (!(IsValidClient(client) || IsPlayerAlive(client)))
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Items] Invalid/dead target (%d) at the moment", client);
	}
	new slot = GetNativeCell(2);
	new bool:australium = bool:GetNativeCell(3);
	
	if (slot >= 0 && slot <= 4)
	{
		if (australium)
		{
			SetClientCookie(client, g_hClientAustralium[slot], "1.0");
		}
		else
		{
			SetClientCookie(client, g_hClientAustralium[slot], "0.0");
		}
	}
	else
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Items] Invalid Item Slot (%d)", slot);
	}
	
	TF2_ForceGive(client);
}

public Native_SetKillstreakTier(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	if (!(IsValidClient(client) || IsPlayerAlive(client)))
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Items] Invalid/dead target (%d) at the moment", client);
	}
	
	new slot = GetNativeCell(2);
	new tier = GetNativeCell(3);
	
	if (tier >= 0 && tier <= 3)
	{
		new String:strTier[65];
		IntToString(tier, strTier, sizeof(strTier));
		
		if (slot >= 0 && slot <= 4)
		{
			SetClientCookie(client, g_hClientKillstreakTier[slot], strTier);
		}
		else
		{
			ThrowNativeError(SP_ERROR_NATIVE, "[TF2Items] Invalid Item Slot (%d)", slot);
		}
	}
	else
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Items] Invalid Killstreak Tier (%d)", tier);
	}
	
	TF2_ForceGive(client);
}

public Native_SetKillstreakSheen(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	if (!(IsValidClient(client) || IsPlayerAlive(client)))
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Items] Invalid/dead target (%d) at the moment", client);
	}
	
	new slot = GetNativeCell(2);
	new sheen = GetNativeCell(3);
	
	if (sheen >= 1 && sheen <= 7)
	{
		new String:strSheen[65];
		IntToString(sheen, strSheen, sizeof(strSheen));
		
		if (slot >= 0 && slot <= 4)
		{
			SetClientCookie(client, g_hClientKillstreakSheen[slot], strSheen);
		}
		else
		{
			ThrowNativeError(SP_ERROR_NATIVE, "[TF2Items] Invalid Item Slot (%d)", slot);
		}
	}
	else
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Items] Invalid Killstreak Sheen (%d)", sheen);
	}
	
	TF2_ForceGive(client);
}

public Native_ForceGive(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	if (!(IsValidClient(client) || IsPlayerAlive(client)))
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Items] Invalid/dead target (%d) at the moment", client);
	}
	
	TF2_ForceGive(client);
}

public Native_RemoveAllWearables(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	if (!(IsValidClient(client) || IsPlayerAlive(client)))
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Items] Invalid/dead target (%d) at the moment", client);
	}
	
	TF2_RemoveAllWearables(client);
}

stock TF2_ForceGive(client)
{
	if (IsValidClient(client) && IsPlayerAlive(client))
	{
		g_iHealth[client] = GetEntProp(client, Prop_Data, "m_iHealth");
		TF2_RemoveAllWeapons(client);
		TF2_RemoveAllWearables(client);
		
		TF2_RegeneratePlayer(client);
		CreateTimer(0.2, Timer_Regenerate, any:client);
	}
}

public Action:Timer_Regenerate(Handle:timer, any:client)
{
	if (IsValidClient(client) && IsPlayerAlive(client))
	{
		TF2_RegeneratePlayer(client);
		if (g_iHealth[client] != -1)
		{
			SetEntProp(client, Prop_Data, "m_iHealth", g_iHealth[client]);
		}
	}
}

stock TF2_RemoveAllWearables(client)
{
	RemoveWearable(client, "tf_wearable", "CTFWearable");
	RemoveWearable(client, "tf_powerup_bottle", "CTFPowerupBottle");
}

stock RemoveWearable(client, String:classname[], String:networkclass[])
{
	if (IsValidClient(client) && IsPlayerAlive(client))
	{
		new edict = MaxClients+1;
		while((edict = FindEntityByClassname2(edict, classname)) != -1)
		{
			decl String:netclass[32];
			if (GetEntityNetClass(edict, netclass, sizeof(netclass)) && StrEqual(netclass, networkclass))
			{
				if (GetEntPropEnt(edict, Prop_Send, "m_hOwnerEntity") == client)
				{
					AcceptEntityInput(edict, "Kill"); 
				}
			}
		}
	}
}

stock bool:IsValidClient(client)
{
	if (client <= 0) return false;
	if (client > MaxClients) return false;
	return IsClientInGame(client);
}

stock FindEntityByClassname2(startEnt, const String:classname[])
{
	/* If startEnt isn't valid shifting it back to the nearest valid one */
	while (startEnt > -1 && !IsValidEntity(startEnt)) startEnt--;
	return FindEntityByClassname(startEnt, classname);
}

stock ReloadUnusualCFG()
{
	new Handle:kvUnusualCFG = CreateKeyValues("tf2items_unusuals");
	new String:strLocation[256];
	
	// Load the key files.
	BuildPath(Path_SM, strLocation, sizeof(strLocation), "configs/tf2wearables/unusuals.cfg");
	FileToKeyValues(kvUnusualCFG, strLocation);
	
	// Check if the parsed values are correct
	if (!KvGotoFirstSubKey(kvUnusualCFG)) 
	{
		SetFailState("Error, can't read file containing the unusuals list: %s", strLocation);
		return;
	}
	
	new i = 0;
	do
	{
		KvGetSectionName(kvUnusualCFG, strUnusualName[i], 256);
		KvGetString(kvUnusualCFG, "Value", strUnusualEffect[i], 256);
		i++;
	}
	while (KvGotoNextKey(kvUnusualCFG));
	
	UnusualCount = i;
	CloseHandle(kvUnusualCFG);
}

stock ReloadUnusualTauntCFG()
{
	new Handle:kvUnusualTauntCFG = CreateKeyValues("tf2items_unusual_taunts");
	new String:strLocation[256];
	
	// Load the key files.
	BuildPath(Path_SM, strLocation, sizeof(strLocation), "configs/tf2wearables/unusual_taunts.cfg");
	FileToKeyValues(kvUnusualTauntCFG, strLocation);
	
	// Check if the parsed values are correct
	if (!KvGotoFirstSubKey(kvUnusualTauntCFG)) 
	{
		SetFailState("Error, can't read file containing the unusual taunts list: %s", strLocation);
		return;
	}
	
	new i = 0;
	do
	{
		KvGetSectionName(kvUnusualTauntCFG, strUnusualTauntName[i], 256);
		KvGetString(kvUnusualTauntCFG, "Value", strUnusualTauntEffect[i], 256);
		i++;
	}
	while (KvGotoNextKey(kvUnusualTauntCFG));
	
	UnusualTauntCount = i;
	CloseHandle(kvUnusualTauntCFG);
}

stock Handle:OnGive(Handle:hItem, index = -1, Float:flParticle = 0.0, flags)
{
	hItem = TF2Items_CreateItem(flags);
	
	if (index != -1)
	{
		TF2Items_SetItemIndex(hItem, index);
	}
	
	if (flParticle != 0.0)
	{
		TF2Items_SetNumAttributes(hItem, 1);
		TF2Items_SetAttribute(hItem, 0, 134, flParticle);
	}
	
	TF2Items_SetFlags(hItem, flags);
	return hItem;
}
