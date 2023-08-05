static StringMap g_sessions[MAXPLAYERS + 1];

StringMap Session_Get(int client) {
    return g_sessions[client];
}

void Session_Create(int client) {
    g_sessions[client] = Bundle_Session();
    g_sessions[client].SetValue(KEY_CONNECTED_ON, GetTime());
}

void Session_Destroy(int client) {
    g_sessions[client].SetValue(KEY_DISCONNECTED_ON, GetTime());

    if (Session_IsCompleted(client)) {
        Database_Session_Insert(g_sessions[client]);

        g_sessions[client] = null;
    } else {
        delete g_sessions[client];
    }
}

static bool Session_IsCompleted(int client) {
    int addressId = NO_ROW_ID;
    int authId = NO_ROW_ID;
    int nameId = NO_ROW_ID;
    int connectedOn;
    int disconnectedOn;

    g_sessions[client].GetValue(KEY_PLAYER_ADDRESS_ID, addressId);
    g_sessions[client].GetValue(KEY_PLAYER_AUTH_ID, authId);
    g_sessions[client].GetValue(KEY_PLAYER_NAME_ID, nameId);
    g_sessions[client].GetValue(KEY_CONNECTED_ON, connectedOn);
    g_sessions[client].GetValue(KEY_DISCONNECTED_ON, disconnectedOn);

    bool completed = true;

    completed &= addressId != NO_ROW_ID;
    completed &= authId != NO_ROW_ID;
    completed &= nameId != NO_ROW_ID;
    completed &= connectedOn != TIME_NOT_SET;
    completed &= disconnectedOn != TIME_NOT_SET;

    return completed;
}
