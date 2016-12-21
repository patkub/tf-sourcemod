#pragma semicolon 1
#include <sourcemod>
#include <clientprefs>
#include <morecolors>
#include <tf2paints>

#define PLUGIN_VERSION		"1.0"

#define MENU_PAINTS			(1 << 1)
#define MENU_PAINT_SLOTS	(1 << 2)

new String:PaintName[256][256];
new String:PaintRGB[256][256];
new PaintCount;

new g_iTempPaintIndex[MAXPLAYERS+1];
new String:g_strClientPaints[11][256];		//0 - Player, 1 - Primary, 2 - Secondary, 3 - Melee, 4 - PDA1, 5 - PDA2, 6 - PDA3, 7 - Hat, 8 - Misc, 9 - Misc2, 10 - Action

public Plugin:myinfo =
{
	name = "TF2 Paints",
	author = "Patka",
	description = "TF2 Paint Items.",
	version = PLUGIN_VERSION,
	url = "http://forums.alliedmods.net"
};

public OnPluginStart()
{
	LoadTranslations("common.phrases");
	CreateConVar("tf_paints_version", PLUGIN_VERSION, "TF2 Paints plugin version.", FCVAR_PLUGIN|FCVAR_NOTIFY|FCVAR_REPLICATED);
	HookEvent("post_inventory_application", Event_PostInventoryApplication);
	RegAdminCmd("sm_paints", Command_Paints, ADMFLAG_CUSTOM6, "Open Paints Menu.");
}

public OnClientPostAdminCheck(client)
{
	for (new i = 0; i < sizeof(g_strClientPaints); i++)
	{
		g_strClientPaints[i] = REMOVE_PAINT;
	}
}

public Action:Event_PostInventoryApplication(Handle:event, const String:name[], bool:dontBroadcast)
{
	decl i;
	new userid = GetEventInt(event, "userid");
	new client = GetClientOfUserId(userid);
	
	PaintPlayer2(client, g_strClientPaints[0]);
	for (i = 0; i < 5; i++)
	{
		PaintWep2(client, i, g_strClientPaints[i+1]);
	}
	
	PaintHat2(client, HATSLOT, _, g_strClientPaints[7]);
	PaintHat2(client, MISCSLOT, 0, g_strClientPaints[8]);
	PaintHat2(client, MISCSLOT, 1, g_strClientPaints[9]);
	PaintHat2(client, ACTIONSLOT, _, g_strClientPaints[10]);
	
	return Plugin_Continue;
}

public Action:Command_Paints(client, args)
{
	if (args != 0)
	{
		ReplyToCommand(client, "[SM] Usage: sm_paints");
		return Plugin_Handled;
	}
	
	ReloadPaintCFG();
	ShowPaintsMenu(client, MENU_PAINTS);	
	return Plugin_Handled;
}

public ShowPaintsMenu(client, menutype)
{
	decl i;
	decl String:index[256];
	decl Handle:menu;
	
	if (menutype & MENU_PAINTS)
	{
		menu = CreateMenu(hPaintsMenu);
		SetMenuTitle(menu, "TF2 Paints Menu:");
		AddMenuItem(menu, "-1", "Remove Paint");
		
		for (i = 0; i < PaintCount; i++)
		{
			IntToString(i, index, sizeof(index));
			AddMenuItem(menu, index, PaintName[i]);
		}
	}
	
	if (menutype & MENU_PAINT_SLOTS)
	{
		menu = CreateMenu(hPaintSlotsMenu);
		SetMenuExitBackButton(menu, true);
		SetMenuTitle(menu, "TF2 Paints Apply Paint To Slot:");
		AddMenuItem(menu, "-1", "Player");
		AddMenuItem(menu, "0", "Primary Weapon Slot");
		AddMenuItem(menu, "1", "Secondary Weapon Slot");
		AddMenuItem(menu, "2", "Melee Weapon Slot");
		AddMenuItem(menu, "3", "PDA 1 Slot");
		AddMenuItem(menu, "4", "PDA 2 Slot");
		AddMenuItem(menu, "5", "PDA 3 Slot");
		AddMenuItem(menu, "6", "Hat Slot");
		AddMenuItem(menu, "7", "Misc 1 Slot");
		AddMenuItem(menu, "8", "Misc 2 Slot");
		AddMenuItem(menu, "9", "Action Slot");
	}
	
	DisplayMenu(menu, client, MENU_TIME_FOREVER);
}

public hPaintsMenu(Handle:menu, MenuAction:action, client, param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			decl String:choice[64];
			GetMenuItem(menu, param2, choice, sizeof(choice));
			new index = StringToInt(choice);
			g_iTempPaintIndex[client] = index;
			ShowPaintsMenu(client, MENU_PAINT_SLOTS);
		}
		
		case MenuAction_End:
		{
			CloseHandle(menu);
		}
	}
}

