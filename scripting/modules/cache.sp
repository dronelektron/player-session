static StringMap g_playerAddressId;
static StringMap g_playerAuthId;

void Cache_Create() {
    g_playerAddressId = new StringMap();
    g_playerAuthId = new StringMap();
}

int Cache_GetPlayerAddressId(const char[] ip) {
    int addressId = ID_NOT_FOUND;

    g_playerAddressId.GetValue(ip, addressId);

    return addressId;
}

void Cache_SetPlayerAddressId(const char[] ip, int addressId) {
    g_playerAddressId.SetValue(ip, addressId);
}

int Cache_GetPlayerAuthId(const char[] steam) {
    int authId = ID_NOT_FOUND;

    g_playerAuthId.GetValue(steam, authId);

    return authId;
}

void Cache_SetPlayerAuthId(const char[] steam, int authId) {
    g_playerAuthId.SetValue(steam, authId);
}
