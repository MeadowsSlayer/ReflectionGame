extends Node

var gen = RandomNumberGenerator.new()
var ATK
var DMG_Mod
var CRIT
var DMG_add
var skill_lvl
var attack
var status
var duration = 2
var enemy
var status_effects
var HIT

func Action():
	status_effects = get_parent().get_node("StatusEffects")
	gen.randomize()
	ATK = get_parent().ATK + status_effects.PeaceOfMind(get_parent().target)
	DMG_Mod = get_parent().DMG_Mod + get_parent().status_effects.PURPLE_DMG_MOD()
	CRIT = get_parent().CRIT
	DMG_add = get_parent().DMG_add
	enemy = get_parent().get_node(str("../Enemy", get_parent().target)).get_child(1)
	skill_lvl = get_parent().skill_lvl
	HIT = gen.randi_range(1, 100) - status_effects.bind
	
	get_parent().SingleAttack()
	
	if HIT >= enemy.AVO || enemy.sleep_duration != 0 || get_parent().status_effects.BloodMoon_Duration != 0:
		if skill_lvl >= 3:
			duration = 3
		if skill_lvl == 5:
			duration = 4
		attack = ATK + int(ATK * 0.5 * skill_lvl)
		status = (10 + 10 * skill_lvl) / 100.0
		if enemy.sleep_duration != 0:
			enemy.WakeUp()
		enemy.Taking_Damage(attack, DMG_Mod, "purple", CRIT, DMG_add)
		enemy.get_node("EffectsSpecial").animation = "Barrier"
		enemy.get_node("EffectsSpecial").modulate = Color8(255, 255, 255)
		enemy.Status_Effects("aches", status, duration)
		
		get_parent().sound_type = "Blunt Hit"
		get_parent().EN_Plus(4)
		status_effects.WaitingGameNULL()
		status_effects.WarningStrike_OFF()
		get_parent().IterativeProcessCheck()
	else:
		enemy.Dodge()
		get_parent().sound_type = "Miss"
		status_effects.WaitingGamePlus(get_parent().action_cost)
	
	
