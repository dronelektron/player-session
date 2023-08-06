void UseCase_StartSession(int client) {
    StringMap session = Bundle_Session();

    session.SetValue(KEY_CONNECTED_ON, GetTime());

    Session_Set(client, session);
    UseCase_RetainSession(session);
}

void UseCase_FinishSession(int client) {
    StringMap session = Session_Get(client);

    session.SetValue(KEY_DISCONNECTED_ON, GetTime());

    Session_Reset(client);
    UseCase_SaveSession(session);
    UseCase_ReleaseSession(session);
}

void UseCase_SaveSession(StringMap session) {
    if (Session_IsCompleted(session)) {
        Database_Session_Insert(session);
    }
}

void UseCase_GetPlayerInfo(int client) {
    UseCase_SavePlayerAddress(client);
    UseCase_SavePlayerAuth(client);
    UseCase_SavePlayerName(client);
}

static void UseCase_SavePlayerAddress(int client) {
    StringMap bundle = Bundle_PlayerAddress(client);

    UseCase_AddSessionToBundle(client, bundle);
    Database_PlayerAddress_InsertOrGetId(bundle);
}

static void UseCase_SavePlayerAuth(int client) {
    StringMap bundle = Bundle_PlayerAuth(client);

    UseCase_AddSessionToBundle(client, bundle);
    Database_PlayerAuth_InsertOrGetId(bundle);
}

static void UseCase_SavePlayerName(int client) {
    StringMap bundle = Bundle_PlayerName(client);

    UseCase_AddSessionToBundle(client, bundle);
    Database_PlayerName_InsertOrGetId(bundle);
}

static void UseCase_AddSessionToBundle(int client, StringMap bundle) {
    StringMap session = Session_Get(client);

    bundle.SetValue(KEY_SESSION, session);

    UseCase_RetainSession(session);
}

void UseCase_RetainSession(StringMap session) {
    UseCase_UpdateCounter(session, 1);
}

void UseCase_ReleaseSession(StringMap session) {
    int counter = UseCase_UpdateCounter(session, -1);

    if (counter == 0) {
        CloseHandle(session);
    }
}

static int UseCase_UpdateCounter(StringMap session, int delta) {
    int counter;

    session.GetValue(KEY_COUNTER, counter);
    counter += delta;
    session.SetValue(KEY_COUNTER, counter);

    return counter;
}
