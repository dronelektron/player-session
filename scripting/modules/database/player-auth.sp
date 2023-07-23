static const char g_createTable[] = ""
... "CREATE TABLE %s"
... "("
... "id INTEGER PRIMARY KEY, "
... "steam TEXT NOT NULL UNIQUE"
... ");";

static const char g_insertAuth[] = ""
... "INSERT OR IGNORE INTO player_auth (steam) "
... "VALUES ('%s');";

static const char g_getAuthId[] = ""
... "SELECT id "
... "FROM player_auth "
... "WHERE steam = '%s';";

void Database_PlayerAuth_Create() {
    char query[QUERY_SIZE];

    Database_Get().Format(query, sizeof(query), g_createTable, DATABASE_TABLE_PLAYER_AUTH);
    Database_Get().Query(Database_PlayerAuth_OnCreate, query);
}

public void Database_PlayerAuth_OnCreate(Database database, DBResultSet results, const char[] error, any data) {
    if (String_IsEmpty(error)) {
        LogMessage("Created '%s' table", DATABASE_TABLE_PLAYER_AUTH);
    }
}

void Database_PlayerAuth_Insert(StringMap bundle) {
    char query[QUERY_SIZE];
    char steam[MAX_AUTHID_LENGTH];

    bundle.GetString(KEY_PLAYER_STEAM, steam, sizeof(steam));

    Database_Get().Format(query, sizeof(query), g_insertAuth, steam);
    Database_Get().Query(Database_PlayerAuth_OnInsert, query, bundle);
}

public void Database_PlayerAuth_OnInsert(Database database, DBResultSet results, const char[] error, StringMap bundle) {
    char steam[MAX_AUTHID_LENGTH];

    bundle.GetString(KEY_PLAYER_STEAM, steam, sizeof(steam));

    int authId = Cache_GetPlayerAuthId(steam);

    if (authId == ID_NOT_FOUND) {
        Database_PlayerAuth_Cache(bundle);
    } else {
        Database_PlayerAuth_UpdateSession(bundle, authId);
        CloseHandle(bundle);
    }
}

static void Database_PlayerAuth_Cache(StringMap bundle) {
    char query[QUERY_SIZE];
    char steam[IP_SIZE];

    bundle.GetString(KEY_PLAYER_STEAM, steam, sizeof(steam));

    Database_Get().Format(query, sizeof(query), g_getAuthId, steam);
    Database_Get().Query(Database_PlayerAuth_OnCache, query, bundle);
}

public void Database_PlayerAuth_OnCache(Database database, DBResultSet results, const char[] error, StringMap bundle) {
    if (results.FetchRow()) {
        int authId = results.FetchInt(0);
        char steam[IP_SIZE];

        bundle.GetString(KEY_PLAYER_STEAM, steam, sizeof(steam));

        Cache_SetPlayerAuthId(steam, authId);
        Database_PlayerAuth_UpdateSession(bundle, authId);
    }

    CloseHandle(bundle);
}

static void Database_PlayerAuth_UpdateSession(StringMap bundle, int authId) {
    int clientId;

    bundle.GetValue(KEY_CLIENT_ID, clientId);

    int client = GetClientOfUserId(clientId);

    if (client != INVALID_CLIENT) {
        Session_Get(client).SetValue(KEY_PLAYER_AUTH_ID, authId);
    }
}
