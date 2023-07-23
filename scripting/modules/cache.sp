static StringMap g_playerAddressId;

void Cache_Create() {
    g_playerAddressId = new StringMap();
}

int Cache_GetPlayerAddressId(const char[] ip) {
    int addressId = ID_NOT_FOUND;

    g_playerAddressId.GetValue(ip, addressId);

    return addressId;
}

void Cache_SetPlayerAddressId(const char[] ip, int addressId) {
    g_playerAddressId.SetValue(ip, addressId);
}
