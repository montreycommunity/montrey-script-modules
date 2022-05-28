#include <a_samp>
#include <ysilib\YSI_Storage\y_ini>
#include <ysilib\YSI_Coding\y_timers>
#include <ysilib\YSI_Visual\y_commands>
#include <ysilib\YSI_Coding\y_hooks>
#include <ysilib\YSI_Data\y_foreach>
#include <sscanf\sscanf2>
#include <easy-dialog>
#include <streamer>

// functions;
stock IsVehicleBicycle(m)
{
    if (m == 481 || m == 509 || m == 510) return true;
    
    return false;
}

// hooks;
hook OnVehicleSpawn(vehicleid)
{
    // Gasenje motora na vozilu, odnosno paljenje ako je u pitanju bicikl + gasenje svetala
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    if (IsVehicleBicycle(GetVehicleModel(vehicleid))) 
    {
        SetVehicleParamsEx(vehicleid, 1, 0, 0, doors, bonnet, boot, objective);
    }
    else 
    {
        SetVehicleParamsEx(vehicleid, 0, 0, 0, doors, bonnet, boot, objective);
    }

    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(newstate == PLAYER_STATE_DRIVER)
    {
        SendClientMessage(playerid, -1, "Da upalite motor koristite tipku 'N'");
    }

    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerExitVehicle(playerid, vehicleid)
{
    new engine,
        lights,
        alarm,
        doors,
        bonnet,
        boot,
        objective;

    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    SetVehicleParamsEx(vehicleid, VEHICLE_PARAMS_OFF, lights, alarm, doors, bonnet, boot, objective);

    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnVehicleCreated(vehicleid)
{
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    if (IsVehicleBicycle(GetVehicleModel(vehicleid))) 
    {
        SetVehicleParamsEx(vehicleid, 1, VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF, doors, bonnet, boot, objective);
    }
    else 
    {
        SetVehicleParamsEx(vehicleid, VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF, doors, bonnet, boot, objective);
    }
    
    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    {
        if(newkeys & KEY_NO)
        {
            new veh = GetPlayerVehicleID(playerid),
                engine,
                lights,
                alarm,
                doors,
                bonnet,
                boot,
                objective;
            
            if(IsVehicleBicycle(GetVehicleModel(veh)))
            {
                return true;
            }
            
            GetVehicleParamsEx(veh, engine, lights, alarm, doors, bonnet, boot, objective);

            if(engine == VEHICLE_PARAMS_OFF)
            {
                SetVehicleParamsEx(veh, VEHICLE_PARAMS_ON, lights, alarm, doors, bonnet, boot, objective);
            }
            else
            {
                SetVehicleParamsEx(veh, VEHICLE_PARAMS_OFF, lights, alarm, doors, bonnet, boot, objective);
            }
            new str[60];
            format(str, sizeof(str), "%s si motor.", (engine == VEHICLE_PARAMS_OFF) ? "Upalio" : "Ugasio");
            SendClientMessage(playerid, -1, str);

            return true;
        }
    }

    return Y_HOOKS_CONTINUE_RETURN_1;
}