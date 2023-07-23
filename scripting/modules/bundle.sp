StringMap Bundle_Session() {
    StringMap bundle = new StringMap();

    bundle.SetValue(KEY_PLAYER_ADDRESS_ID, ID_NOT_FOUND);
    bundle.SetValue(KEY_PLAYER_AUTH_ID, ID_NOT_FOUND);
    bundle.SetValue(KEY_PLAYER_NAME_ID, ID_NOT_FOUND);
    bundle.SetValue(KEY_CONNECTED_ON, GetTime());
    bundle.SetValue(KEY_DISCONNECTED_ON, TIME_NOT_FOUND);

    return bundle;
}

StringMap Bundle_PlayerAddress(int client) {
    char ip[IP_SIZE];

    GetClientIP(client, ip, sizeof(ip));

    StringMap bundle = new StringMap();
    int clientId = GetClientUserId(client);

    bundle.SetValue(KEY_CLIENT_ID, clientId);
    bundle.SetString(KEY_PLAYER_IP, ip);

    return bundle;
}

StringMap Bundle_PlayerAuth(int client) {
    char steam[MAX_AUTHID_LENGTH];

    GetClientAuthId(client, AuthId_Steam3, steam, sizeof(steam));

    StringMap bundle = new StringMap();
    int clientId = GetClientUserId(client);

    bundle.SetValue(KEY_CLIENT_ID, clientId);
    bundle.SetString(KEY_PLAYER_STEAM, steam);

    return bundle;
}
