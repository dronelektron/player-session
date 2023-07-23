#include <sourcemod>

#include "ps/database"
#include "ps/database/player-address"
#include "ps/database/player-auth"
#include "ps/database/player-name"
#include "ps/database/session"
#include "ps/bundle"
#include "ps/string"
#include "ps/use-case"

#include "modules/database.sp"
#include "modules/database/player-address.sp"
#include "modules/database/player-auth.sp"
#include "modules/database/player-name.sp"
#include "modules/database/session.sp"
#include "modules/bundle.sp"
#include "modules/cache.sp"
#include "modules/session.sp"
#include "modules/string.sp"
#include "modules/use-case.sp"

public Plugin myinfo = {
    name = "Player session",
    author = "Dron-elektron",
    description = "Allows you to collect various information about the player",
    version = "0.1.0",
    url = "https://github.com/dronelektron/player-session"
};

public void OnPluginStart() {
    Cache_Create();
    Database_Connect();
}

public void OnClientConnected(int client) {
    Session_Create(client);
}

public void OnClientDisconnect(int client) {
    Session_Destroy(client);
}

public void OnClientPostAdminCheck(int client) {
    UseCase_GetPlayerInfo(client);
}
