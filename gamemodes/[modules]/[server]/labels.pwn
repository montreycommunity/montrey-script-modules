//?=============================== Stock Includes =========================================//

#include <a_samp>
#include "[modules]/[server]/colors.pwn"

//?=============================== Forward za dinamicne labele =========================================//
forward Create3DandP(const text[], Float:vXU, Float:vYU, Float:vZU, vInt, vVW, pickupid, Float:radius);
public Create3DandP(const text[], Float:vXU, Float:vYU, Float:vZU, vInt, vVW, pickupid, Float:radius)
{
	CreateDynamic3DTextLabel(text, 0x0059FFAA, vXU, vYU, vZU, radius, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, vVW, vInt, -1, 20.0);
	CreateDynamicPickup(pickupid, 1, vXU, vYU, vZU, vVW, vInt);
}

//?=============================== Ucitavanje labela prilikom starta =========================================//
hook OnGameModeInit()
{
    CreatePickupsAnd3Ds();
}
//?=============================== Lista labela =========================================//
CreatePickupsAnd3Ds()
{
    Create3DandP(""c_server"[ Opstina ]\n"c_white"'ENTER' za ulaz", 1477.0828,-1818.7952,15.3383, -1, -1, 19133, 2.0); // Opstina ulaz
    Create3DandP(""c_server"[ Salter ]\n"c_white"'/izvadilicnu'\n'/promenidrzavljanstvo'", 361.2740,171.0686,1008.3828, -1, -1, 1239, 2.0); //licna
    Create3DandP(""c_server"[ Blagajna ]\n"c_white"'/blagajna'", 1813.6713,-1290.7893,22.2109, -1, -1, 1212, 2.0); //salter1 Banka
    Create3DandP(""c_server"[ Blagajna ]\n"c_white"'/blagajna'", 1813.6687,-1298.4092,22.2109, -1, -1, 1212, 2.0); //salter2 Banka
    Create3DandP(""c_server"[ Racun ]\n"c_white"'/otvoriracun'", 1829.6395,-1274.9326,22.2109, -1, -1, 1212, 2.0); //racun open Banka
    Create3DandP(""c_server"[ Hipoteka ]\n"c_white"'Y' za pogodnosti hipoteke", 1818.0872,-1276.6302,22.2109, -1, -1, 1239, 2.0); //Banka Hipoteka
    Create3DandP(""c_server"[ Cekaonica ]\n"c_white"'Y' da sednes", 1830.1454,-1283.1907,22.7549, -1, -1, 1239, 2.0); //Banka Sedalo1
    Create3DandP(""c_server"[ Cekaonica ]\n"c_white"'Y' da sednes", 1800.4771,-1309.0106,22.7549, -1, -1, 1239, 2.0); //Banka Sedalo2
    Create3DandP(""c_server"[ Radno Vreme ]\n"c_white"'07-23'", 1792.5695,-1300.4518,13.4612, -1, -1, 1239, 2.0); //Banka Radno Vreme
    Create3DandP(""c_server"[ Biro Rada ]\n"c_white"'ENTER' za ulaz", 1467.5178,-1011.0197,26.8438, -1, -1, 19133, 2.0); //Biro Desni Ulaz
    Create3DandP(""c_server"[ Biro Rada ]\n"c_white"'ENTER' za ulaz", 1457.2957,-1011.6390,26.8438, -1, -1, 19133, 2.0); //Biro levi ulaz
    
    return Y_HOOKS_CONTINUE_RETURN_1;
}
//?=============================== Sta se desi kad igrac pritisne key =========================================//
hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(newkeys & KEY_SECONDARY_ATTACK)
    {
        if(IsPlayerInRangeOfPoint(playerid, 3.0, 1477.0828, -1818.7952, 15.3383)) //!OpstinaLS
        {
            SetPlayerInterior(playerid, 3);
            SetPlayerPos(playerid, 389.7137, 173.6886, 1008.3828);
            SetCameraBehindPlayer(playerid);
        }
        if(IsPlayerInRangeOfPoint(playerid, 3.0, 389.7137, 173.6886, 1008.3828)) //!OpstinaSF Izlaz
        {
            SetPlayerInterior(playerid, 0);
            SetPlayerPos(playerid, 1477.0828, -1818.7952, 15.3383);
            SetCameraBehindPlayer(playerid);
        }
        if(IsPlayerInRangeOfPoint(playerid, 1.0, 1467.5178,-1011.0197,26.8438)) //!Biro Rada Ulaz
        {
            SetPlayerPos(playerid, 1467.1675,-1008.0137,26.8850);
            SetCameraBehindPlayer(playerid);     
        }     
        if(IsPlayerInRangeOfPoint(playerid, 1.0, 1457.2957,-1011.6390,26.8438)) //!Biro Rada Ulaz 2
        {
            SetPlayerPos(playerid, 1457.1305,-1007.5593,26.8850);
            SetCameraBehindPlayer(playerid);
        }
        if(IsPlayerInRangeOfPoint(playerid, 1.0, 1467.1675,-1008.0137,26.8850)) //!Biro Rada Izlaz
        {
            SetPlayerPos(playerid, 1467.5178,-1011.0197,26.8438);
            SetCameraBehindPlayer(playerid);     
        }     
        if(IsPlayerInRangeOfPoint(playerid, 1.0, 1457.1305,-1007.5593,26.8850)) //!Biro Rada Izlaz 2
        {
            SetPlayerPos(playerid, 1457.2957,-1011.6390,26.8438);
            SetCameraBehindPlayer(playerid);
        } 
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}