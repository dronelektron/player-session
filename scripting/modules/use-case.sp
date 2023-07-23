void UseCase_GetPlayerInfo(int client) {
    UseCase_SavePlayerAddress(client);
    UseCase_SavePlayerAuth(client);
    UseCase_SavePlayerName(client);
}

static void UseCase_SavePlayerAddress(int client) {
    StringMap bundle = Bundle_PlayerAddress(client);

    Database_PlayerAddress_InsertOrGetId(bundle);
}

static void UseCase_SavePlayerAuth(int client) {
    StringMap bundle = Bundle_PlayerAuth(client);

    Database_PlayerAuth_InsertOrGetId(bundle);
}

static void UseCase_SavePlayerName(int client) {
    StringMap bundle = Bundle_PlayerName(client);

    Database_PlayerName_InsertOrGetId(bundle);
}
