void() precache_chas_monsters = {

	// Ogre

	precache_model ("progs/ogre.mdl");
	precache_model ("progs/h_ogre.mdl");
	precache_model ("progs/grenade.mdl");

	precache_sound ("ogre/ogdrag.wav");
	precache_sound ("ogre/ogdth.wav");
	precache_sound ("ogre/ogidle.wav");
	precache_sound ("ogre/ogidle2.wav");
	precache_sound ("ogre/ogpain1.wav");
	precache_sound ("ogre/ogsawatk.wav");
	precache_sound ("ogre/ogwake.wav");


	// Enforcer

	precache_model2 ("progs/enforcer.mdl");
	precache_model2 ("progs/h_mega.mdl");
	precache_model2 ("progs/laser.mdl");

	precache_sound2 ("enforcer/death1.wav");
	precache_sound2 ("enforcer/enfire.wav");
	precache_sound2 ("enforcer/enfstop.wav");
	precache_sound2 ("enforcer/idle1.wav");
	precache_sound2 ("enforcer/pain1.wav");
	precache_sound2 ("enforcer/pain2.wav");
	precache_sound2 ("enforcer/sight1.wav");
	precache_sound2 ("enforcer/sight2.wav");
	precache_sound2 ("enforcer/sight3.wav");
	precache_sound2 ("enforcer/sight4.wav");


	// Shambler

	precache_model ("progs/shambler.mdl");
	precache_model ("progs/s_light.mdl");
	precache_model ("progs/h_shams.mdl");
	precache_model ("progs/bolt.mdl");
	
	precache_sound ("shambler/sattck1.wav");
	precache_sound ("shambler/sboom.wav");
	precache_sound ("shambler/sdeath.wav");
	precache_sound ("shambler/shurt2.wav");
	precache_sound ("shambler/sidle.wav");
	precache_sound ("shambler/ssight.wav");
	precache_sound ("shambler/melee1.wav");
	precache_sound ("shambler/melee2.wav");
	precache_sound ("shambler/smack.wav");

}
/*
void() chasmonster_start_go =
{
	self.origin_z = self.origin_z + 1;	// raise off floor a bit
	droptofloor();
	
	if (!walkmove(0,0))
	{
		dprint ("chasmonster in wall at: ");
		dprint (vtos(self.origin));
		dprint ("\n");
	}
	
	self.takedamage = DAMAGE_AIM;

	self.ideal_yaw = self.angles * '0 1 0';

	if (!self.yaw_speed)
		self.yaw_speed = 20;

	self.view_ofs = '0 0 25';
	self.use = monster_use;
	
	self.flags = self.flags | FL_MONSTER;
	
	if (self.target != string_null)
	{
		self.goalentity = self.movetarget = find(world, targetname, self.target);
		self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);

		if (!self.movetarget)
		{
			dprint ("Monster can't find target at ");
			dprint (vtos(self.origin));
			dprint ("\n");
		}
	// this used to be an objerror
		if (self.movetarget.classname == "path_corner")
			self.th_walk ();

		else
			self.pausetime = 99999999;
			self.th_stand ();
	}

	else
	{
		self.pausetime = 99999999;
		self.th_stand ();
	}

	// spread think times so they don't all happen at same time
	self.nextthink = self.nextthink + random()*0.5;
};
*/
void(string monster_type) create_chas_monster = {

local entity chas_monster, spawn_spot;

// start entity and place it in world 
	chas_monster = spawn();
	spawn_spot = SelectSpawnPoint ();
	chas_monster.origin = spawn_spot.origin + '0 0 1';
	chas_monster.angles = spawn_spot.angles;
	chas_monster.fixangle = TRUE;	
	spawn_tfog (chas_monster.origin);
	spawn_tdeath (chas_monster.origin, chas_monster);

// set size and shape
	chas_monster.solid = SOLID_SLIDEBOX;
	chas_monster.movetype = MOVETYPE_STEP;
	chas_monster.flags = chas_monster.flags | FL_MONSTER;
	chas_monster.takedamage = DAMAGE_AIM;


//Load specific monster stuff

	if (monster_type == "ogre") {
		setmodel(chas_monster, "progs/ogre.mdl");
		setsize (chas_monster, VEC_HULL2_MIN, VEC_HULL2_MAX);
		
		chas_monster.netname = "Ogre";
		chas_monster.killstring = " was pwnd by a Chas Ogre\n";
		chas_monster.health = 200;
		chas_monster.classname = "monster_ogre";
		chas_monster.ideal_yaw = chas_monster.angles * '0 1 0';
		chas_monster.yaw_speed = 120;
		chas_monster.view_ofs = '0 0 22';

		chas_monster.th_stand = ogre_stand1;
		chas_monster.th_walk = ogre_walk1;
		chas_monster.th_run = ogre_run1;
		chas_monster.th_die = ogre_die;
		chas_monster.th_melee = ogre_melee;
		chas_monster.th_missile = ogre_nail1;
		chas_monster.th_pain = ogre_pain;

		bprint("a chas ogre joins the game\n");
	
	} else if (monster_type == "enforcer") {

		setmodel (chas_monster, "progs/enforcer.mdl");
		setsize (chas_monster, '-16 -16 -24', '16 16 40');

		chas_monster.netname = "Enforcer";
		chas_monster.killstring = " was blasted by a Chas Enforcer\n";
		chas_monster.health = 80;
		chas_monster.max_health = 80;
		chas_monster.classname = "monster_enforcer";

		chas_monster.th_stand = enf_stand1;
		chas_monster.th_walk = enf_walk1;
		chas_monster.th_run = enf_run1;
		chas_monster.th_pain = enf_pain;
		chas_monster.th_die = enf_die;
		chas_monster.th_missile = enf_atk1;

		bprint("a chas enforcer joins the game\n");
	} else if (monster_type == "shambler") {


		setmodel (chas_monster, "progs/shambler.mdl");
		setsize (chas_monster, VEC_HULL2_MIN, VEC_HULL2_MAX);

		chas_monster.health = 600;
		chas_monster.max_health = 600;
		chas_monster.classname = "monster_shambler";
		chas_monster.netname = "Shambler";
		chas_monster.killstring = " was smashed by a Chas Shambler\n";

		chas_monster.noise = "shambler/ssight.wav";

		chas_monster.th_stand = sham_stand1;
		chas_monster.th_walk = sham_walk1;
		chas_monster.th_run = sham_run1;
		chas_monster.th_die = sham_die;
		chas_monster.th_melee = sham_melee;
		chas_monster.th_missile = sham_magic1;
		chas_monster.th_pain = sham_pain;

		bprint("a chas shambler joins the game\n");
	}

	//chas_monster.nextthink = time + 0.1 + random();
	//chas_monster.think = chas_monster.th_walk;

	chas_monster.nextthink = self.nextthink + random()*0.5;
	chas_monster.think = walkmonster_start_go;

};