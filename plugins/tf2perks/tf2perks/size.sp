stock ResizePlayer(client, Float:Scale)
{
	SetEntPropFloat(client, Prop_Send, "m_flModelScale", Scale);
	SetEntPropFloat(client, Prop_Send, "m_flStepSize", 18.0 * Scale);
	CPrintToChat(client, "[{green}Perks{default}] Size Set To %f", Scale);
}
