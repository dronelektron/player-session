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

void Database_PlayerName_InsertOrGetId(StringMap bundle) {
    char name[MAX_NAME_LENGTH];

    bundle.GetString(KEY_PLAYER_NAME, name, sizeof(name));

    int nameId = Cache_GetPlayerNameId(name);

    if (nameId != ID_NOT_FOUND) {
        Database_PlayerName_UpdateSession(bundle, nameId);
        CloseHandle(bundle);

        return;
    }

    char insertQuery[QUERY_SIZE];
    char selectQuery[QUERY_SIZE];

    Database_Get().Format(insertQuery, sizeof(insertQuery), g_insertName, name);
    Database_Get().Format(selectQuery, sizeof(selectQuery), g_getNameId, name);

    Transaction transaction = new Transaction();

    transaction.AddQuery(insertQuery);
    transaction.AddQuery(selectQuery);

    Database_Get().Execute(transaction, Database_PlayerName_InsertOrGetIdSuccess, Database_PlayerName_InsertOrGetIdFailure, bundle);
}

public void Database_PlayerName_InsertOrGetIdSuccess(Database database, StringMap bundle, int numQueries, DBResultSet[] results, any[] queryData) {
    DBResultSet selectedResults = results[1];

    if (selectedResults.FetchRow()) {
        int nameId = selectedResults.FetchInt(0);

        Database_PlayerName_UpdateCache(bundle, nameId);
        Database_PlayerName_UpdateSession(bundle, nameId);
    }

    CloseHandle(bundle);
}

public void Database_PlayerName_InsertOrGetIdFailure(Database database, StringMap bundle, int numQueries, const char[] error, int failIndex, any[] queryData) {
    LogError("Transaction is failed: '%s'", error);
    CloseHandle(bundle);
}

static void Database_PlayerName_UpdateCache(StringMap bundle, int nameId) {
    char name[MAX_NAME_LENGTH];

    bundle.GetString(KEY_PLAYER_NAME, name, sizeof(name));

    Cache_SetPlayerNameId(name, nameId);
}

static void Database_PlayerName_UpdateSession(StringMap bundle, int nameId) {
    int clientId;

    bundle.GetValue(KEY_CLIENT_ID, clientId);

    int client = GetClientOfUserId(clientId);

    if (client != INVALID_CLIENT) {
        Session_Get(client).SetValue(KEY_PLAYER_NAME_ID, nameId);
    }
}
