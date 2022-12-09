extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "[特殊]炽烈之歌"
	info = "仅限μ兵装舰娘使用，一次性道具，使用后：\n随机获得1个不占用技能槽的传说品质的随机技能(技能倾向会随角色的不同而不同，如罗恩·μ兵装，会获得防御向的技能)\n永久提高30%冷却速度，100点双攻\n来源：使用μ兵装舰娘击败塞壬\n[color=#DC143C]每个角色最多使用3次"
	price = 300
	
func _connect():
	if masCha.chaName.find("μ兵装") == -1 or masCha.exSkillSlot.size() >= 3:
		return
	masCha.updateTmpAtt("spd", 0.3)
	masCha.updateTmpAtt("atk", 100)
	masCha.updateTmpAtt("mgiAtk", 100)
	learnRndSkill()
	delSelf()
