#include <sourcemod>

#include "ps/database"
#include "ps/database/map"
#include "ps/database/player-address"
#include "ps/database/player-auth"
#include "ps/database/player-name"
#include "ps/database/session"
#include "ps/string"

#include "modules/database.sp"
#include "modules/database/map.sp"
#include "modules/database/player-address.sp"
#include "modules/database/player-auth.sp"
#include "modules/database/player-name.sp"
#include "modules/database/session.sp"
#include "modules/string.sp"

public Plugin myinfo = {
    name = "Player session",
    author = "Dron-elektron",
    description = "Allows you to collect various information about the player",
    version = "0.1.0",
    url = "https://github.com/dronelektron/player-session"
};

public void OnPluginStart() {
    Database_Connect();
}
