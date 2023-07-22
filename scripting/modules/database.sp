static Database g_database;

void Database_Connect() {
    Database.Connect(Database_OnConnect, DATABASE_NAME);
}

public void Database_OnConnect(Database database, const char[] error, any data) {
    if (database == null) {
        SetFailState("Connection to '%s' database is failed: '%s'", DATABASE_NAME, error);
    } else {
        g_database = database;

        LogMessage("Connected to '%s' database", DATABASE_NAME);
        Database_Map_Create();
        Database_PlayerAddress_Create();
        Database_PlayerAuth_Create();
        Database_PlayerName_Create();
        Database_Session_Create();
    }
}

Database Database_Get() {
    return g_database;
}
