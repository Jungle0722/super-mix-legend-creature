extends "../cazurlineB/cazurlineB.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「轻巡」谢菲尔德"   #角色的名称
	attCoe.atkRan = 3  #攻击距离
	attCoe.atk += 1
	attCoe.maxHp += 1
	lv = 2             #等级的设置
	atkEff = "atk_gongJian" #攻击时的特效
	evos = ["cazurlineB_4_1","cazurlineB_4_2"]
	addSkill("战斗开始时，赋予周围(九宫格)友军12层<强攻>", "激励")
	setGunAndArmor("小型","中型")
	setCamp("皇家")

func _onBattleStart():
	._onBattleStart()
	for i in getAroundChas(cell):
		i.addBuff(buffUtil.b_qiangGong.new(12))