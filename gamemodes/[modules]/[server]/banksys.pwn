//?=============================== Stock Includes =========================================//
#include <a_samp>
#include <ysilib\YSI_Storage\y_ini>
#include <ysilib\YSI_Visual\y_commands>
#include <ysilib\YSI_Coding\y_hooks>
#include <streamer>

//* Dodati kredit i hipoteku i sistem gotov!

//?=============================== Chekpointi =========================================//
//!Chekpointi za banku
new CP_UlazuBanku, CP_IzlazizBanke, CP_3Sprat, CP_15Sprat, CP_19Sprat;

//!3D text labeli
new Text3D:Text_Banka;

static
    iBankovniRacun[MAX_PLAYERS],     //!Dal igrac poseduje bankovni racun
	iNovac[MAX_PLAYERS],			 //!Novac igraca
	iNovacuBanci[MAX_PLAYERS],		 //!Novac igraca u banci
    iKarticaPin[MAX_PLAYERS],    	 //!Pin kartice
	iLicnaKarta[MAX_PLAYERS];        //!Provera za licnu kartu

//!Aktori
new AktorPrizemlje, ActorOpenRacuna, AktorHipoteka;
//!Opet ucitavanje novih stvari i starih
hook Account_Load(const playerid, const string: name[], const string: value[]);
hook Account_Load(const playerid, const string: name[], const string: value[])
{
	INI_Int("BankovniRacun", iBankovniRacun[playerid]);
    INI_Int("KarticaPin", iKarticaPin[playerid]);
	INI_Int("NovacuBanci", iNovacuBanci[playerid]);
    INI_Int("Novac", iNovac[playerid]);
	INI_Int("LicnaKarta", iLicnaKarta[playerid]);

    return Y_HOOKS_CONTINUE_RETURN_1;
}
//!Save player opcija zbog target id
SavePlayer(playerid)
{
    new INI:File = INI_Open(Korisnici(playerid));
    INI_SetTag( File, "data" );

	INI_WriteInt(File, "LicnaKarta", iLicnaKarta[playerid]);
	INI_WriteInt(File, "BankovniRacun", iBankovniRacun[playerid]);
	INI_WriteInt(File, "NovacuBanci", iNovacuBanci[playerid]);
    INI_WriteInt(File, "Novac", GetPlayerMoney(playerid));
    INI_WriteInt(File, "KarticaPin", iKarticaPin[playerid]);           

    INI_Close( File );	
	return true;
}

