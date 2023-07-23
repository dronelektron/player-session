void UseCase_GetPlayerInfo(int client) {
    UseCase_SavePlayerAddress(client);
}

static void UseCase_SavePlayerAddress(int client) {
    StringMap bundle = Bundle_PlayerAddress(client);

    Database_PlayerAddress_Insert(bundle);
}
