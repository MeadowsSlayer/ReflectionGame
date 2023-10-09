extends Node

var gen = RandomNumberGenerator.new()
var ATK
var DMG_Mod
var CRIT
var DMG_add
var skill_lvl
var enemy
var status_effects
var HIT

func Action():
	status_effects = get_parent().get_node("StatusEffects")
	gen.randomize()
	ATK = get_parent().ATK + status_effects.PeaceOfMind(get_parent().target)
	DMG_Mod = get_parent().DMG_Mod + status_effects.BLUE_DMG_MOD()
	CRIT = get_parent().CRIT
	DMG_add = get_parent().DMG_add
	enemy = get_parent().get_node(str("../Enemy", get_parent().target)).get_child(1)
	skill_lvl = get_parent().skill_lvl
	HIT = gen.randi_range(1, 100) - status_effects.bind
	
	get_parent().SingleAttack()
	
	if HIT >= enemy.AVO || enemy.sleep_duration != 0 || get_parent().status_effects.BloodMoon_Duration != 0:
		get_parent().sound_type = "Blunt Hit"
		var attack = int(ATK * (0.9 + 0.1 * skill_lvl))
		
		if skill_lvl == 4:
			attack = int(ATK * 1.4)
		if skill_lvl == 5:
			attack = int(ATK * 1.6)
		
		var status = skill_lvl + 2 + get_parent().exhaustion_boost
		if skill_lvl == 5:
			status = 8
		
		if enemy.sleep_duration != 0:
			enemy.WakeUp()
		enemy.Taking_Damage(attack, DMG_Mod, "blue", CRIT, DMG_add)
		enemy.Status_Effects("exhaustion", status, 0)
		enemy.get_node("EffectsSpecial").animation = "Reverse Ice"
		enemy.get_node("EffectsSpecial").modulate = Color8(255, 255, 255)
		get_parent().EN_Plus(4 + get_parent().blue_skills_en_boost)
		status_effects.WarningStrike_OFF()
		status_effects.WaitingGameNULL()
		get_parent().IterativeProcessCheck()
	else:
		get_parent().sound_type = "Miss"
		enemy.Dodge()
		status_effects.WaitingGamePlus(get_parent().action_cost)
	
	
