/**
 * A bunch of natives for tf2 perks.
 * Features:
 * 1)	Godmode
 * 2)	Buddha
 * 3)	Noclip
 * 4)	PowerPlay
 * 5)	Third Person
 * 6)	Ammo
 * 7)	Health
 * 8)	Teleport
 * 9)	Rate of Fire (ROF)
 * 10)	Size
 */

/**
 * Enables a perk for a client.
 *
 * @param iClient			Client Index. Does an in-game/valid check.
 * @param strPerk			Perk: "godmode", "buddha", "noclip", "powerplay", or "thirdperson"
 * @noreturn
 */
native TF2Perks_EnablePerk(iClient, const String:strPerk[]);

/**
 * Disables a perk for a client.
 *
 * @param iClient			Client Index. Does an in-game/valid check.
 * @param strPerk			Perk: "godmode", "buddha", "noclip", "powerplay", or "thirdperson"
 * @noreturn
 */
native TF2Perks_DisablePerk(iClient, const String:strPerk[]);

/**
 * Checks if perk is enabled for a client.
 *
 * @param iClient			Client Index. Does an in-game/valid check.
 * @param strPerk			Perk: "godmode", "buddha", "noclip", "powerplay", or "thirdperson"
 * @return					True if perk is enabled, false otherwise.
 */
native TF2Perks_IsPerkOn(iClient, const String:strPerk[]);

/**
 * Checks if perk is disabled for a client.
 *
 * @param iClient			Client Index. Does an in-game/valid check.
 * @param strPerk			Perk: "godmode", "buddha", "noclip", "powerplay", or "thirdperson"
 * @return					True if perk is disabled, false otherwise.
 */
native TF2Perks_IsPerkOff(iClient, const String:strPerk[]);

/**
 * Toggles a perk for a client.
 *
 * @param iClient			Client Index. Does an in-game/valid check.
 * @param strPerk			Perk: "godmode", "buddha", "noclip", "powerplay", or "thirdperson"
 * @noreturn
 */
native TF2Perks_TogglePerk(iClient, const String:strPerk[]);

/**
 * Checks if perk was enabled in current life for a client.
 *
 * @param iClient			Client Index. Does an in-game/valid check.
 * @param strPerk			Perk: "godmode", "buddha", "noclip", "powerplay", or "thirdperson".
 * @return					True if perk was enabled, false if not, or 0 if an error occured.
 */
native TF2Perks_WasEnabled(iClient, const String:strPerk[]);


/**
 * Enables infinite ammo for a client.
 *
 * @param iClient			Client Index. Does an in-game/valid check.
 * @noreturn
 */
native TF2Perks_EnableAmmo(iClient);

/**
 * Disables infinite ammo for a client.
 *
 * @param iClient			Client Index. Does an in-game/valid check.
 * @noreturn
 */
native TF2Perks_DisableAmmo(iClient);

/**
 * Toggles infinite ammo for a client.
 *
 * @param iClient			Client Index. Does an in-game/valid check.
 * @noreturn
 */
native TF2Perks_ToggleAmmo(iClient);

/**
 * Get ammo of client's weapon.
 *
 * @param iClient			Client Index. Does an in-game/valid check.
 * @param iWeapon			Weapon entity.
 * @return					Integer ammo of weapon.
 */
native TF2Perks_GetAmmo(iClient, iWeapon);

/**
 * Set ammo of client's weapon.
 *
 * @param iClient			Client Index. Does an in-game/valid check.
 * @param iWeapon			Weapon entity.
 * @param iNewAmmo			Integer amount to set.
 * @noreturn
 */
native TF2Perks_SetAmmo(iClient, iWeapon, iNewAmmo);

/**
 * Get clip of client's weapon.
 *
 * @param iClient			Client Index. Does an in-game/valid check.
 * @param iWeapon			Weapon entity.
 * @return					Integer clip of weapon.
 */
native TF2Perks_GetClip(iClient, iWeapon);

/**
 * Set clip of client's weapon.
 *
 * @param iClient			Client Index. Does an in-game/valid check.
 * @param iWeapon			Weapon entity.
 * @param iNewClip			Integer amount to set.
 * @noreturn
 */
