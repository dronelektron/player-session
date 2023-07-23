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

void Database_PlayerAddress_Insert(StringMap bundle) {
    char query[QUERY_SIZE];
    char ip[IP_SIZE];

    bundle.GetString(KEY_PLAYER_IP, ip, sizeof(ip));

    Database_Get().Format(query, sizeof(query), g_insertAddress, ip);
    Database_Get().Query(Database_PlayerAddress_OnInsert, query, bundle);
}

public void Database_PlayerAddress_OnInsert(Database database, DBResultSet results, const char[] error, StringMap bundle) {
    char ip[IP_SIZE];

    bundle.GetString(KEY_PLAYER_IP, ip, sizeof(ip));

    int addressId = Cache_GetPlayerAddressId(ip);

    if (addressId == ID_NOT_FOUND) {
        Database_PlayerAddress_Cache(bundle);
    } else {
        Database_PlayerAddress_UpdateSession(bundle, addressId);
        CloseHandle(bundle);
    }
}

static void Database_PlayerAddress_Cache(StringMap bundle) {
    char query[QUERY_SIZE];
    char ip[IP_SIZE];

    bundle.GetString(KEY_PLAYER_IP, ip, sizeof(ip));

    Database_Get().Format(query, sizeof(query), g_getAddressId, ip);
    Database_Get().Query(Database_PlayerAddress_OnCache, query, bundle);
}

public void Database_PlayerAddress_OnCache(Database database, DBResultSet results, const char[] error, StringMap bundle) {
    if (results.FetchRow()) {
        int addressId = results.FetchInt(0);
        char ip[IP_SIZE];

        bundle.GetString(KEY_PLAYER_IP, ip, sizeof(ip));

        Cache_SetPlayerAddressId(ip, addressId);
        Database_PlayerAddress_UpdateSession(bundle, addressId);
    }

    CloseHandle(bundle);
}

static void Database_PlayerAddress_UpdateSession(StringMap bundle, int addressId) {
    int clientId;

    bundle.GetValue(KEY_CLIENT_ID, clientId);

    int client = GetClientOfUserId(clientId);

    if (client != INVALID_CLIENT) {
        Session_Get(client).SetValue(KEY_PLAYER_ADDRESS_ID, addressId);
    }
}