//?=============================== Ucitavanje =========================================//
hook OnGameModeInit()
{
	//! Aktori 
	AktorPrizemlje = CreateActor(71, 1792.7607,-1302.4524,13.5277,0.1496);
	ActorOpenRacuna = CreateActor(141, 1831.5023,-1272.4097,22.2109,139.4119);
	AktorHipoteka = CreateActor(148, 1816.2584,-1274.6991,22.2109,216.5893);
	ApplyActorAnimation(AktorPrizemlje, "DEALER", "DEALER_IDLE", 4.1, 1, 0, 0, 0, 0);
	ApplyActorAnimation(ActorOpenRacuna, "GANGS", "prtial_gngtlkA", 4.1, 1, 0, 0, 0, 0);
	ApplyActorAnimation(AktorHipoteka, "GANGS", "prtial_gngtlkA", 4.1, 1, 0, 0, 0, 0);
	//!CP
    CP_UlazuBanku = CreateDynamicCP(1792.6542,-1306.0980,13.7764, 1, -1, -1, -1, 200);
    CP_IzlazizBanke = CreateDynamicCP(1786.4974,-1304.6136,22.1869, 1, -1, -1, -1, 200);
	CP_3Sprat = CreateDynamicCP(1786.5707,-1304.6349,33.1169, 1, -1, -1, -1, 200);
	CP_15Sprat = CreateDynamicCP(1786.6957,-1305.0073,98.4870, 1, -1, -1, -1, 200);
	CP_19Sprat = CreateDynamicCP(1786.5061,-1304.5850,120.2471, 1, -1, -1, -1, 200);
    
    Text_Banka = CreateDynamic3DTextLabel("Montrey Banka", col_white, 1792.6542,-1306.0980,13.7764, 30.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 200);
	return 1;
}
//?=============================== Chekpointi Destroy =========================================//
hook OnGameModeExit()
{
    DestroyDynamicCP(CP_UlazuBanku);
    DestroyDynamicCP(CP_IzlazizBanke);
	DestroyDynamicCP(CP_3Sprat);
	DestroyDynamicCP(CP_15Sprat);
	DestroyDynamicCP(CP_19Sprat);
    
    DestroyDynamic3DTextLabel(Text_Banka);
}
//?=============================== Map Icon Set =========================================//
hook OnPlayerSpawn(playerid)
{
    SetPlayerMapIcon(playerid, 1, 1786.6084,-1299.6708,13.4351, 52, 0, MAPICON_GLOBAL); // Ikonica banke na mapi
}
//?=============================== Chekpointi Akcije =========================================//
hook OnPlayerEnterDynamicCP(playerid, checkpointid)
{
    if(checkpointid == CP_UlazuBanku) // Ulaz u banku cp
	{
		new sati, minuti;
		GetPlayerTime(playerid, sati, minuti);
		if(sati < 7) return SendClientMessage(playerid, col_red, "M >> "c_white"Trenutno je noc i glavna filijala ne radi!");
		SetPlayerPos(playerid, 1786.8237,-1299.6392,22.2109); // Pozicija igraca
		SetPlayerFacingAngle(playerid, 270);
		RemovePlayerMapIcon(playerid, 1); // Uklanja ikonicu na mapi.
	}
    if(checkpointid == CP_IzlazizBanke) // Izlaz iz banke cp
	{
		Dialog_Show(playerid, "dialog_bankalift", DIALOG_STYLE_LIST,
		""c_server"M >> "c_white"Lift Banka",
		"Banka\n3 Sprat\n15 Sprat\n19 Sprat\nGaraza\nIzlaz",
		"Odaberi", "Izlaz"
		);
	}
    if(checkpointid == CP_3Sprat) // Izlaz iz banke cp
	{
		Dialog_Show(playerid, "dialog_bankalift", DIALOG_STYLE_LIST,
		""c_server"M >> "c_white"Lift Banka",
		"Banka\n3 Sprat\n15 Sprat\n19 Sprat\nGaraza\nIzlaz",
		"Odaberi", "Izlaz"
		);
	}
    if(checkpointid == CP_15Sprat) // Izlaz iz banke cp
	{
		Dialog_Show(playerid, "dialog_bankalift", DIALOG_STYLE_LIST,
		""c_server"M >> "c_white"Lift Banka",
		"Banka\n3 Sprat\n15 Sprat\n19 Sprat\nGaraza\nIzlaz",
		"Odaberi", "Izlaz"
		);
	}
    if(checkpointid == CP_19Sprat) // Izlaz iz banke cp
	{
		Dialog_Show(playerid, "dialog_bankalift", DIALOG_STYLE_LIST,
		""c_server"M >> "c_white"Lift Banka",
		"Banka\n3 Sprat\n15 Sprat\n19 Sprat\nGaraza\nIzlaz",
		"Odaberi", "Izlaz"
		);
	}
	return Y_HOOKS_CONTINUE_RETURN_1;
}

