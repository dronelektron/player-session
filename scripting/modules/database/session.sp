static const char g_createTable[] = ""
... "CREATE TABLE session"
... "("
... "id INTEGER PRIMARY KEY, "
... "map_id INTEGER, "
... "player_address_id INTEGER, "
... "player_auth_id INTEGER, "
... "player_name_id INTEGER, "
... "connected_on INTEGER, "
... "disconnected_on INTEGER"
... ");";

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
