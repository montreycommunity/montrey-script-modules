/*
? --
?Informacije
? --
* Montrey Community
* Version 0.0.1
? --
? Zahvale  :
? --
* Southclaws : https://github.com/pawn-lang/compiler
* Y_Less : https://github.com/pawn-lang/YSI-Includes/tree/v5.1
* Maddinat0r : https://github.com/maddinat0r/sscanf/releases
* Awesomdude : https://github.com/Awsomedude/easyDialog
* samp-incognito : https://github.com/samp-incognito/samp-streamer-plugin/releases
? --
? Credits :
? --
* Vostic - Founder, Scripter, Mapper, TextDraw
* Neithan - Developer
? --
? Defined
? --
*	c_server + col_server = Server Color
*	c_yellow + col_yellow = Information Poruke
*	c_red + col_red = Error Massage / Very Important Message
*	c_blue + col_blue = Jobs Info
*	c_green + col_green = Bank Info 
*	c_orange + col_orange = Orgs Info
*	c_ltblue + col_ltblue = Staff Colors
*	c_pink + col_pink =	Anticheat Info
*	c_white + col_white = IC Chat
*	c_greey + col_gteey = OOC Chat

*   Server Tag = | M >>
? --
?Staff Level
? --
* Staff 1 - //! Helper
* Staff 2 - //! Silver Staff
* Staff 3 - //! Gold Staff
* Staff 4 - //! Diamond Staff
* Staff 5 - //! Head Staff //! Podrank (Vodja Helpera, Vodja Lidera)
* Staff 6 - //! Direktor //! Podrank (Mapper, Pomocni Skripter)
* Staff 7 - //! Vlasnik 
? ==
?==
* Imajte u vidu da kada komentariste ovaj mod da ovo nema veze s nasim modom jer je nas mod modularan
* Ovo radimo da pomognemo drugima i bice 2 razlicite verzije na nasem githubu
* Mozete pisati bugove koje nalazite a mi cemo resiti iste.
*/

//! Ne pipaj kolko se ne valja
#define YSI_YES_HEAP_MALLOC

const MAX_PLAYERS = 1000;

#define CGEN_MEMORY 20000

//?=============================== Stock Includes =========================================//
#include <a_samp>
#include <ysilib\YSI_Storage\y_ini>
#include <ysilib\YSI_Coding\y_timers>
#include <ysilib\YSI_Visual\y_commands>
#include <ysilib\YSI_Coding\y_hooks>
#include <ysilib\YSI_Data\y_foreach>
#include <sscanf\sscanf2>
#include <easy-dialog>
#include <streamer>

//?=============================== Hook Skripte =========================================//
#include "[modules]/[server]/maps.pwn"
#include "[modules]/[server]/colors.pwn"
#include "[modules]/[server]/proxdetect.pwn"

#include "[modules]/[server]/labels.pwn"
#include "[modules]/[server]/reglog.pwn"

#include "[modules]/[admin]/staff.pwn"

#include "[modules]/[vozila]/vehoptions.pwn"

#include "[modules]/[igrac]/licnadokumenta.pwn"

#include "[modules]/[server]/payday.pwn"
#include "[modules]/[server]/banksys.pwn"
#include "[modules]/[server]/chat.pwn"

//?=============================== Simple Define =========================================//
#define VERZIJA_MODA     		"v0.0.1 by Montrey.pwn"
#define MAP_NAME    			"Balkan"
#define JEZIK_GMA               "Ex-Yu"

//?=============================== Main Mod =========================================//

main()
{
	print("================== [ MOD UCITAN ] ======================");
	print("	   Montrey Community - www.montrey.xyz				   ");
	print("	     v0.0.1 gamemode - Loading...					   ");
	print("	     v0.0.1 gamemode - Loaded.  					   ");
	print("	     v0.0.1 gamemode by Vostic    		  			   ");
	print("========================================================");
}

public OnGameModeInit()
{
	SetGameModeText( VERZIJA_MODA );
	SendRconCommand( "language "JEZIK_GMA"" );
	SendRconCommand( "mapname "MAP_NAME"" );

	DisableInteriorEnterExits(); 							//!Gasi default ulaze i izlaze
	ManualVehicleEngineAndLights();  						//!Gasi manualno paljenje svetala i motora
	ShowPlayerMarkers(PLAYER_MARKERS_MODE_OFF); 			//!Gasi player markere
	SetNameTagDrawDistance(20.0); 							//!Razdaljina na kojoj se vidi igracevo ime
	LimitGlobalChatRadius(20.0); 							//!Limit za globalni chat (razdaljina)
	EnableVehicleFriendlyFire(); 							//!Dozvoljava da se svako vozilo moze unistiti

	return 1;
}

public OnPlayerConnect(playerid)
{
	SetPlayerColor(playerid, col_white);					//!Postavlja default boju igraca na belu

	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	
    return 1;
}

public OnPlayerSpawn(playerid)
{
	SetPlayerTeam(playerid, NO_TEAM); 							//!Postavlja da nema timova

	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{

    return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{

    return 1;
}

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{

	return 1;
}
