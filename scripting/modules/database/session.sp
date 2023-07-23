static const char g_createTable[] = ""
... "CREATE TABLE session"
... "("
... "id INTEGER PRIMARY KEY, "
... "player_address_id INTEGER, "
... "player_auth_id INTEGER, "
... "player_name_id INTEGER, "
... "connected_on INTEGER, "
... "disconnected_on INTEGER"
... ");";

static const char g_insertSession[] = ""
... "INSERT INTO session (player_address_id, player_auth_id, player_name_id, connected_on, disconnected_on) "
... "VALUES (%d, %d, %d, %d, %d);";

void Database_Session_Create() {
    char query[QUERY_SIZE];

    Database_Get().Format(query, sizeof(query), g_createTable, DATABASE_TABLE_SESSION);
    Database_Get().Query(Database_Session_OnCreate, query);
}

public void Database_Session_OnCreate(Database database, DBResultSet results, const char[] error, any data) {
    if (String_IsEmpty(error)) {
        LogMessage("Created '%s' table", DATABASE_TABLE_SESSION);
    }
}

void Database_Session_Insert(StringMap bundle) {
    char query[QUERY_SIZE];
    int addressId;
    int authId;
    int nameId;
    int connectedOn;
    int disconnectedOn;

    bundle.GetValue(KEY_PLAYER_ADDRESS_ID, addressId);
    bundle.GetValue(KEY_PLAYER_AUTH_ID, authId);
    bundle.GetValue(KEY_PLAYER_NAME_ID, nameId);
    bundle.GetValue(KEY_CONNECTED_ON, connectedOn);
    bundle.GetValue(KEY_DISCONNECTED_ON, disconnectedOn);

    Database_Get().Format(query, sizeof(query), g_insertSession, addressId, authId, nameId, connectedOn, disconnectedOn);
    Database_Get().Query(Database_Session_OnInsert, query, bundle);
}

public void Database_Session_OnInsert(Database database, DBResultSet results, const char[] error, StringMap bundle) {
    CloseHandle(bundle);
}
