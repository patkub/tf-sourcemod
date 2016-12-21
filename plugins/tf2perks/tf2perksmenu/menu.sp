public ShowPerksMenu(client)
{
	new Handle:menu = CreateMenu(hMainMenu);
	SetMenuTitle(menu, "TF2 Perks Menu:");
	
	#if defined ENABLE_REGEN
	AddMenuItem(menu, "1", "Regenerate");
	#endif
	
	#if defined ENABLE_GODMODE
	AddMenuItem(menu, "2", "Godmode");
	#endif
	
	#if defined ENABLE_BUDDHA
	AddMenuItem(menu, "3", "Buddha");
	#endif
	
	#if defined ENABLE_NOCLIP
	AddMenuItem(menu, "4", "Noclip");
	#endif
	
	#if defined ENABLE_POWERPLAY
	AddMenuItem(menu, "5", "PowerPlay");
	#endif
	
	#if defined ENABLE_THIRDPERSON
	AddMenuItem(menu, "6", "Third Person");
	#endif
	
	#if defined ENABLE_AMMO
	AddMenuItem(menu, "7", "Infinite Ammo");
	#endif
	
	#if defined ENABLE_TELEPORT
	AddMenuItem(menu, "8", "Save Location");
	AddMenuItem(menu, "9", "Teleport To Saved Location");
	#endif
	
	DisplayMenu(menu, client, MENU_TIME_FOREVER);
}

public hMainMenu(Handle:menu, MenuAction:action, client, param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			decl String:choice[64];
			GetMenuItem(menu, param2, choice, sizeof(choice));
			new item = StringToInt(choice);
			switch (item)
			{
				#if defined ENABLE_REGEN
				case 1:
				{
					TF2_RegeneratePlayer(client);
					CPrintToChat(client, "[{green}TF2Perks{default}] You Have Been Regenerated");
					ShowPerksMenu(client);
				}
				#endif
				
				#if defined ENABLE_GODMODE
				case 2:
				{
					TF2Perks_TogglePerk(client, "godmode");
					ShowPerksMenu(client);
				}
				#endif
				
				#if defined ENABLE_BUDDHA
				case 3:
				{
					TF2Perks_TogglePerk(client, "buddha");
					ShowPerksMenu(client);
				}
				#endif
				
				#if defined ENABLE_NOCLIP
				case 4:
				{
					TF2Perks_TogglePerk(client, "noclip");
					ShowPerksMenu(client);
				}
				#endif
				
				#if defined ENABLE_POWERPLAY
				case 5:
				{
					TF2Perks_TogglePerk(client, "powerplay");
					ShowPerksMenu(client);
				}
				#endif
				
				#if defined ENABLE_THIRDPERSON
				case 6:
				{
					TF2Perks_TogglePerk(client, "thirdperson");
					ShowPerksMenu(client);
				}
				#endif
				
				#if defined ENABLE_AMMO
				case 7:
				{
					TF2Perks_ToggleAmmo(client);
					ShowPerksMenu(client);
				}
				#endif
				
				#if defined ENABLE_TELEPORT
				case 8:
				{
					TF2Perks_SaveLocation(client);
					ShowPerksMenu(client);
				}
				
				case 9:
				{
					TF2Perks_TeleportToSavedLocation(client);
					ShowPerksMenu(client);
				}
				#endif
			}
		}
		
		case MenuAction_End:
		{
			CloseHandle(menu);
		}
	}
}
