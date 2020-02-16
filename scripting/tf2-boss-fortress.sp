//Pragma
#pragma semicolon 1
#pragma newdecls required

//Defines
#define PLUGIN_VERSION "1.0.0"

//Includes
#include <sourcemod>
#include <sdkhooks>
#include <tf2_stocks>
#include <tf2items>

//ConVars

//Globals

enum struct Bosses
{
	char name[64];
	char description[256];
	char model[PLATFORM_MAX_PATH];

	TFClassType class;

	int base_health;
	int health_multiplier;

	bool strip_weapons;
	
	int primary_weapon;
	int secondary_weapon;
	int melee_weapon;

	ArrayList attrs;
	StringMap attrs_values;

	void CreateBoss(char name[64], char description[256], char model[PLATFORM_MAX_PATH])
	{
		strcopy(this.name, sizeof(name), name);
		strcopy(this.description, sizeof(description), description);
		strcopy(this.model, sizeof(model), model);
	}

	void SetHealthValues(int base_health, int health_multiplier)
	{
		this.base_health = base_health;
		this.health_multiplier = health_multiplier;
	}

	void SetWeaponValues(bool strip_weapons, int primary_weapon, int secondary_weapon, int melee_weapon)
	{
		this.strip_weapons = strip_weapons;
		
		this.primary_weapon = primary_weapon;
		this.secondary_weapon = secondary_weapon;
		this.melee_weapon = melee_weapon;
	}

	void AddAttr(int id, int value)
	{
		if (this.attrs == null)
			this.attrs = new ArrayList();
		
		if (this.attrs_values == null)
			this.attrs_values = new StringMap();
		
		char sID[16];
		IntToString(id, sID, sizeof(sID));

		if (this.attrs.FindValue(id) == -1)
			this.attrs.Push(id);
		
		this.attrs_values.SetValue(sID, value);
	}

	void RemoveAttr(int id)
	{
		if (this.attrs == null || this.attrs_values == null)
			return;
		
		int index = this.attrs.FindValue(id);
		
		if (index != -1)
			this.attrs.Erase(index);
		
		char sID[16];
		IntToString(id, sID, sizeof(sID));

		this.attrs_values.Remove(sID);
	}

	void Reset()
	{
		this.name[0] = '\0';
		this.description[0] = '\0';
		this.model[0] = '\0';

		this.class = TFClass_Unknown;

		this.base_health = -1;
		this.health_multiplier = -1;

		this.strip_weapons = false;

		this.primary_weapon = -1;
		this.secondary_weapon = -1;
		this.melee_weapon = -1;

		delete this.attrs;
		delete this.attrs_values;
	}
}

Bosses g_Bosses[32];
int g_BossCount;

public Plugin myinfo = 
{
	name = "[TF2] Boss Fortress", 
	author = "Keith Warren (Drixevel)", 
	description = "A clean VSH-esk gamemode.",
	version = PLUGIN_VERSION, 
	url = "https://github.com/drixevel"
};

public void OnPluginStart()
{
	ParseBosses();
}

void ParseBosses()
{
	for (int i = 0; i < g_BossCount; i++)
		g_Bosses[i].Reset();
	
	g_BossCount = 0;

	//Saxton Hale
	g_Bosses[g_BossCount].CreateBoss("Saxton Hale", "Make Mann co. great again!", "", TFClass_Soldier);
	g_BossCount++;
}