Dialog: dialog_bankalift(const playerid, response, listitem, string: inputtext[])
{		
	if(response)
	{
		switch(listitem)
		{
			case 0:
			{
				if(IsPlayerInRangeOfPoint(playerid, 1.0, 1786.4974,-1304.6136,22.1869)) // Provera sprata po poziciji chekpointa
					return SendClientMessage(playerid, col_red, "M >> "c_white"Vec si na ovom spratu!");
					
			 	SetPlayerPos(playerid, 1786.8237,-1299.6392,22.2109); // Pozicija igraca
				SetPlayerFacingAngle(playerid, 315.01);
				SendClientMessage(playerid, col_green, "BANKA >> "c_white"Na 1 si spratu, ovo je sprat za klijente!");
			}
			case 1:
			{
				if(IsPlayerInRangeOfPoint(playerid, 1.0, 1786.5707,-1304.6349,33.1169)) // Provera sprata po poziciji chekpointa
					return SendClientMessage(playerid, col_red, "M >> "c_white"Vec si na ovom spratu!");
					
			 	SetPlayerPos(playerid, 1786.6571,-1299.0269,33.1250); // Pozicija igraca
				SetPlayerFacingAngle(playerid, 315.01);
				SendClientMessage(playerid, col_green, "BANKA >> "c_white"Na 3 si spratu, ovo je sprat gde su zaposleni!");
			}
			case 2:
			{
				if(IsPlayerInRangeOfPoint(playerid, 1.0, 1786.6957,-1305.0073,98.4870))  // Provera sprata po poziciji chekpointa
					return SendClientMessage(playerid, col_red, "M >> "c_white"Vec si na ovom spratu!");
					
			 	SetPlayerPos(playerid, 1787.1149,-1299.4758,98.5000); // Pozicija igraca
				SetPlayerFacingAngle(playerid, 315.01);
				SendClientMessage(playerid, col_green, "BANKA >> "c_white"Na 15 si spratu, ovo je sprat gde je obezbedjenje!");
			}
			case 3:
			{
				if(IsPlayerInRangeOfPoint(playerid, 1.0, 1786.5061,-1304.5850,120.2471)) // Provera sprata po poziciji chekpointa
					return SendClientMessage(playerid, col_red, "M >> "c_white"Vec si na ovom spratu!");

			 	SetPlayerPos(playerid, 1786.3268,-1299.2252,120.2656); // Pozicija igraca
				SetPlayerFacingAngle(playerid, 315.01);
				SendClientMessage(playerid, col_green, "BANKA >> "c_white"Na 19 si spratu, upao si u sef!");
			}
			case 4:
			{
				SendClientMessage(playerid, col_green, "BANKA >> "c_white"Trenutno nedostupno");
			}
			case 5:
			{
			 	SetPlayerPos(playerid, 1796.9551,-1306.2042,13.6524); // Pozicija igraca
				SetPlayerFacingAngle(playerid, 315.01);
				SetPlayerMapIcon(playerid, 1, 1786.4974,-1304.6136,22.1869, 52, 0, MAPICON_GLOBAL); // Ikonica banke na mapi
			}
		}
	}
	return Y_HOOKS_CONTINUE_RETURN_1;
}

//?=============================== Komande Banka =========================================//

YCMD:otvoriracun(playerid, params[], help)
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1829.6395,-1274.9326,22.2109)) return SendClientMessage(playerid, col_red, "M >> "c_white"Morate biti u banci!");
    if(iLicnaKarta[playerid] == 0) return SendClientMessage(playerid, col_red, "M >> "c_white"Morate imati licnu kartu!");
	if(iBankovniRacun[playerid] == 1) return SendClientMessage(playerid, col_red, "M >> "c_white"Vec imate racun u nasoj banci!");

	Dialog_Show(playerid, "dialog_kartica", DIALOG_STYLE_LIST,
		"Odaberi Bankovnu Karticu",
		"Master Card\nVisa\nAmerican Express\nMontrey Diamond",
		"Odaberi", "Izlaz"
	);

	return Y_HOOKS_CONTINUE_RETURN_1;

}

