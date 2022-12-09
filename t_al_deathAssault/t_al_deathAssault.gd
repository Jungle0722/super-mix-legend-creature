extends Talent

var utils = globalData.infoDs["g_azurlineUtils"]
func init():
	name = "决死突击"
func _connect():
	sys.main.connect("onBattleStart",self,"onBattleStart")
var cells = [Vector2(4,0), Vector2(4,1), Vector2(4,2), Vector2(4,3), Vector2(4,4) ,Vector2(4,5)]
func onBattleStart():
	var chas = []
	for i in cells:
		var cha = sys.main.matCha(i)
		if cha != null and cha.team == 1 and cha.get("tag") == "azurline":
			chas.append(cha)
	var d = chas.size() - 2
	if d > 0:
		for i in range(d):
			chas.pop_back()
	for i in chas:
		var e = utils.getRndEnemy(i)
		utils.jump(e, i)
		for j in i.getCellChas(i.cell, 1, 1):
			var dmg = j.att.maxHp*0.4
			if j.get("type") == "BOSS":dmg *= 0.3
			i.holyDmg(j, dmg, "决死突击")
		i.forceHurtSelf(i.att.maxHp)
		
func get_info():
	return "战斗开始时，使我方第五列(即最靠近敌人的那一排)上随机2名友军绑上炸药包，分别突击到随机敌方单位身边自爆对周围(十字范围)的敌人造成[目标血上限*0.4]的神圣伤害\n[color=#DC143C]此天赋不需要升级，仅限碧蓝航线使用"

