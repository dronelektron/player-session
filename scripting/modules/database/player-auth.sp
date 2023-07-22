static const char g_createTable[] = ""
... "CREATE TABLE %s"
... "("
... "id INTEGER PRIMARY KEY, "
... "steam TEXT NOT NULL UNIQUE"
... ");";

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
