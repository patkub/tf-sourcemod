/**
 * Gives a client a wearable by item index.
 *
 * @param iClient			Client Index. Does an alive/in-game/valid check.
 * @param iIndex			Item Definition Index of wearable being given.
 * @param iSlot				Item Slot of wearable being given. Vaid slots are 0 for Hat Slot, 1 for Misc Slot, or 2 for Action Slot.
 * @noreturn
 */
native TF2Items_GiveWearable(iClient, iIndex, iSlot);

/**
 * Attaches an effect to a client's slot.
 *
 * @param iClient			Client Index. Does an alive/in-game/valid check.
 * @param iSlot				Item Slot effect is being attached to. Vaid slots are 0 for Primary, 1 for Secondary, 2 for Melee, 3 for PDA1, 4 for PDA2, 5 for Hat, 6 for Misc, or 7 for Action.
 * @param flValue			Effect Value.
 * @noreturn
 */
native TF2Items_AttachEffect(iClient, iSlot, Float:flValue);

/**
 * Makes the weapon in a client's slot Australium.
 *
 * @param iClient			Client Index. Does an alive/in-game/valid check.
 * @param iSlot				Item Slot to make australium. Vaid slots are 0 for Primary, 1 for Secondary, 2 for Melee, 3 for PDA1, or 4 for PDA2.
 * @param bAustralium		True to make australium, false to not.
 * @noreturn
 */
native TF2Items_MakeAustralium(iClient, iSlot, bool:bAustralium);

/**
 * Sets the killstreak tier of a weapon.
 *
 * @param iClient			Client Index. Does an alive/in-game/valid check.
 * @param iSlot				Item Slot to make australium. Vaid slots are 0 for Primary, 1 for Secondary, 2 for Melee, 3 for PDA1, or 4 for PDA2.
 * @param iTier				Killstreak tier. Valid tiers are 0 for None, 1 for Normal, 2 for Specialized, or 3 for Professional.
 * @noreturn
 */
native TF2Items_SetKillstreakTier(iClient, iSlot, iTier);

/**
 * Sets the killstreak sheen of a weapon.
 *
 * @param iClient			Client Index. Does an alive/in-game/valid check.
 * @param iSlot				Item Slot to make australium. Vaid slots are 0 for Primary, 1 for Secondary, 2 for Melee, 3 for PDA1, or 4 for PDA2.
 * @param iSheen			Killstreak Sheen. Valid sheens are 1 for Team Shine, 2 for Deadly Daffodil, 3 for Manndarin, 4 for Mean Green, 5 for Agonizing Emerald, 6 for Villainous Violet, or 7 for Hot Rod.
 * @noreturn
 */
native TF2Items_SetKillstreakSheen(iClient, iSlot, iSheen);

/**
 * Forces all items to be re-given to a client
 *
 * @param iClient			Client Index. Does an alive/in-game/valid check.
 * @noreturn
 */
native TF2_ForceGive(iClient);

/**
 * Removes all wearables from a client.
 *
 * @param iClient			Client Index. Does an alive/in-game/valid check.
 * @noreturn
 */
native TF2_RemoveAllWearables(iClient);

public SharedPlugin:__pl_tf2items_wearables = 
{
	name = "tf2items_wearables",
	file = "tf2items_wearables.smx",
#if defined REQUIRE_PLUGIN
	required = 1,
#else
	required = 0,
#endif
};

#if !defined REQUIRE_PLUGIN
public __pl_tf2items_wearables_SetNTVOptional()
{
	MarkNativeAsOptional("TF2Items_GiveWearable");
	MarkNativeAsOptional("TF2Items_AttachEffect");
	MarkNativeAsOptional("TF2Items_MakeAustralium");
	MarkNativeAsOptional("TF2Items_SetKillstreakTier");
	MarkNativeAsOptional("TF2Items_SetKillstreakSheen");
	MarkNativeAsOptional("TF2_ForceGive");
	MarkNativeAsOptional("TF2_RemoveAllWearables");
}
#endif

/**
* I'll just leave this here...
* 
* _(º< _(º< _(º< _(º< _(º< _(º< _(º< _(º< _(º< 
* \__) \__) \__) \__) \__) \__) \__) \__) \__) 
*                     .  .
*                    // //  __
*         __  ______||_//_.´.´
*       _/__`´            ¯ `
*      /  / _          _     \
*     /  /( · )      ( · )    |
*    /  |   ¯     __   ¯    _/\/|
*   |    \  ___.-´  `-.___  \   /
*    \    \(     ` ´      `)|   \
*     \     )              //     \
*      \/  /              | |     |
*     /   /               | |     |
*    ·   |                |  \___/
*    |    \_            _/      \  ____
*    ·      `----------´         |´    \
*     \                         /    _·´
*      \                       /  _-´ 
*        `-._               _·´-´
*        _.-´`---________--´ \ 
*       ´-.-. _--·   / .   ._ \
*            ´       `´ `·´  `´
* >º)_ >º)_ >º)_ >º)_ >º)_ >º)_ >º)_ >º)_ >º)_ 
* (__/ (__/ (__/ (__/ (__/ (__/ (__/ (__/ (__/ 
* 
*/