native TF2Perks_SetClip(iClient, iWeapon, iNewClip);

/**
 * Get client's metal.
 *
 * @param iClient			Client Index. Does an in-game/valid check.
 * @return					Integer metal of client.
 */
native TF2Perks_GetMetal(iClient);

/**
 * Set client's metal.
 *
 * @param iClient			Client Index. Does an in-game/valid check.
 * @param iNewMetal			Integer amount to set.
 * @noreturn
 */
native TF2Perks_SetMetal(iClient, iNewMetal);

/**
 * Get client's drink meter.
 *
 * @param iClient			Client Index. Does an in-game/valid check.
 * @return					Float drink meter of client.
 */
native Float:TF2Perks_GetDrinkMeter(iClient);

/**
 * Set client's drink meter.
 *
 * @param iClient			Client Index. Does an in-game/valid check.
 * @param flNewDrink		Float amount to set.
 * @noreturn
 */
native TF2Perks_SetDrinkMeter(iClient, Float:flNewDrink);

/**
 * Get client's hype meter.
 *
 * @param iClient			Client Index. Does an in-game/valid check.
 * @return					Float hype meter of client.
 */
native Float:TF2Perks_GetHypeMeter(iClient);

/**
 * Set client's hype meter.
 *
 * @param iClient			Client Index. Does an in-game/valid check.
 * @param flNewHype			Float amount to set.
 * @noreturn
 */
native TF2Perks_SetHypeMeter(iClient, Float:flNewHype);

/**
 * Get client's rage meter.
 *
 * @param iClient			Client Index. Does an in-game/valid check.
 * @return					Float rage meter of client.
 */
native Float:TF2Perks_GetRageMeter(iClient);

/**
 * Set client's rage meter.
 *
 * @param iClient			Client Index. Does an in-game/valid check.
 * @param flNewRage			Float amount to set.
 * @noreturn
 */
native TF2Perks_SetRageMeter(iClient, Float:flNewRage);

/**
 * Get client's charge meter.
 *
 * @param iClient			Client Index. Does an in-game/valid check.
 * @return					Float charge meter of client.
 */
native Float:TF2Perks_GetChargeMeter(iClient);

/**
 * Set client's charge meter.
 *
 * @param iClient			Client Index. Does an in-game/valid check.
 * @param flNewCharge		Float amount to set.
 * @noreturn
 */
native TF2Perks_SetChargeMeter(iClient, Float:flNewCharge);

/**
 * Get uber charge of client's weapon.
 *
 * @param iWeapon			Client's weapon entity. Does an entity valid check.
 * @return					Float uber charge of client.
 */
native Float:TF2Perks_GetUberCharge(iWeapon);

/**
 * Set uber charge of client's weapon.
 *
 * @param iWeapon			Client's weapon entity. Does an entity valid check.
 * @param flNewUberCharge	Float amount to set.
 * @noreturn
 */
native TF2Perks_SetUberCharge(iWeapon, Float:flNewUberCharge);

/**
 * Get client's cloak meter.
 *
 * @param iClient			Client Index. Does an in-game/valid check.
 * @return					Float charge meter of client.
 */
native Float:TF2Perks_GetCloakMeter(iClient);

/**
 * Set client's cloak meter.
 *
 * @param iClient			Client Index. Does an in-game/valid check.
 * @param flNewCloakTime	Float amount to set.
 * @noreturn
 */
native TF2Perks_SetCloakMeter(iClient, Float:flNewCloakTime);


/**
 * Get client's health.
 *
 * @param iClient			Client Index. Does an in-game/valid check.
 * @return					Integer health of client.
 */
native TF2Perks_GetHealth(iClient);

/**
 * Set client's health.
 *
 * @param iClient			Client Index. Does an in-game/valid check.
 * @param iHealth			Health to set
 * @noreturn
 */
native TF2Perks_SetHealth(iClient, iHealth);


