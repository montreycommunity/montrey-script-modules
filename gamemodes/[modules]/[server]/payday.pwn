//?=============================== Stock Includes =========================================//
#include <a_samp>
#include <ysilib\YSI_Storage\y_ini>
#include <ysilib\YSI_Coding\y_timers>
#include <ysilib\YSI_Coding\y_hooks>
#include <easy-dialog>

static
    iLevel[MAX_PLAYERS],                    //!Level igraca
    iRespekti[MAX_PLAYERS],                 //!Respekti igraca
    iNovac[MAX_PLAYERS],                    //!Novac igraca
    iPotrebnoRespekata[MAX_PLAYERS];        //!Potrebno Respekata za level up

//?=============================== Ucitavanje opet =========================================//
hook Account_Load(const playerid, const string: name[], const string: value[]);
hook Account_Load(const playerid, const string: name[], const string: value[])
{
    INI_Int("Level", iLevel[playerid]);
    INI_Int("Respekti", iRespekti[playerid]);
	INI_Int("PotrebnoRespekata", iPotrebnoRespekata[playerid]);
    INI_Int("Novac", iNovac[playerid]);

	return Y_HOOKS_CONTINUE_RETURN_1;
}
//?=============================== Tajmer na startu servera =========================================//
hook OnGameModeInit()
{
    SetTimer("PayDay", 3600000, true);

    return Y_HOOKS_CONTINUE_RETURN_1;
}
//!Cuvanje prilikom izlaza ili crasha
hook OnPlayerDisconnect(playerid, reason)
{
    new INI:File = INI_Open(Korisnici(playerid));
    INI_SetTag(File,"data");
    INI_WriteInt(File, "Level", GetPlayerScore(playerid));
    INI_WriteInt(File, "Respekti", iRespekti[playerid]);
    INI_WriteInt(File, "PotrebnoRespekata", iPotrebnoRespekata[playerid]);
    INI_WriteInt(File, "Novac", GetPlayerMoney(playerid));
    INI_Close(File);

    return Y_HOOKS_CONTINUE_RETURN_1;
}
//!PayDay
forward PayDay(playerid);
public PayDay(playerid)
{
    iRespekti[playerid]++;
    static string[256];
    format(string, sizeof(string), ""c_green"PAYDAY: "c_white"Primili ste platu u iznosu od $500! Ostatak plate vam je isplacen na racun!");
    SendClientMessage(playerid, -1, string);
    GivePlayerMoney(playerid, 500);
    format(string, sizeof(string), ""c_green"PAYDAY: "c_white"Sada imas %d/%d respekata!", iRespekti[playerid], iPotrebnoRespekata[playerid]);
    SendClientMessage(playerid, -1, string);
    if(iRespekti[playerid] >= iPotrebnoRespekata[playerid]) //!Ako je broj respekata veci nego potreban
    {
        iRespekti[playerid] = 0; //!Respekti se resetuju
        iLevel[playerid]++; //!Igrac dobija level up
        iPotrebnoRespekata[playerid] = iLevel[playerid]*3+4; //!Klasicna jednacina
        format(string, sizeof(string), ""c_green"PAYDAY: "c_white"Cestitamo sada si level %d! Potrebno ti je %d respekata!", iLevel[playerid], iPotrebnoRespekata[playerid]);
        SendClientMessage(playerid, -1, string);
    }
    new INI:File = INI_Open(Korisnici(playerid));
    INI_SetTag(File,"data");
    INI_WriteInt(File, "Level", GetPlayerScore(playerid));
    INI_WriteInt(File, "Respekti", iRespekti[playerid]);
    INI_WriteInt(File, "PotrebnoRespekata", iPotrebnoRespekata[playerid]);
    INI_WriteInt(File, "Novac", GetPlayerMoney(playerid));
    INI_Close(File);

    SetPlayerScore(playerid, iLevel[playerid]); //! Da refresha level u scoreboard kada se levelupuje lik

    return Y_HOOKS_CONTINUE_RETURN_1;
}
