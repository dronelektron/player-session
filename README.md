# Player session

Allows you to collect various information about the player:

* IP
* SteamID3
* Name
* When connected
* When disconnected

### Supported Games

* Day of Defeat: Source

### Installation

* Download latest [release](https://github.com/dronelektron/player-session/releases) (compiled for SourceMod 1.11)
* Extract "plugins" folder to "addons/sourcemod" folder of your server
* Add the database configuration to the "addons/sourcemod/configs/databases.cfg" file
  
### Database Configuration

```
"Databases"
{
	"player-session"
	{
		"driver"			"sqlite"
		"database"			"player-session"
	}
}
```
