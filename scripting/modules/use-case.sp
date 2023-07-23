void UseCase_GetPlayerInfo(int client) {
    UseCase_SavePlayerAddress(client);
    UseCase_SavePlayerAuth(client);
}

static void UseCase_SavePlayerAddress(int client) {
    StringMap bundle = Bundle_PlayerAddress(client);

    Database_PlayerAddress_Insert(bundle);
}

static void UseCase_SavePlayerAuth(int client) {
    StringMap bundle = Bundle_PlayerAuth(client);

    Database_PlayerAuth_Insert(bundle);
}