Dialog: dialog_kartica(const playerid, response, listitem, string: inputtext[])
{	
	new ranpin = 1000 + random(9999);
	new stringic[128];
	if(response)
	{
		switch(listitem)
		{
			case 0:
			{
				iKarticaPin[playerid] = ranpin;
			 	iBankovniRacun[playerid] = 1;
                iNovacuBanci[playerid] = 100;
                ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 0, 0, 0, 0);
				format(stringic, sizeof(stringic), "BANKA >> "c_white"Uspesno si otvorio racun u banci.\nTvoj pin od kartice je >> %i, zapamti ga dobro!", iKarticaPin[playerid]);
                SendClientMessage(playerid, col_server, stringic);
				SendClientMessage(playerid, col_server, "BANKA >> "c_white"Dobio si 100$ novcane pomoci od predsednika Los Santosa!");

                new INI:File = INI_Open(Korisnici(playerid));
                INI_SetTag( File, "data" );

				INI_WriteInt(File, "BankovniRacun", iBankovniRacun[playerid]);
				INI_WriteInt(File, "NovacuBanci", iNovacuBanci[playerid]);
                INI_WriteInt(File, "Novac", GetPlayerMoney(playerid));
                INI_WriteInt(File, "KarticaPin", iKarticaPin[playerid]);           

                INI_Close( File );
			}
			case 1:
			{
				iKarticaPin[playerid] = ranpin;
			 	iBankovniRacun[playerid] = 1;
                iNovacuBanci[playerid] = 100;
                ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 0, 0, 0, 0);
				format(stringic, sizeof(stringic), "BANKA >> "c_white"Uspesno si otvorio racun u banci.\nTvoj pin od kartice je >> %i, zapamti ga dobro!", iKarticaPin[playerid]);
                SendClientMessage(playerid, col_server, stringic);
				SendClientMessage(playerid, col_server, "BANKA >> "c_white"Dobio si 100$ novcane pomoci od predsednika Los Santosa!");

                new INI:File = INI_Open(Korisnici(playerid));
                INI_SetTag( File, "data" );

				INI_WriteInt(File, "BankovniRacun", iBankovniRacun[playerid]);
				INI_WriteInt(File, "NovacuBanci", iNovacuBanci[playerid]);
                INI_WriteInt(File, "Novac", GetPlayerMoney(playerid));
                INI_WriteInt(File, "KarticaPin", iKarticaPin[playerid]);           

                INI_Close( File );
			}
			case 2:
			{
				iKarticaPin[playerid] = ranpin;
			 	iBankovniRacun[playerid] = 1;
                iNovacuBanci[playerid] = 100;
                ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 0, 0, 0, 0);
				format(stringic, sizeof(stringic), "BANKA >> "c_white"Uspesno si otvorio racun u banci.\nTvoj pin od kartice je >> %i, zapamti ga dobro!", iKarticaPin[playerid]);
                SendClientMessage(playerid, col_server, stringic);
				SendClientMessage(playerid, col_server, "BANKA >> "c_white"Dobio si 100$ novcane pomoci od predsednika Los Santosa!");

                new INI:File = INI_Open(Korisnici(playerid));
                INI_SetTag( File, "data" );

				INI_WriteInt(File, "BankovniRacun", iBankovniRacun[playerid]);
				INI_WriteInt(File, "NovacuBanci", iNovacuBanci[playerid]);
                INI_WriteInt(File, "Novac", GetPlayerMoney(playerid));
                INI_WriteInt(File, "KarticaPin", iKarticaPin[playerid]);           

                INI_Close( File );
			}
			case 3:
			{
				iKarticaPin[playerid] = ranpin;
			 	iBankovniRacun[playerid] = 1;
                iNovacuBanci[playerid] = 500;
                ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 0, 0, 0, 0);
				format(stringic, sizeof(stringic), "BANKA >> "c_white"Uspesno si otvorio racun u banci.\nTvoj pin od kartice je >> %i, zapamti ga dobro!", iKarticaPin[playerid]);
                SendClientMessage(playerid, col_server, stringic);
				SendClientMessage(playerid, col_server, "BANKA >> "c_white"Dobio si 500$ novcane pomoci kao nas premium korisnik!");

                new INI:File = INI_Open(Korisnici(playerid));
                INI_SetTag( File, "data" );

				INI_WriteInt(File, "BankovniRacun", iBankovniRacun[playerid]);
				INI_WriteInt(File, "NovacuBanci", iNovacuBanci[playerid]);
                INI_WriteInt(File, "Novac", GetPlayerMoney(playerid));
                INI_WriteInt(File, "KarticaPin", iKarticaPin[playerid]);           

                INI_Close( File );
			}
		}
	}
    return Y_HOOKS_CONTINUE_RETURN_1;
}

//! Salter u banci komande
YCMD:blagajna(playerid, params[], help)
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1813.6713,-1290.7893,22.2109) && !IsPlayerInRangeOfPoint(playerid, 3.0, 1813.6687,-1298.4092,22.2109)) 
		return SendClientMessage(playerid, col_red, "M >> "c_white"Morate biti na blagajni u banci!");
	if(iBankovniRacun[playerid] == 0) return SendClientMessage(playerid, col_red, "M >> "c_white"Nemate racun u nasoj banci!");

	Dialog_Show(playerid, "dialog_blagajna", DIALOG_STYLE_LIST,
		"Montrey Banka",
		"Ostavi\nPodigni\nTransfer Novca\nKredit\nBalans\nPromena Pin Koda",
		"Odaberi", "Izlaz"
	);

	return Y_HOOKS_CONTINUE_RETURN_1;

}