/**
 * Teleport players.
 *
 * @param iPlayer1			Client Index. Does an in-game/valid check.
 * @param iPlayer2			Client Index. Does an in-game/valid check.
 * @param strMode			String type of teleport.
 *							"infront" 	- teleports iPlayer2 infront of iPlayer1
 *							"look" 		- teleports iPlayer2 where iPlayer1 is looking
 * @noreturn
 */
native TF2Perks_Teleport(iPlayer1, iPlayer2, String:strMode[]);

/**
 * Save location.
 *
 * @param iClient			Client Index. Does an in-game/valid/alive check.
 * @noreturn
 */
native TF2Perks_SaveLocation(iClient);

/**
 * Teleport to saved location.
 *
 * @param iClient			Client Index. Does an in-game/valid check.
 * @noreturn
 */
native TF2Perks_TeleportToSavedLocation(iClient);


/**
 * Set rate of fire on a client's currently equiped weapon.
 *
 * @param iClient			Client Index. Does an in-game/valid check.
 * @param flROFMulti		Float amount to multiply by.
 * @noreturn
 */
native TF2Perks_ModRateOfFire(iClient, Float:flROFMulti);

/**
 * Resizes a client by a scale.
 *
 * @param iClient			Client Index. Does an in-game/valid check.
 * @param flScale			Float scale to resize by.
 * @noreturn
 */
native TF2Perks_ResizePlayer(iClient, Float:flScale);


public SharedPlugin:__pl_tf2perks = 
{
	name = "tf2perks",
	file = "tf2perks.smx",
#if defined REQUIRE_PLUGIN
	required = 1,
#else
	required = 0,
#endif
};

#if !defined REQUIRE_PLUGIN
public __pl_tf2perks_SetNTVOptional()
{
	MarkNativeAsOptional("TF2Perks_EnablePerk");
	MarkNativeAsOptional("TF2Perks_DisablePerk");
	MarkNativeAsOptional("TF2Perks_IsPerkOn");
	MarkNativeAsOptional("TF2Perks_IsPerkOff");
	MarkNativeAsOptional("TF2Perks_TogglePerk");
	MarkNativeAsOptional("TF2Perks_WasEnabled");
	
	MarkNativeAsOptional("TF2Perks_EnableAmmo");
	MarkNativeAsOptional("TF2Perks_DisableAmmo");
	MarkNativeAsOptional("TF2Perks_ToggleAmmo");
	MarkNativeAsOptional("TF2Perks_GetAmmo");
	MarkNativeAsOptional("TF2Perks_SetAmmo");
	MarkNativeAsOptional("TF2Perks_GetClip");
	MarkNativeAsOptional("TF2Perks_SetClip");
	MarkNativeAsOptional("TF2Perks_GetMetal");
	MarkNativeAsOptional("TF2Perks_SetMetal");
	MarkNativeAsOptional("TF2Perks_GetDrinkMeter");
	MarkNativeAsOptional("TF2Perks_SetDrinkMeter");
	MarkNativeAsOptional("TF2Perks_GetHypeMeter");
	MarkNativeAsOptional("TF2Perks_SetHypeMeter");
	MarkNativeAsOptional("TF2Perks_GetRageMeter");
	MarkNativeAsOptional("TF2Perks_SetRageMeter");
	MarkNativeAsOptional("TF2Perks_GetChargeMeter");
	MarkNativeAsOptional("TF2Perks_SetChargeMeter");
	MarkNativeAsOptional("TF2Perks_GetUberCharge");
	MarkNativeAsOptional("TF2Perks_SetUberCharge");
	MarkNativeAsOptional("TF2Perks_GetCloakMeter");
	MarkNativeAsOptional("TF2Perks_SetCloakMeter");
	
	MarkNativeAsOptional("TF2Perks_GetHealth");
	MarkNativeAsOptional("TF2Perks_SetHealth");
	
	MarkNativeAsOptional("TF2Perks_Teleport");
	MarkNativeAsOptional("TF2Perks_SaveLocation");
	MarkNativeAsOptional("TF2Perks_TeleportToSavedLocation");
	
	MarkNativeAsOptional("TF2Perks_ModRateOfFire");
	MarkNativeAsOptional("TF2Perks_ResizePlayer");
}
#endif
