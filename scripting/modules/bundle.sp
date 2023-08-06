StringMap Bundle_Session() {
    StringMap bundle = new StringMap();

    bundle.SetValue(KEY_PLAYER_ADDRESS_ID, NO_ROW_ID);
    bundle.SetValue(KEY_PLAYER_AUTH_ID, NO_ROW_ID);
    bundle.SetValue(KEY_PLAYER_NAME_ID, NO_ROW_ID);
    bundle.SetValue(KEY_CONNECTED_ON, TIME_NOT_SET);
    bundle.SetValue(KEY_DISCONNECTED_ON, TIME_NOT_SET);
    bundle.SetValue(KEY_COUNTER, 0);

    return bundle;
}

StringMap Bundle_PlayerAddress(int client) {
    char ip[IP_SIZE];

    GetClientIP(client, ip, sizeof(ip));

    StringMap bundle = new StringMap();

    bundle.SetString(KEY_PLAYER_IP, ip);

    return bundle;
}

StringMap Bundle_PlayerAuth(int client) {
    char steam[MAX_AUTHID_LENGTH];

    GetClientAuthId(client, AuthId_Steam3, steam, sizeof(steam));

    StringMap bundle = new StringMap();

    bundle.SetString(KEY_PLAYER_STEAM, steam);

    return bundle;
}

StringMap Bundle_PlayerName(int client) {
    char name[MAX_NAME_LENGTH];

    GetClientName(client, name, sizeof(name));

    StringMap bundle = new StringMap();

    bundle.SetString(KEY_PLAYER_NAME, name);

    return bundle;
}

void Bundle_Destroy(StringMap bundle) {
    StringMap session;

    bundle.GetValue(KEY_SESSION, session);

    UseCase_ReleaseSession(session);
    CloseHandle(bundle);
}
