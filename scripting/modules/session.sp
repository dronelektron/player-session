static StringMap g_sessions[MAXPLAYERS + 1];

StringMap Session_Get(int client) {
    return g_sessions[client];
}

void Session_Set(int client, StringMap session) {
    g_sessions[client] = session;
}

void Session_Reset(int client) {
    g_sessions[client] = null;
}

bool Session_IsCompleted(StringMap session) {
    int addressId = NO_ROW_ID;
    int authId = NO_ROW_ID;
    int nameId = NO_ROW_ID;
    int connectedOn;
    int disconnectedOn;

    session.GetValue(KEY_PLAYER_ADDRESS_ID, addressId);
    session.GetValue(KEY_PLAYER_AUTH_ID, authId);
    session.GetValue(KEY_PLAYER_NAME_ID, nameId);
    session.GetValue(KEY_CONNECTED_ON, connectedOn);
    session.GetValue(KEY_DISCONNECTED_ON, disconnectedOn);

    bool completed = true;

    completed &= addressId != NO_ROW_ID;
    completed &= authId != NO_ROW_ID;
    completed &= nameId != NO_ROW_ID;
    completed &= connectedOn != TIME_NOT_SET;
    completed &= disconnectedOn != TIME_NOT_SET;

    return completed;
}
