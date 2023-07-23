static const char g_createTable[] = ""
... "CREATE TABLE %s"
... "("
... "id INTEGER PRIMARY KEY, "
... "ip TEXT NOT NULL UNIQUE"
... ");";

static const char g_insertAddress[] = ""
... "INSERT OR IGNORE INTO player_address (ip) "
... "VALUES ('%s');";

static const char g_getAddressId[] = ""
... "SELECT id "
... "FROM player_address "
... "WHERE ip = '%s';";

void Database_PlayerAddress_Create() {
    char query[QUERY_SIZE];

    Database_Get().Format(query, sizeof(query), g_createTable, DATABASE_TABLE_PLAYER_ADDRESS);
    Database_Get().Query(Database_PlayerAddress_OnCreate, query);
}

public void Database_PlayerAddress_OnCreate(Database database, DBResultSet results, const char[] error, any data) {
    if (String_IsEmpty(error)) {
        LogMessage("Created '%s' table", DATABASE_TABLE_PLAYER_ADDRESS);
    }
}

void Database_PlayerAddress_InsertOrGetId(StringMap bundle) {
    char ip[IP_SIZE];

    bundle.GetString(KEY_PLAYER_IP, ip, sizeof(ip));

    int addressId = Cache_GetPlayerAddressId(ip);

    if (addressId != ID_NOT_FOUND) {
        Database_PlayerAddress_UpdateSession(bundle, addressId);
        CloseHandle(bundle);

        return;
    }

    char insertQuery[QUERY_SIZE];
    char selectQuery[QUERY_SIZE];

    Database_Get().Format(insertQuery, sizeof(insertQuery), g_insertAddress, ip);
    Database_Get().Format(selectQuery, sizeof(selectQuery), g_getAddressId, ip);

    Transaction transaction = new Transaction();

    transaction.AddQuery(insertQuery);
    transaction.AddQuery(selectQuery);

    Database_Get().Execute(transaction, Database_PlayerAddress_InsertOrGetIdSuccess, Database_PlayerAddress_InsertOrGetIdFailure, bundle);
}

public void Database_PlayerAddress_InsertOrGetIdSuccess(Database database, StringMap bundle, int numQueries, DBResultSet[] results, any[] queryData) {
    DBResultSet selectedResults = results[1];

    if (selectedResults.FetchRow()) {
        int addressId = selectedResults.FetchInt(0);

        Database_PlayerAddress_UpdateCache(bundle, addressId);
        Database_PlayerAddress_UpdateSession(bundle, addressId);
    }

    CloseHandle(bundle);
}

public void Database_PlayerAddress_InsertOrGetIdFailure(Database database, StringMap bundle, int numQueries, const char[] error, int failIndex, any[] queryData) {
    LogError("Transaction is failed: '%s'", error);
    CloseHandle(bundle);
}

static void Database_PlayerAddress_UpdateCache(StringMap bundle, int addressId) {
    char ip[IP_SIZE];

    bundle.GetString(KEY_PLAYER_IP, ip, sizeof(ip));

    Cache_SetPlayerAddressId(ip, addressId);
}

static void Database_PlayerAddress_UpdateSession(StringMap bundle, int addressId) {
    int clientId;

    bundle.GetValue(KEY_CLIENT_ID, clientId);

    int client = GetClientOfUserId(clientId);

    if (client != INVALID_CLIENT) {
        Session_Get(client).SetValue(KEY_PLAYER_ADDRESS_ID, addressId);
    }
}
