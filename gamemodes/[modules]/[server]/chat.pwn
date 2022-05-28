//?=============================== Stock Includes =========================================//
#include <a_samp>
#include <ysilib\YSI_Visual\y_commands>
#include <ysilib\YSI_Coding\y_hooks>

//!OOC Chat
YCMD:b(playerid, params[], help)
{
	new string[128], text[100];
	if(sscanf(params, "s[100]", text)) return SendClientMessage(playerid, col_server, "M >> "c_white"Nisi uneo text!");
 	format(string, sizeof(string), "(( "c_white"OOC"c_greey" )) "c_white"%s "c_greey": "c_white"%s", ReturnPlayerName(playerid), text);
	ProxDetector(playerid, Float:30.0, col_greey, string);

	return Y_HOOKS_CONTINUE_RETURN_1;
}