//?=============================== Stock Includes =========================================//
#include <a_samp>
#include <ysilib\YSI_Storage\y_ini>
#include <ysilib\YSI_Coding\y_hooks>
#include <ysilib\YSI_Visual\y_commands>

static
    iLicnaKarta[MAX_PLAYERS],                   //!Cuvanje za licnu kartu igraca
    iDrzavljanstvo[MAX_PLAYERS],                //!Drzavljanstvo igraca
    iNovac[MAX_PLAYERS];                        //!Novac igraca

//!Ucitavanje nove 2 stavke i stavki koje vec postoje al su potrebne u ovom externom fajlu
hook Account_Load(const playerid, const string: name[], const string: value[]);
hook Account_Load(const playerid, const string: name[], const string: value[])
{
	INI_Int("LicnaKarta", iLicnaKarta[playerid]);
    INI_Int("Drzavljanstvo", iDrzavljanstvo[playerid]);
    INI_Int("Novac", iNovac[playerid]);

    return Y_HOOKS_CONTINUE_RETURN_1;
}
//!Vadjenje licne karte
YCMD:izvadilicnu(playerid, params[], help)
{
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, 361.2740, 171.0686, 1008.3828)) return SendClientMessage(playerid, col_red, "M >> "c_white"Morate biti na salteru u opstini!");
    if(iLicnaKarta[playerid] == 1) return SendClientMessage(playerid, col_red, "M >> "c_white"Vec imate licnu kartu!");
    if(GetPlayerMoney(playerid) < 200) return SendClientMessage(playerid, col_red, "M >> "c_white"Nemate dovoljno novca!");

    iLicnaKarta[playerid] = 1;
    GivePlayerMoney(playerid, -200);
    ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 0, 0, 0, 0);
    SendClientMessage(playerid, col_server, "M >> "c_white"Uspesno si izvadio licnu kartu!");

    new INI:File = INI_Open(Korisnici(playerid));
	INI_SetTag( File, "data" );

	INI_WriteInt(File, "LicnaKarta", iLicnaKarta[playerid]);
    INI_WriteInt(File, "Novac", GetPlayerMoney(playerid));

	INI_Close( File );

    return Y_HOOKS_CONTINUE_RETURN_1;

}
//!Promena drzavljanstva
YCMD:promenidrzavljanstvo(playerid, params[], help)
{
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, 361.2740, 171.0686, 1008.3828)) return SendClientMessage(playerid, col_red, "M >> "c_white"Morate biti na salteru u opstini!");
    if(iLicnaKarta[playerid] == 0) return SendClientMessage(playerid, col_red, "M >> "c_white"Morate imati licnu kartu (/izvadilicnu)!");
    if(GetPlayerMoney(playerid) < 200) return SendClientMessage(playerid, col_red, "M >> "c_white"Nemate dovoljno novca!");

    
	Dialog_Show(playerid, "dialog_promenadrzave", DIALOG_STYLE_LIST,
		"Promena Drzavljanstva",
		"San Fierro\nLos Santos\nLas Venturas",
		"Odaberi", "Izlaz"
	);

    return Y_HOOKS_CONTINUE_RETURN_1;

}

Dialog: dialog_promenadrzave(const playerid, response, listitem, string: inputtext[])
{	
	if(response)
	{
		switch(listitem)
		{
			case 0:
			{
                if(iDrzavljanstvo[playerid] == 0) return SendClientMessage(playerid, col_red, "M >> "c_white"Vec si drzavljanin San Fierra!");
			 	iDrzavljanstvo[playerid] = 0;
                GivePlayerMoney(playerid, -200);
                ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 0, 0, 0, 0);
                SendClientMessage(playerid, col_server, "M >> "c_white"Uspesno si promenio drzavljanstvo!");

                new INI:File = INI_Open(Korisnici(playerid));
                INI_SetTag( File, "data" );

                INI_WriteInt(File, "Novac", GetPlayerMoney(playerid));
                INI_WriteInt(File, "Drzavljanstvo", iDrzavljanstvo[playerid]);           

                INI_Close( File );
                
				SendClientMessage(playerid, col_server, "Ti si drzavljanin San Fierra!" );
			}
			case 1:
			{
                if(iDrzavljanstvo[playerid] == 1) return SendClientMessage(playerid, col_red, "M >> "c_white"Vec si drzavljanin Los Santosa!");
			 	iDrzavljanstvo[playerid] = 1;
                GivePlayerMoney(playerid, -200);
                ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 0, 0, 0, 0);
                SendClientMessage(playerid, col_server, "M >> "c_white"Uspesno si promenio drzavljanstvo!");

                new INI:File = INI_Open(Korisnici(playerid));
                INI_SetTag( File, "data" );

                INI_WriteInt(File, "Novac", GetPlayerMoney(playerid));
                INI_WriteInt(File, "Drzavljanstvo", iDrzavljanstvo[playerid]);           

                INI_Close( File );
                
				SendClientMessage(playerid, col_server, "Ti si drzavljanin Los Santosa!" );
			}
			case 2:
			{
                if(iDrzavljanstvo[playerid] == 2) return SendClientMessage(playerid, col_red, "M >> "c_white"Vec si drzavljanin Las Venturasa!");
			 	iDrzavljanstvo[playerid] = 2;
                GivePlayerMoney(playerid, -200);
                ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 0, 0, 0, 0);
                SendClientMessage(playerid, col_server, "M >> "c_white"Uspesno si promenio drzavljanstvo!");

                new INI:File = INI_Open(Korisnici(playerid));
                INI_SetTag( File, "data" );

                INI_WriteInt(File, "Novac", GetPlayerMoney(playerid));
                INI_WriteInt(File, "Drzavljanstvo", iDrzavljanstvo[playerid]);           

                INI_Close( File );

				SendClientMessage(playerid, col_server, "Ti si drzavljanin Las Venturasa!" );
			}
		}
	}
    return Y_HOOKS_CONTINUE_RETURN_1;
}