Dialog: dialog_blagajna(const playerid, response, listitem, string: inputtext[])
{	
	new ranpin = 1000 + random(9999);
	if(response)
	{
		switch(listitem)
		{
			case 0:
			{
				Dialog_Show(playerid, "dialog_deposit", DIALOG_STYLE_INPUT,
				"Montrey Banka",
				"%s, Napisi kolicinu novca koju zelis da ostavis!",
				"Odaberi", "Nazad", ReturnPlayerName(playerid)
			);
			}
			case 1:
			{
				Dialog_Show(playerid, "dialog_withdraw", DIALOG_STYLE_INPUT,
				"Montrey Banka",
				"%s, Napisi kolicinu novca koju zelis da podignes\nTvoj trenutni novac u banci je >> %d $!",
				"Odaberi", "Nazad", ReturnPlayerName(playerid), iNovacuBanci[playerid]
			);
			}
			case 2:
			{
				Dialog_Show(playerid, "dialog_transfer", DIALOG_STYLE_INPUT,
				"Montrey Banka",
				"%s, unesi id igraca i kolicinu novca koju zelis prebaciti!",
				"Odaberi", "Nazad", ReturnPlayerName(playerid)
			);
			}
			case 3:
			{
				SendClientMessage(playerid, col_green, "BANKA >> "c_white"Opcija kredita jos nije moguca!");
			}
			case 4:
			{
				Dialog_Show(playerid, "dialog_balans", DIALOG_STYLE_MSGBOX,
				"Montrey Banka",
				""c_white"%s, Vase treenutno stanje na racunu je >> "c_server"%d $!",
				"U redu", "", ReturnPlayerName(playerid), iNovacuBanci[playerid]
				);
			}
			case 5:
			{
				iKarticaPin[playerid] = ranpin;
				Dialog_Show(playerid, "dialog_balans", DIALOG_STYLE_MSGBOX,
				"Montrey Banka",
				""c_white"%s, Vase novi pin od racuna je >> "c_server"%i, zapamtite ga dobro!",
				"U redu", "", ReturnPlayerName(playerid), iKarticaPin[playerid]
				);

                new INI:File = INI_Open(Korisnici(playerid));
                INI_SetTag( File, "data" );

                INI_WriteInt(File, "KarticaPin", iKarticaPin[playerid]);           

                INI_Close( File );
			}
		}
	}
    return Y_HOOKS_CONTINUE_RETURN_1;
}

//! Ostavljanje Novca
Dialog: dialog_deposit(const playerid, response, listitem, string: inputtext[])
{
	if(!response) 
		return Dialog_Show(playerid, "dialog_blagajna", DIALOG_STYLE_LIST,
		"Montrey Banka",
		"Ostavi\nPodigni\nTransfer Novca\nKredit\nBalans\nPromena Pin Koda",
		"Odaberi", "Izlaz"
	);
	new stringic[128];
	if(GetPlayerMoney(playerid) < strval(inputtext)) return SendClientMessage(playerid, col_red, "M >> "c_white"Nemas toliko novca kod sebe!");
	new novac1 = strval(inputtext);
	iNovacuBanci[playerid] += strval(inputtext);
	format(stringic, sizeof(stringic), "BANKA >> "c_white"Ostavili ste %d$ na vas racun! Vase novo stanje je %d$!", novac1, iNovacuBanci[playerid]);
    SendClientMessage(playerid, col_green, stringic);
	ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 0, 0, 0, 0);
	GivePlayerMoney(playerid, -strval(inputtext));

    new INI:File = INI_Open(Korisnici(playerid));
    INI_SetTag( File, "data" );

	INI_WriteInt(File, "NovacuBanci", iNovacuBanci[playerid]);
    INI_WriteInt(File, "Novac", GetPlayerMoney(playerid));       

    INI_Close( File );

	return Y_HOOKS_CONTINUE_RETURN_1;
}
//! Dizanje Kesa
Dialog: dialog_withdraw(const playerid, response, listitem, string: inputtext[])
{
	if(!response) 
		return Dialog_Show(playerid, "dialog_blagajna", DIALOG_STYLE_LIST,
		"Montrey Banka",
		"Ostavi\nPodigni\nTransfer Novca\nKredit\nBalans\nPromena Pin Koda",
		"Odaberi", "Izlaz"
	);
	new stringic[128];
	if(iNovacuBanci[playerid] < strval(inputtext)) return SendClientMessage(playerid, col_red, "M >> "c_white"Nemas toliko novca na racunu!");
	new novac1 = strval(inputtext);
	iNovacuBanci[playerid] -= strval(inputtext);
	format(stringic, sizeof(stringic), "BANKA >> "c_white"Uzeli ste %d$ sa vaseg racuna! Vase novo stanje je %d$!", novac1, iNovacuBanci[playerid]);
    SendClientMessage(playerid, col_green, stringic);
	ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 0, 0, 0, 0);
	GivePlayerMoney(playerid, strval(inputtext));	

    new INI:File = INI_Open(Korisnici(playerid));
    INI_SetTag( File, "data" );

	INI_WriteInt(File, "NovacuBanci", iNovacuBanci[playerid]);
    INI_WriteInt(File, "Novac", GetPlayerMoney(playerid));

    INI_Close( File );

	return Y_HOOKS_CONTINUE_RETURN_1;
}

