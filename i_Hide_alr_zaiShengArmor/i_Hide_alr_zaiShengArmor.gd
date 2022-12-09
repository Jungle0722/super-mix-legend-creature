extends "../azurline_ctrl/BaseResearchItem.gd"
func init():
	.init()
	name = "[color=#DC143C][传说]再生装甲"
	att.reHp = 0.5
	att.def = 200
	att.mgiDef = 200
	att.maxHpL = 0.2
	att.dod = 0.3
	info = "[color=#DC143C]仅限超重型护甲舰娘装备[/color]\n受到伤害后30%概率完全恢复该次伤害的血量"
var p1 = 30
func _connect():
	._connect()
	if masCha.id == "cex___al-merchant":return
	if masCha.get("armorType") != "超重型":
		delFromCha()
		return
	masCha.connect("onHurt",self,"onHurt")
func onHurt(atkInfo:AtkInfo):
	if atkInfo.hurtVal > 0 and sys.rndPer(p1):
		masCha.healCha(masCha, atkInfo.hurtVal)
