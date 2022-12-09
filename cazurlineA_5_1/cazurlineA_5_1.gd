extends "../cazurlineA_5/cazurlineA_5.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「驱逐」凉月"   #角色的名称
	attCoe.maxHp += 1
	attAdd.spd += 0.8
	lv = 3             #等级的设置
	evos = ["cazurlineA_5_1_1"]
	addSkill("攻速提高80%，普攻35%概率使自身重型鱼雷立即装填完毕", "装填战术")
	autoGetSkill()
	setCamp("重樱")
var p3 = 35
func _onNormalAtk(cha):
	if not is_instance_valid(cha):return
	._onNormalAtk(cha)
	if sys.rndPer(p3):
		var sk = getSkill("zxyl")
		sk.nowTime += sk.cd/(1+att.cd)
		