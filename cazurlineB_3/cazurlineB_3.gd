extends "../cazurlineB/cazurlineB.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「轻巡」阿贺野"   #角色的名称
	attCoe.atkRan = 1  #攻击距离
	attCoe.def += 1
	attCoe.maxHp += 2
	lv = 2             #等级的设置
	atkEff = "atk_gongJian" #攻击时的特效
	attAdd.dod += 0.3
	evos = ["cazurlineB_3_1","cazurlineB_3_2"]
	addSkill("提高30%闪避，且有[闪避率*0.5]的概率闪避技能伤害(最多50%)", "移花接木")
	setGunAndArmor("小型","中型")
	setCamp("重樱")
var missNum = 0
func _onBattleEnd():
	._onBattleEnd()
	missNum = 0

func _onHurt(atkInfo):
	._onHurt(atkInfo)
	if team == 2 and att.dod > 0.8 and atkInfo.isMiss:
		atkInfo.isMiss = false

	if atkInfo.atkType == Chara.AtkType.SKILL && sys.rndPer(min(att.dod*50, 50)):
		atkInfo.isMiss == true
		atkInfo.hurtVal = 0


