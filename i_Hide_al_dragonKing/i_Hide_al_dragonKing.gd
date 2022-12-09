extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "[特殊]喷水龙王"
	info = "[color=#BDB76B]“龙王之力庇护吾身！呼风唤雨，84消毒”[/color]\n一次性消耗品，使用后：\n赋予该角色不占用技能槽的额外技能：水漫金山\n水漫金山：施放技能时扣10金，若一回合扣了50金，则一次性获得100金"
	price = 100
	base = globalData.infoDs["g_azurlineBase"]
	if base.getSetting("achiOther", []).has("dragonGod"):
		info += "\n龙神成就：永久赋予该角色30%冷却速度和攻速"
	
func _connect():
	if base.getSetting("achiOther", []).has("dragonGod"):
		masCha.updateTmpAtt("spd", 0.3)
		masCha.updateTmpAtt("cd", 0.3)
	learnSkill()
	delSelf()
	
func learnSkill():
	if masCha == null or masCha.get("tag") != "azurline":return
	var sk = skillPool.getSkill(58, 3)
	sk.setCha(masCha)
	masCha.exSkillSlot.append(sk)

