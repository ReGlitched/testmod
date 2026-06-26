untyped

#if CLIENT
global function OnClientAnimEvent_Twinb
#endif

#if CLIENT
void function OnClientAnimEvent_Twinb( entity weapon, string name )
{
	GlobalClientEventHandler( weapon, name )

	if ( name == "shell_eject" )
	{
		thread DelayedCasingsSound( weapon, 0.6 )
	}
	else if ( name == "ammo_update_twinb" )
	{
		HACK_TwinbUpdateViewmodelAmmo(weapon)
	}
	else if ( name == "ammo_full_twinb" )
	{
		HACK_TwinbUpdateViewmodelAmmo( weapon, true )
	}
}

void function DelayedCasingsSound( entity weapon, float delayTime )
{
	Wait( delayTime )

	if ( !IsValid( weapon ) )
		return

	weapon.EmitWeaponSound( "weapon_mastiff_shelldrop" )
}

void function HACK_TwinbUpdateViewmodelAmmo( entity weapon, bool forceFull = false )
{
	if ( !IsClient() )
		return

	if ( !IsValid( weapon ) )
		return

	if ( !IsLocalViewPlayer( weapon.GetWeaponOwner() ) )
		return

	int bodyGroupCount = weapon.GetWeaponSettingInt( eWeaponVar.bodygroup_ammo_index_count )
	if ( bodyGroupCount <= 0 )
		return

	int rounds                = weapon.GetWeaponPrimaryClipCount()
	int maxRoundsForClipSize  = weapon.GetWeaponPrimaryClipCountMax()
	int maxRoundsForBodyGroup = (bodyGroupCount - 1)
	int maxRounds  = minint( maxRoundsForClipSize, maxRoundsForBodyGroup )
	if ( forceFull || ( rounds > maxRounds ) )
		rounds = maxRounds

	rounds += 1

	weapon.SetViewmodelAmmoModelIndex( rounds )
}
#endif