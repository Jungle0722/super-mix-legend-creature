extends "../azurline_base_item/azurline_rare_item.gd"
func init():
	.init()
	name = "[稀有]链式装弹机"
	att.spd = 0.5
	att.atk = 50
	att.mgiAtk = 50
	info = "每次普攻加快自身技能冷却1秒，每秒最多触发一次\n[color=#DC143C]同时装备两件时可升级[/color]\n[color=#C0C0C0]特效可以被科研装备吞噬[/color]"
func _connect():
	._connect()
	masCha.connect("onAtkChara",self,"run")
var flag = true
func run(atkInfo):
	if atkInfo.atkType == Chara.AtkType.NORMAL && flag:
		var skills = masCha.skills
		for i in skills:
			if i.cd/(1+masCha.att.cd) - i.nowTime > 1:
				i.nowTime += 1
		flag = false
func _upS():
	flag = true

