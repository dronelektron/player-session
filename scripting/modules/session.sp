static StringMap g_sessions[MAXPLAYERS + 1];

void Session_Create(int client) {
    StringMap bundle = Bundle_Session();

    g_sessions[client] = bundle;
}

void Session_Destroy(int client) {
    delete g_sessions[client];
}

void Session_SetPlayerAddressId(int client, int addressId) {
    g_sessions[client].SetValue(KEY_PLAYER_ADDRESS_ID, addressId);
}
