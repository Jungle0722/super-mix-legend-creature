extends "../cex___warship/cex___warship.gd"
func _info():
	pass
func _connect():
	._connect()
var flag2 = true
func _extInit():
	._extInit()
	chaName = "惩戒型工具人"   #角色的名称
	attCoe.atkRan = 20  #攻击距离
	attCoe.maxHp = 4000   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 4000     #攻击力（每点代表8.5）
	attCoe.mgiAtk = 300  #魔法攻击（每点代表13.7）
	attCoe.def = 30     #物理防御（每点代表15）
	attCoe.mgiDef = 30 #魔法防御（每点代表16.6）
	attAdd.spd = 2
	attAdd.suck = 2
	attAdd.cri = 1
	attAdd.defR = 1
	attAdd.atkR = 1
	attAdd.penL = 1
	lv = 4            #等级的设置
	atkEff = "atk_dang" #攻击时的特效
	addSkillTxt("无敌")
	addSkillTxt("寂寞")

var baseId = ""

func _upS():
	._upS()
	for i in getAllChas(1):
		hurtChara(i, i.att.maxHp, Chara.HurtType.REAL, Chara.AtkType.EFF)
		hurtChara(i, i.att.maxHp, Chara.HurtType.REAL, Chara.AtkType.EFF)

func _onHurt(atkInfo):
	._onHurt(atkInfo)
	atkInfo.hurtVal = 0

func _onDeath(atkInfo):
	._onDeath(atkInfo)
	if atkInfo.atkCha.id.find("cex___azurtoolman") == -1:
		summChara(id)