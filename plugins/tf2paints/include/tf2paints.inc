#pragma semicolon 1
#include <tf2_stocks>
#include <tf2itemsinfo>

#define REMOVE_PAINT	"255-255-255-255"
#define HATSLOT			6
#define MISCSLOT		7
#define ACTIONSLOT		8

/**
 * Paints client.
 *
 * @param iClient			Client Index. Does an in-game/valid check.
 * @param r					Amount of red	(0-255)
 * @param g					Amount of green	(0-255)
 * @param b					Amount of blue	(0-255)
 * @param a					Amount of alpha	(0-255)
 * @noreturn
 */
stock PaintPlayer(iClient, r, g, b, a)
{
	if (IsValidClient(iClient))
	{
		SetEntityRenderMode(iClient, RENDER_TRANSCOLOR);
		SetEntityRenderColor(iClient, r, g, b, a);
	}
}

/**
 * Paints client.
 *
 * @param iClient			Client Index. Does an in-game/valid check.
 * @param strRGB			Color RGB Format: "red-green-blue-alpha" or "r-g-b-a"
 * @noreturn
 */
stock PaintPlayer2(iClient, const String:strRGB[])
{
	new r, g, b, a;
	new String:PaintRGBArray[32][32];
	ExplodeString(strRGB, "-", PaintRGBArray, 32, 32);
	r = StringToInt(PaintRGBArray[0]);
	g = StringToInt(PaintRGBArray[1]);
	b = StringToInt(PaintRGBArray[2]);
	a = StringToInt(PaintRGBArray[3]);
	PaintPlayer(iClient, r, g, b, a);
}

/**
 * Paints client's weapon in slot.
 *
 * @param iClient			Client Index. Does an in-game/valid check.
 * @param iWepSlot			Weapon Slot: 0, 1, 2, 3, 4, or 5
 * @param r					Amount of red	(0-255)
 * @param g					Amount of green	(0-255)
 * @param b					Amount of blue	(0-255)
 * @param a					Amount of alpha	(0-255)
 * @noreturn
 */
stock PaintWep(iClient, iWepSlot, r, g, b, a)
{
	if (IsValidClient(iClient))
	{
		new entity = GetPlayerWeaponSlot(iClient, iWepSlot);
		if (IsValidEntity(entity))
		{
			SetEntityRenderMode(entity, RENDER_TRANSCOLOR);
			SetEntityRenderColor(entity, r, g, b, a);
		}
	}
}

/**
 * Paints client's weapon in slot.
 *
 * @param iClient			Client Index. Does an in-game/valid check.
 * @param iWepSlot			Weapon Slot: 0, 1, 2, 3, 4, or 5
 * @param strRGB			Color RGB Format: "red-green-blue-alpha" or "r-g-b-a"
 * @noreturn
 */
stock PaintWep2(iClient, iWepSlot, const String:strRGB[])
{
	new r, g, b, a;
	new String:PaintRGBArray[32][32];
	ExplodeString(strRGB, "-", PaintRGBArray, 32, 32);
	r = StringToInt(PaintRGBArray[0]);
	g = StringToInt(PaintRGBArray[1]);
	b = StringToInt(PaintRGBArray[2]);
	a = StringToInt(PaintRGBArray[3]);
	PaintWep(iClient, iWepSlot, r, g, b, a);
}

/**
 * Paints client's hat in slot.
 *
 * @param iClient			Client Index. Does an in-game/valid check.
 * @param iHatSlot			Hat Slot: HATSLOT, MISCSLOT, or ACTIONSLOT
 * @param iItemIndex		Index position of item, -1 to paint all items found.
 * @param r					Amount of red	(0-255)
 * @param g					Amount of green	(0-255)
 * @param b					Amount of blue	(0-255)
 * @param a					Amount of alpha	(0-255)
 * @noreturn
 */
stock PaintHat(iClient, iHatSlot, iItemIndex = -1, r, g, b, a)
{
	if (IsValidClient(iClient))
	{
		new hat_entities[256], misc_entities[256], action_entities[256];
		
		switch (iHatSlot)
		{
			case HATSLOT:
			{
				hat_entities = FindWearable(iClient, iHatSlot, "tf_wearable", "CTFWearable");
			}
			
			case MISCSLOT:
			{
				misc_entities = FindWearable(iClient, iHatSlot, "tf_wearable", "CTFWearable");
			}
			
			case ACTIONSLOT:
			{
				action_entities = FindWearable(iClient, iHatSlot, "tf_powerup_bottle", "CTFPowerupBottle");
			}
		}
		
		if (iItemIndex == -1)
		{
			PaintAllItemsInArray(hat_entities, r, g, b, a);
			PaintAllItemsInArray(misc_entities, r, g, b, a);
			PaintAllItemsInArray(action_entities, r, g, b, a);
		}
		else
		{
			if (IsValidEntity(hat_entities[iItemIndex]))
			{
				SetEntityRenderMode(hat_entities[iItemIndex], RENDER_TRANSCOLOR);
				SetEntityRenderColor(hat_entities[iItemIndex], r, g, b, a);
			}
			
			if (IsValidEntity(misc_entities[iItemIndex]))
			{
				SetEntityRenderMode(misc_entities[iItemIndex], RENDER_TRANSCOLOR);
				SetEntityRenderColor(misc_entities[iItemIndex], r, g, b, a);
			}
			
			if (IsValidEntity(action_entities[iItemIndex]))
			{
				SetEntityRenderMode(action_entities[iItemIndex], RENDER_TRANSCOLOR);
				SetEntityRenderColor(action_entities[iItemIndex], r, g, b, a);
			}
		}
	}
}

