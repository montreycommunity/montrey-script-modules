//?=============================== Stock Includes =========================================//
#include <a_samp>
#include <ysilib\YSI_Storage\y_ini>
#include <ysilib\YSI_Coding\y_timers>
#include <ysilib\YSI_Visual\y_commands>
#include <ysilib\YSI_Coding\y_hooks>
#include <ysilib\YSI_Data\y_foreach>
#include <sscanf\sscanf2>
#include <easy-dialog>

//!Variable

const MAX_PASSWORD_DUZINA = 64;
const MIN_PASSWORD_DUZINA = 6;
const MAX_LOGIN_POKUSAJA = 3;
static stock const USER_PATH[64] = "/Korisnici/%s.ini";

enum
{
 	iRegistrovan = 1,
	iUlogovan
};

static  
    iLozinka[MAX_PLAYERS][MAX_PASSWORD_DUZINA],
    iPol[MAX_PLAYERS][2],
    iLevel[MAX_PLAYERS],
    iNovac[MAX_PLAYERS],
	iBankovniRacun[MAX_PLAYERS],
	iNovacuBanci[MAX_PLAYERS],
    iGodine[MAX_PLAYERS],
    iSkin[MAX_PLAYERS],
	iDrzavljanstvo[MAX_PLAYERS],
	iPotrebnoRespekata[MAX_PLAYERS],
	iRespekti[MAX_PLAYERS],
    iLoginPokusaja[MAX_PLAYERS];

//  Callbacks

