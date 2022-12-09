extends "../cex___warship/cex___warship.gd"
func _info():
	pass
func _connect():
	._connect()
var flag2 = true
func _extInit():
	._extInit()
	chaName = "挨打型工具人"   #角色的名称
	attCoe.atkRan = 20  #攻击距离
	attCoe.maxHp = 20   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 0     #攻击力（每点代表8.5）
	attCoe.mgiAtk = 0  #魔法攻击（每点代表13.7）
	attCoe.def = 17     #物理防御（每点代表15）
	attCoe.mgiDef = 17 #魔法防御（每点代表16.6）
	aiOn = false
	lv = 4            #等级的设置
	atkEff = "atk_dang" #攻击时的特效
	type = "siren"
	addCdSkill("test", 5)
	attAdd.defR += 0.5

var baseId = ""
func _upS():
	._upS()
	plusHp(20000)
			
# func _onHurt(atkInfo):
# 	._onHurt(atkInfo)
# 	if atkInfo.hurtType == Chara.HurtType.REAL:
# 		print("def")

func _onHurtEnd(atkInfo):
	._onHurtEnd(atkInfo)
	# if atkInfo.hurtType == Chara.HurtType.REAL:
	# 	print("hurte%d"%atkInfo.hurtVal)
	atkInfo.atkCha.damageCallback(atkInfo)

func _onDeath(atkInfo):
	._onDeath(atkInfo)
	if atkInfo.atkCha.id.find("cex___azurtoolman") == -1:
		summChara(id)