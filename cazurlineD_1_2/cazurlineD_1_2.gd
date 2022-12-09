extends "../cazurlineD_1/cazurlineD_1.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」骏河"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 2     #攻击力（每点代表8.5）
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	lv = 3             #等级的设置
	evos = ["cazurlineD_1_2_1"]
	addSkill("战斗开始时获得10秒<狂化>，击杀敌方单位时，召唤该单位为我方作战，并使其继承自己的装备", "战术解放")

	autoGetSkill()
	setCamp("重樱")

func _onKillChara(atkInfo):
	._onKillChara(atkInfo)	
	if not atkInfo.hitCha.isSumm and atkInfo.hitCha.get("type") != "siren" and atkInfo.hitCha.get("type") != "BOSS":
		summChara(atkInfo.hitCha.id, true)
	
func _onBattleStart():
	._onBattleStart()
	addBuff(buffUtil.b_spd.new(20, 10))