forward Account_Load(const playerid, const string: name[], const string: value[]);
public Account_Load(const playerid, const string: name[], const string: value[])
{
	INI_String("Lozinka", iLozinka[playerid]);
	INI_String("Pol", iPol[playerid]);
	INI_Int("Drzavljanstvo", iDrzavljanstvo[playerid]);
	INI_Int("Level", iLevel[playerid]);
	INI_Int("Novac", iNovac[playerid]);
	INI_Int("Skin", iSkin[playerid]);
	INI_Int("Respekti", iRespekti[playerid]);
	INI_Int("PotrebnoRespekata", iPotrebnoRespekata[playerid]);
	INI_Int("NovacuBanci", iNovacuBanci[playerid]);

	return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerConnect(playerid)
{
	TogglePlayerSpectating(playerid, 0);
	for(new ocisti1; ocisti1 < 110; ocisti1++)
	{
		SendClientMessageToAll(-1, "");
	}

	if (fexist(Korisnici(playerid)))
	{
		INI_ParseFile(Korisnici(playerid), "Account_Load", true, true, playerid);
		Dialog_Show(playerid, "dialog_login", DIALOG_STYLE_PASSWORD,
			"Prijavljivanje",
			"%s, unesite Vasu tacnu lozinku: ",
			"Potvrdi", "Izlaz", ReturnPlayerName(playerid)
		);
		return 1;
	}

	Dialog_Show(playerid, "dialog_regpassword", DIALOG_STYLE_INPUT,
		"Registracija",
		"%s, unesite Vasu zeljenu lozinku: ",
		"Potvrdi", "Izlaz", ReturnPlayerName(playerid)
	);
	return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	new INI:File = INI_Open(Korisnici(playerid));
    INI_SetTag(File,"data");
    INI_WriteInt(File, "Level",GetPlayerScore(playerid));
    INI_WriteInt(File, "Skin",GetPlayerSkin(playerid));
    INI_WriteInt(File, "Novac", GetPlayerMoney(playerid));
    INI_Close(File);

	return Y_HOOKS_CONTINUE_RETURN_1;
}

// Timers
timer Spawn_Player[100](playerid, type)
{
	if (type == iRegistrovan)
	{
		if(iDrzavljanstvo[playerid] == 0) //sf
		{
			SetSpawnInfo(playerid, 0, iSkin[playerid], 863.2152,-1101.9219,24.1592,272.1179, 0, 0, 0, 0, 0, 0);
		}
		else if(iDrzavljanstvo[playerid] == 1) //ls
		{
			SetSpawnInfo(playerid, 0, iSkin[playerid], 863.2152,-1101.9219,24.1592,272.1179, 0, 0, 0, 0, 0, 0);
		}
		else if(iDrzavljanstvo[playerid] == 2) //lv
		{
			SetSpawnInfo(playerid, 0, iSkin[playerid], 863.2152,-1101.9219,24.1592,272.1179, 0, 0, 0, 0, 0, 0);			
		}
		SpawnPlayer(playerid);

		SetPlayerScore(playerid, iLevel[playerid]);
		GivePlayerMoney(playerid, iNovac[playerid]);
		SetPlayerSkin(playerid, iSkin[playerid]);
	}

	else if (type == iUlogovan)
	{
		new ime[80], level[80], kes[80], kesbanka[80];
		format(ime, sizeof(ime), "| >> "c_white"Dobrodosao nazad na server, "c_server"%s << |", ReturnPlayerName(playerid));
		format(level, sizeof(level), "| >> "c_white"Tvoj trenuti "c_server"level "c_white"je : "c_server"%i << |", iLevel[playerid]);
		format(kes, sizeof(kes), "| >> "c_white"Tvoj "c_server"novac "c_white"u rukama : "c_server"%i$ << |", iNovac[playerid]);
		if(iBankovniRacun[playerid] == 0)
		{
			format(kesbanka, sizeof(kesbanka), "| >> "c_white"Vi nemate "c_server"racun "c_white"u banci! << |");
		}
		else if(iBankovniRacun[playerid] == 1)
		{
			format(kesbanka, sizeof(kesbanka), "| >> "c_white"Tvoj "c_server"novac "c_white"u banci : "c_server"%d$ << |", iNovacuBanci[playerid]);
		}
		
		SendClientMessage(playerid, col_server, "============== Dobrodosao nazad ==============");
		SendClientMessage(playerid, col_server, ime);
		SendClientMessage(playerid, col_server, level);
		SendClientMessage(playerid, col_server, kes);
		SendClientMessage(playerid, col_server, kesbanka);
		SendClientMessage(playerid, col_server, "| >> "c_white"Uzivaj u igri, Vas Montrey "c_white"Staff Tim "c_server"<< |");
		SendClientMessage(playerid, col_server, "============================================");		
		if(iDrzavljanstvo[playerid] == 0) //sf
		{
			SetSpawnInfo(playerid, 0, iSkin[playerid], 863.2152,-1101.9219,24.1592,272.1179, 0, 0, 0, 0, 0, 0);
		}
		else if(iDrzavljanstvo[playerid] == 1) //ls
		{
			SetSpawnInfo(playerid, 0, iSkin[playerid], 863.2152,-1101.9219,24.1592,272.1179, 0, 0, 0, 0, 0, 0);
		}
		else if(iDrzavljanstvo[playerid] == 2) //lv
		{
			SetSpawnInfo(playerid, 0, iSkin[playerid], 863.2152,-1101.9219,24.1592,272.1179, 0, 0, 0, 0, 0, 0);			
		}
		SpawnPlayer(playerid);
		iPotrebnoRespekata[playerid] = iLevel[playerid]*3+4;
		
		SetPlayerScore(playerid, iLevel[playerid]);
		GivePlayerMoney(playerid, iNovac[playerid]);
		SetPlayerSkin(playerid, iSkin[playerid]);

	}
}

// Functions
stock Korisnici(const playerid)
{
	new tmp_fmt[64];
	format(tmp_fmt, sizeof(tmp_fmt), USER_PATH, ReturnPlayerName(playerid));

	return tmp_fmt;
}

// Dialogs
Dialog: dialog_regpassword(const playerid, response, listitem, string: inputtext[])
{
	if (!response) // ovo je ako klikne izlaz (odustane od registracije)
		return Kick(playerid);

	if (!(MIN_PASSWORD_DUZINA <= strlen(inputtext) <= MAX_PASSWORD_DUZINA))
		return Dialog_Show(playerid, "dialog_regpassword", DIALOG_STYLE_INPUT,
			"Registracija",
			"%s, unesite Vasu zeljenu lozinku: ",
			"Potvrdi", "Izlaz", ReturnPlayerName(playerid)
		);

	strcopy(iLozinka[playerid], inputtext);

	Dialog_Show(playerid, "dialog_regages", DIALOG_STYLE_INPUT,
		"Godine",
		"Koliko imate godina: ",
		"Unesi", "Izlaz"
	);

	return Y_HOOKS_CONTINUE_RETURN_1;
}

Dialog: dialog_regages(const playerid, response, listitem, string: inputtext[])
{
	if (!response)
		return Kick(playerid);

	if (!(12 <= strval(inputtext) <= 50))
		return SendClientMessage(playerid, -1, "il si mlad il si mator"), Dialog_Show(playerid, "dialog_regages", DIALOG_STYLE_INPUT,
			"Godine",
			"Koliko imate godina: ",
			"Unesi", "Izlaz"
		);

	iGodine[playerid] = strval(inputtext);

	Dialog_Show(playerid, "dialog_drzavljanstvo", DIALOG_STYLE_LIST,
		"Drzavljanstvo",
		"San Fierro\nLos Santos\nLas Venturas",
		"Odaberi", "Izlaz"
	);

	return Y_HOOKS_CONTINUE_RETURN_1;
}

Dialog: dialog_drzavljanstvo(const playerid, response, listitem, string: inputtext[])
{
	if (!response)
		return Kick(playerid);
		
	if(response)
	{
		switch(listitem)
		{
			case 0:
			{
			 	iDrzavljanstvo[playerid] = 0;
				SendClientMessage(playerid, col_server, "M >> "c_white"Dobrodosao u Montrey, trebas pomoc, svrati do aktora!" );
			}
			case 1:
			{
			 	iDrzavljanstvo[playerid] = 1;
				SendClientMessage(playerid, col_server, "M >> "c_white"Dobrodosao u Montrey, trebas pomoc, svrati do aktora!" );
			}
			case 2:
			{
			 	iDrzavljanstvo[playerid] = 2;
				SendClientMessage(playerid, col_server, "M >> "c_white"Dobrodosao u Montrey, trebas pomoc, svrati do aktora!" );
			}
		}
	}

	Dialog_Show(playerid, "dialog_regsex", DIALOG_STYLE_LIST,
	"Spol",
	"Musko\nZensko",
	"Odaberi", "Izlaz"
	);
	return Y_HOOKS_CONTINUE_RETURN_1;
}

Dialog: dialog_regsex(const playerid, response, listitem, string: inputtext[])
{
	if (!response)
		return Kick(playerid);

	new tmp_int = listitem + 1;

	new INI:File = INI_Open(Korisnici(playerid));
	INI_SetTag(File,"data");
	INI_WriteString(File, "Lozinka", iLozinka[playerid]);
	INI_WriteString(File, "Pol", (tmp_int == 1 ? ("Musko") : ("Zensko")));
	INI_WriteInt(File, "Drzavljanstvo", iDrzavljanstvo[playerid]);
	INI_WriteInt(File, "Godine", iGodine[playerid]);
	INI_WriteInt(File, "Level", 1);
	INI_WriteInt(File, "Skin", 240);
	INI_WriteInt(File, "Novac", 1000);
	INI_WriteInt(File, "Staff", 0);
	INI_WriteInt(File, "StaffDuty", 0);
	INI_WriteInt(File, "LicnaKarta", 0);
	INI_WriteInt(File, "Respekti", 0);
	INI_WriteInt(File, "PotrebnoRespekata", 7);
	//! Bank Cuvanja
	INI_WriteInt(File, "BankovniRacun", 0); // Racun dal ima
	INI_WriteInt(File, "NovacuBanci", 0); // Racun dal ima
	INI_WriteInt(File, "KarticaPin", 0);

	INI_Close(File);

	iNovac[playerid] = 1000;
	iSkin[playerid] = 240;
	iLevel[playerid] = 1;
	iPotrebnoRespekata[playerid] = 7;

	defer Spawn_Player(playerid, 1);
	
	return Y_HOOKS_CONTINUE_RETURN_1;
}

Dialog: dialog_login(const playerid, response, listitem, string: inputtext[])
{
	if (!response)
		return Kick(playerid);

	if (!strcmp(iLozinka[playerid], inputtext, false))
		defer Spawn_Player(playerid, 2);
	else
	{
		if (iLoginPokusaja[playerid] == MAX_LOGIN_POKUSAJA)
			return Kick(playerid);

		++iLoginPokusaja[playerid];
		Dialog_Show(playerid, "dialog_login", DIALOG_STYLE_PASSWORD,
			"Prijavljivanje",
			"%s, unesite Vasu tacnu lozinku: ",
			"Potvrdi", "Izlaz", ReturnPlayerName(playerid)
		);
	}

	return Y_HOOKS_CONTINUE_RETURN_1;
}