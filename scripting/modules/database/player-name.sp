static const char g_createTable[] = ""
... "CREATE TABLE %s"
... "("
... "id INTEGER PRIMARY KEY, "
... "name TEXT NOT NULL UNIQUE"
... ");";

static const char g_insertName[] = ""
... "INSERT OR IGNORE INTO player_name (name) "
... "VALUES ('%s');";

static const char g_getNameId[] = ""
... "SELECT id "
... "FROM player_name "
... "WHERE name = '%s';";

void Database_PlayerName_Create() {
    char query[QUERY_SIZE];

    Database_Get().Format(query, sizeof(query), g_createTable, DATABASE_TABLE_PLAYER_NAME);
    Database_Get().Query(Database_PlayerName_OnCreate, query);
}

public void Database_PlayerName_OnCreate(Database database, DBResultSet results, const char[] error, any data) {
    if (String_IsEmpty(error)) {
        LogMessage("Created '%s' table", DATABASE_TABLE_PLAYER_NAME);
    }
}

void Database_PlayerName_Insert(StringMap bundle) {
    char query[QUERY_SIZE];
    char name[MAX_NAME_LENGTH];

    bundle.GetString(KEY_PLAYER_NAME, name, sizeof(name));

    Database_Get().Format(query, sizeof(query), g_insertName, name);
    Database_Get().Query(Database_PlayerName_OnInsert, query, bundle);
}

public void Database_PlayerName_OnInsert(Database database, DBResultSet results, const char[] error, StringMap bundle) {
    char name[MAX_NAME_LENGTH];

    bundle.GetString(KEY_PLAYER_NAME, name, sizeof(name));

    int nameId = Cache_GetPlayerNameId(name);

    if (nameId == ID_NOT_FOUND) {
        Database_PlayerName_Cache(bundle);
    } else {
        Database_PlayerName_UpdateSession(bundle, nameId);
        CloseHandle(bundle);
    }
}

static void Database_PlayerName_Cache(StringMap bundle) {
    char query[QUERY_SIZE];
    char name[MAX_NAME_LENGTH];

    bundle.GetString(KEY_PLAYER_NAME, name, sizeof(name));

    Database_Get().Format(query, sizeof(query), g_getNameId, name);
    Database_Get().Query(Database_PlayerName_OnCache, query, bundle);
}

public void Database_PlayerName_OnCache(Database database, DBResultSet results, const char[] error, StringMap bundle) {
    if (results.FetchRow()) {
        int nameId = results.FetchInt(0);
        char name[MAX_NAME_LENGTH];

        bundle.GetString(KEY_PLAYER_NAME, name, sizeof(name));

        Cache_SetPlayerNameId(name, nameId);
        Database_PlayerName_UpdateSession(bundle, nameId);
    }

    CloseHandle(bundle);
}

static void Database_PlayerName_UpdateSession(StringMap bundle, int nameId) {
    int clientId;

    bundle.GetValue(KEY_CLIENT_ID, clientId);

    int client = GetClientOfUserId(clientId);

    if (client != INVALID_CLIENT) {
        Session_Get(client).SetValue(KEY_PLAYER_NAME_ID, nameId);
    }
}
