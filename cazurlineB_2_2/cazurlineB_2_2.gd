extends "../cazurlineB_2/cazurlineB_2.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「轻巡」海伦娜"   #角色的名称
	attCoe.atk += 1 #魔法攻击（每点代表13.7）
	attCoe.maxHp += 1
	lv = 3             #等级的设置
	evos = ["cazurlineB_2_2_1"]
	addSkill("<先手>每{cd}秒，让所有敌人<暴露>", "雷达扫描", "radarScanning", 8)
	autoGetSkill()
	setCamp("白鹰")

func _castCdSkill(id):
	._castCdSkill(id)
	if id == "radarScanning":
		radarScanning()

func _onBattleStart():
	._onBattleStart()
	radarScanning()

func radarScanning():
	utils.createSkillTextEff("雷达扫描", position)
	var chas = getAllChas(1)
	for i in chas:
		var b = i.hasBuff("b_expose")
		if b == null:
			i.addBuff(buffUtil.b_expose.new(3))
		else:
			b.reset(1)