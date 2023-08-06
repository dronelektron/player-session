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

void Database_PlayerAuth_InsertOrGetId(StringMap bundle) {
    char steam[MAX_AUTHID_LENGTH];

    bundle.GetString(KEY_PLAYER_STEAM, steam, sizeof(steam));

    int authId = Cache_GetPlayerAuthId(steam);

    if (authId != NO_ROW_ID) {
        Database_PlayerAuth_UpdateSession(bundle, authId);
        Bundle_Destroy(bundle);

        return;
    }

    char insertQuery[QUERY_SIZE];
    char selectQuery[QUERY_SIZE];

    Database_Get().Format(insertQuery, sizeof(insertQuery), g_insertAuth, steam);
    Database_Get().Format(selectQuery, sizeof(selectQuery), g_getAuthId, steam);

    Transaction transaction = new Transaction();

    transaction.AddQuery(insertQuery);
    transaction.AddQuery(selectQuery);

    Database_Get().Execute(transaction, Database_PlayerAuth_InsertOrGetIdSuccess, Database_PlayerAuth_InsertOrGetIdFailure, bundle);
}

public void Database_PlayerAuth_InsertOrGetIdSuccess(Database database, StringMap bundle, int numQueries, DBResultSet[] results, any[] queryData) {
    DBResultSet selectedResults = results[1];

    if (selectedResults.FetchRow()) {
        int authId = selectedResults.FetchInt(0);

        Database_PlayerAuth_UpdateCache(bundle, authId);
        Database_PlayerAuth_UpdateSession(bundle, authId);
    }

    Bundle_Destroy(bundle);
}

public void Database_PlayerAuth_InsertOrGetIdFailure(Database database, StringMap bundle, int numQueries, const char[] error, int failIndex, any[] queryData) {
    LogError("Transaction is failed: '%s'", error);
    Bundle_Destroy(bundle);
}

static void Database_PlayerAuth_UpdateCache(StringMap bundle, int authId) {
    char steam[MAX_AUTHID_LENGTH];

    bundle.GetString(KEY_PLAYER_STEAM, steam, sizeof(steam));

    Cache_SetPlayerAuthId(steam, authId);
}

static void Database_PlayerAuth_UpdateSession(StringMap bundle, int authId) {
    StringMap session;

    bundle.GetValue(KEY_SESSION, session);
    session.SetValue(KEY_PLAYER_AUTH_ID, authId);

    UseCase_SaveSession(session);
}