//! Transfer Kesa
Dialog: dialog_transfer(const playerid, response, listitem, string: inputtext[])
{
	if(!response) 
		return Dialog_Show(playerid, "dialog_blagajna", DIALOG_STYLE_LIST,
		"Montrey Banka",
		"Ostavi\nPodigni\nTransfer Novca\nKredit\nBalans\nPromena Pin Koda",
		"Odaberi", "Izlaz"
	);
    new id, cashdeposit;
	if(sscanf(inputtext, "ui", id, cashdeposit)) return Dialog_Show(playerid, "dialog_transfer", DIALOG_STYLE_INPUT,
														"Montrey Banka",
														"%s, unesi id igraca i kolicinu novca koju zelis prebaciti!",
														"Odaberi", "Nazad", ReturnPlayerName(playerid)
														);

	if( cashdeposit > iNovacuBanci[playerid] || cashdeposit < 1 ) return SendClientMessage( playerid, col_red, "M >> "c_white"Nemate toliko novaca");
	if( id == INVALID_PLAYER_ID ) return SendClientMessage(playerid, col_red, "M >> "c_white"Pogresan ID Igraca");
    if(!iBankovniRacun[id]) return SendClientMessage(playerid, col_red, "M >> "c_white"Taj igrac nema racun u banci!");

	iNovacuBanci[playerid] -= cashdeposit;
    iNovacuBanci[id] += cashdeposit;

	new INI:File = INI_Open(Korisnici(playerid));
    INI_SetTag( File, "data" );

	INI_WriteInt(File, "NovacuBanci", iNovacuBanci[playerid]);

    INI_Close( File );

    SavePlayer(playerid); SavePlayer(id);
	PlayerPlaySound( playerid, 1052, 0.0, 0.0, 0.0);

	SendClientMessageEx(playerid, col_green, "TRANSFER: "c_white"Poslao si %d$ na %s-ov racun.", cashdeposit, ReturnPlayerName( id ), id );
	SendClientMessageEx(id, col_green, "TRANSFER: "c_white"Primio si %d$ na svoj racun od %s.", cashdeposit, ReturnPlayerName( playerid ), playerid );

	return Y_HOOKS_CONTINUE_RETURN_1;
}

stock SendClientMessageEx(playerid, color, const str[], {Float,_}:...) {
	static
	    args,
	    start,
	    end,
	    string[144]
	;
	#emit LOAD.S.pri 8
	#emit STOR.pri args

	if(args > 12)
	{
		#emit ADDR.pri str
		#emit STOR.pri start

	    for (end = start + (args - 12); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 144
		#emit PUSH.C string
		#emit PUSH.C args
		#emit SYSREQ.C format

		SendClientMessage(playerid, color, string);

		#emit LCTRL 5
		#emit SCTRL 4
		#emit RETN
	}
	return SendClientMessage(playerid, color, str);
}