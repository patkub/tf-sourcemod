stock GetHealth(client)
{
	return GetEntProp(client, Prop_Data, "m_iHealth");
}

stock SetHealth(client, health)
{
	SetEntProp(client, Prop_Data, "m_iHealth", health, 1);
}
