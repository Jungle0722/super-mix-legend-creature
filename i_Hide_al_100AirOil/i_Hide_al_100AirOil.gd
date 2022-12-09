extends "../azurline_base_item/azurline_rare_item.gd"
func init():
	.init()
	name = "[稀有]100/150号航空燃油"
	info = "<限定>自身舰载机受到致命伤害时，免疫该次伤害并获得3秒无敌\n[color=#DC143C]同时装备两件时可升级[/color]\n[color=#C0C0C0]特效无法被科研装备吞噬[/color]"
	price = 300
	att.atk = 150
	att.mgiAtk = 150
	att.def = 150
	att.mgiDef = 150
	
func _connect():
	._connect()
	if masCha.isSumm:
		masCha.addBuff(b_100AirOil.new())

class b_100AirOil:
	extends Buff
	var dispel = 2
	var utils = globalData.infoDs["g_azurlineUtils"]
	func _init():
		attInit()
		id = "b_100AirOil"
	func _connect():
		masCha.connect("onHurt", self, "onHurt")
	func onHurt(atkInfo:AtkInfo):
		if atkInfo.hurtVal > 0 and atkInfo.hurtVal*1.2 >= masCha.att.hp and masCha.hasBuff("b_wudi") == null:
			masCha.addBuff(utils.buffs.b_wudi.new(3))
			atkInfo.hurtVal = 0
			self.isDel = true		