/**
 * Paints client's hat in slot.
 *
 * @param iClient			Client Index. Does an in-game/valid check.
 * @param iHatSlot			Hat Slot: HATSLOT, MISCSLOT, or ACTIONSLOT
 * @param iItemIndex		Index position of item, -1 to paint all items found.
 * @param strRGB			Color RGB Format: "red-green-blue-alpha" or "r-g-b-a"
 * @noreturn
 */
stock PaintHat2(iClient, iHatSlot, iItemIndex = -1, const String:strRGB[])
{
	new r, g, b, a;
	new String:HatRGBArray[32][32];
	ExplodeString(strRGB, "-", HatRGBArray, 32, 32);
	r = StringToInt(HatRGBArray[0]);
	g = StringToInt(HatRGBArray[1]);
	b = StringToInt(HatRGBArray[2]);
	a = StringToInt(HatRGBArray[3]);
	PaintHat(iClient, iHatSlot, iItemIndex, r, g, b, a);
}

/**
 * Paints all items in array.
 *
 * @param iItemEntities		Array of items to paint.
 * @param r					Amount of red	(0-255)
 * @param g					Amount of green	(0-255)
 * @param b					Amount of blue	(0-255)
 * @param a					Amount of alpha	(0-255)
 * @noreturn
 */
stock PaintAllItemsInArray(iItemEntities[], r, g, b, a)
{
	for (new i = 0; i < sizeof(iItemEntities[]); i++)
	{
		if (IsValidEntity(iItemEntities[i]))
		{
			SetEntityRenderMode(iItemEntities[i], RENDER_TRANSCOLOR);
			SetEntityRenderColor(iItemEntities[i], r, g, b, a);
		}
	}
}

/**
 * Gets entities of client's items in slot.
 *
 * @param iClient			Client Index. Does an in-game/valid check.
 * @param iSlot				Item Slot: HATSLOT, MISCSLOT, or ACTIONSLOT
 * @param classname			String item classname
 * @param networkclass		String item netclass
 * @return					Array with item entities or -1 on failure
 */
stock FindWearable(iClient, iSlot, String:classname[], String:networkclass[])
{
	if (!IsValidClient(iClient))
	{
		new error[256];
		for (new i = 0; i < sizeof(error); i++)
		{
			error[i] = -1;
		}
		return error;
	}
	
	new items[256];
	new i = 0;
	new edict = MaxClients+1;
	while((edict = FindEntityByClassname2(edict, classname)) != -1)
	{
		decl String:netclass[32];
		if (GetEntityNetClass(edict, netclass, sizeof(netclass)) && StrEqual(netclass, networkclass))
		{
			if (GetEntPropEnt(edict, Prop_Send, "m_hOwnerEntity") == iClient)
			{
				new index = GetEntProp(edict, Prop_Send, "m_iItemDefinitionIndex");
				new TFClassType:class = TF2_GetPlayerClass(iClient);
				new TF2ItemSlot:item_slot = TF2II_GetItemSlot(index, class);
				
				switch (item_slot)
				{
					case 5:
					{
						if (iSlot == HATSLOT)
						{
							if (i < 256)
							{
								items[i] = edict;
							}
							i++;
						}
					}
					
					case 6:
					{
						if (iSlot == MISCSLOT)
						{
							if (i < 256)
							{
								items[i] = edict;
							}
							i++;
						}
					}
					
					case 7:
					{
						if (iSlot == ACTIONSLOT)
						{
							if (i < 256)
							{
								items[i] = edict;
							}
							i++;
						}
					}
				}
			}
		}
	}
	
	return items;
}

/**
 * Finds a valid entity by classname
 *
 * @param startEnt			Starting entity
 * @param classname			String entity classname
 * @return					Next valid entity
 */
stock FindEntityByClassname2(startEnt, const String:classname[])
{
	/* If startEnt isn't valid shifting it back to the nearest valid one */
	while (startEnt > -1 && !IsValidEntity(startEnt)) startEnt--;
	return FindEntityByClassname(startEnt, classname);
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


/**
 * Paints a client or client's item.
 *
 * @param iClient			Client Index. Does an alive/in-game/valid check.
 * @param iSlot				Item Slot to paint. Vaid slots are -1 Player, 0, 1, 2, 3, 4, or 5 - Weapon, 6 - Hat, 7 - Misc1, 8 - Misc2, 9 - Action
 * @param strRGB			Color RGB Format: "red-green-blue-alpha" or "r-g-b-a"
 * @noreturn
 */
native TF2Paints_Paint(iClient, iSlot, const String:strRGB[]);

public SharedPlugin:__pl_tf2paints = 
{
	name = "tf2paints",
	file = "tf2paints.smx",
#if defined REQUIRE_PLUGIN
	required = 1,
#else
	required = 0,
#endif
};

#if !defined REQUIRE_PLUGIN
public __pl_tf2paints_SetNTVOptional()
{
	MarkNativeAsOptional("TF2Paints_Paint");
}
#endif
