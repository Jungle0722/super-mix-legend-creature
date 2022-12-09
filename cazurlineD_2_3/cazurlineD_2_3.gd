extends "../cazurlineD_2/cazurlineD_2.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「战列」豪"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	lv = 3             #等级的设置
	evos = ["cazurlineD_2_3_1"]
	addSkill("<唯一>我方皇家舰娘造成伤害时，对目标发起斩杀判定", "射击同步")
	ename = "hao"
	autoGetSkill()
	setCamp("皇家")
var skIndex = 3
func _upS():
	._upS()
	skIndex += 1
	if skIndex >= 3:
		skIndex = 0
		for i in getAllChas(2):
			if i.get("camp") == "皇家" and i.hasBuff("b_zhanSha") == null:
				i.addBuff(buffUtil.b_zhanSha.new())

func _onBattleEnd():
	._onBattleEnd()
	skIndex = 3
