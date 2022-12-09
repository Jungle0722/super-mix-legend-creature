extends "../cazurlineD/cazurlineD.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「战列」陆奥"   #角色的名称
	attCoe.atkRan = 3  #攻击距离
	attCoe.atk += 1     #攻击力（每点代表8.5）
	lv = 2             #等级的设置
	evos = ["cazurlineD_1_1","cazurlineD_1_2","cazurlineD_1_3"]
	addSkill("每对同一个目标普攻3次，额外造成[物攻*1.5+目标血上限*0.3]的真实伤害", "BigSeven")
	setCamp("重樱")
	if team == 2:
		skHurtType = Chara.HurtType.PHY

var num = 0
var cha = null
var p2 = 3
var skHurtType = Chara.HurtType.REAL
func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)
	if atkInfo.atkType == Chara.AtkType.NORMAL:
		if cha != atkInfo.hitCha:
			cha = atkInfo.hitCha
			num = 0
		num += 1
		if num == p2:
			var dmg = att.atk*1.5 + maxHp(atkInfo.hitCha)*0.3
			azurHurtChara(atkInfo.hitCha, dmg, skHurtType, Chara.AtkType.SKILL, "BigSeven")
			num = 0

func _onBattleStart():
	._onBattleStart()
	num = 0
	cha = null