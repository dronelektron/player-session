static StringMap g_playerAddressId;
static StringMap g_playerAuthId;
static StringMap g_playerNameId;

void Cache_Create() {
    g_playerAddressId = new StringMap();
    g_playerAuthId = new StringMap();
    g_playerNameId = new StringMap();
}

int Cache_GetPlayerAddressId(const char[] ip) {
    int addressId = NO_ROW_ID;

    g_playerAddressId.GetValue(ip, addressId);

    return addressId;
}

void Cache_SetPlayerAddressId(const char[] ip, int addressId) {
    g_playerAddressId.SetValue(ip, addressId);
}

int Cache_GetPlayerAuthId(const char[] steam) {
    int authId = NO_ROW_ID;

    g_playerAuthId.GetValue(steam, authId);

    return authId;
}

void Cache_SetPlayerAuthId(const char[] steam, int authId) {
    g_playerAuthId.SetValue(steam, authId);
}

int Cache_GetPlayerNameId(const char[] name) {
    int nameId = NO_ROW_ID;

    g_playerNameId.GetValue(name, nameId);

    return nameId;
}

void Cache_SetPlayerNameId(const char[] name, int nameId) {
    g_playerNameId.SetValue(name, nameId);
}