public hPaintSlotsMenu(Handle:menu, MenuAction:action, client, param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			decl String:choice[64];
			GetMenuItem(menu, param2, choice, sizeof(choice));
			
			new index = g_iTempPaintIndex[client];
			new slot = StringToInt(choice);
			
			switch (slot)
			{
				//Paint Player
				case -1:
				{
					if (index == -1)
					{
						PaintPlayer2(client, REMOVE_PAINT);
						g_strClientPaints[0] = REMOVE_PAINT;
					}
					else
					{
						PaintPlayer2(client, PaintRGB[index]);
						g_strClientPaints[0] = PaintRGB[index];
					}
				}
				
				//Paint Weapon
				case 0, 1, 2, 3, 4, 5:
				{
					if (index == -1)
					{
						PaintWep2(client, slot, REMOVE_PAINT);
						g_strClientPaints[slot+1] = REMOVE_PAINT;
					}
					else
					{
						PaintWep2(client, slot, PaintRGB[index]);
						g_strClientPaints[slot+1] = PaintRGB[index];
					}
				}
				
				//Paint Hat or Action
				case 6, 9:
				{
					if (index == -1)
					{
						PaintHat2(client, slot, _, REMOVE_PAINT);
						g_strClientPaints[slot+1] = REMOVE_PAINT;
					}
					else
					{
						PaintHat2(client, slot, _, PaintRGB[index]);
						g_strClientPaints[slot+1] = PaintRGB[index];
					}
				}
				
				//Paint Misc
				case 7, 8:
				{
					if (index == -1)
					{
						PaintHat2(client, MISCSLOT, slot-7, REMOVE_PAINT);
						g_strClientPaints[slot+1] = REMOVE_PAINT;
					}
					else
					{
						PaintHat2(client, MISCSLOT, slot-7, PaintRGB[index]);
						g_strClientPaints[slot+1] = PaintRGB[index];
					}
				}
			}
			
			ShowPaintsMenu(client, MENU_PAINTS);
		}
		
		case MenuAction_Cancel:
		{
			if (param2 == MenuCancel_ExitBack)
			{
				ShowPaintsMenu(client, MENU_PAINTS);
			}
		}
		
		case MenuAction_End:
		{
			CloseHandle(menu);
		}
	}
}

public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	CreateNative("TF2Paints_Paint", Native_Paint);
	RegPluginLibrary("tf2paints");
	return APLRes_Success;
}

public Native_Paint(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	if (!(IsValidClient(client) || IsPlayerAlive(client)))
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[TF2Items] Invalid/dead target (%d) at the moment", client);
	}
	new slot = GetNativeCell(2);
	
	new String:strPaintRGB[256];
	GetNativeString(3, strPaintRGB, sizeof(strPaintRGB));
	
	switch (slot)
	{
		//Paint Player
		case -1:
		{
			PaintPlayer2(client, strPaintRGB);
			g_strClientPaints[0] = strPaintRGB;
		}
		
		//Paint Weapon
		case 0, 1, 2, 3, 4, 5:
		{
			PaintWep2(client, slot, strPaintRGB);
			g_strClientPaints[slot+1] = strPaintRGB;
		}
		
		//Paint Hat or Action
		case 6, 9:
		{
			PaintHat2(client, slot, _, strPaintRGB);
			g_strClientPaints[slot+1] = strPaintRGB;
		}
		
		//Paint Misc
		case 7, 8:
		{
			PaintHat2(client, MISCSLOT, slot-7, strPaintRGB);
			g_strClientPaints[slot+1] = strPaintRGB;
		}
	}
}

stock ReloadPaintCFG()
{
	new Handle:kvPaintCFG = CreateKeyValues("tf2paints");
	new String:strLocation[256];
	
	// Load the key files.
	BuildPath(Path_SM, strLocation, sizeof(strLocation), "configs/tf2paints.cfg");
	FileToKeyValues(kvPaintCFG, strLocation);
	
	// Check if the parsed values are correct
	if (!KvGotoFirstSubKey(kvPaintCFG)) 
	{
		SetFailState("Error, can't read file containing the paints list: %s", strLocation);
		return;
	}
	
	new i = 0;
	do
	{
		KvGetSectionName(kvPaintCFG, PaintName[i], 256);
		KvGetString(kvPaintCFG, "RGB", PaintRGB[i], 256);
		i++;
	}
	while (KvGotoNextKey(kvPaintCFG));
	
	PaintCount = i;
	CloseHandle(kvPaintCFG);
}
