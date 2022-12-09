extends "../cazurlineA/cazurlineA.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「驱逐」Z23"   #角色的名称
	attCoe.atkRan = 5#攻击距离
	attCoe.maxHp = 4#最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 4     #攻击力（每点代表8.5）
	attCoe.mgiAtk = 6  #魔法攻击（每点代表13.7）
	attCoe.def = 3     #物理防御（每点代表15）
	attCoe.mgiDef = 3#魔法防御（每点代表16.6）
	lv = 3             #等级的设置
	evos = ["cex___als-z232"]
	canCopy = false
	addSkill("每秒获得1层<圣盾><魔力>", "铁血先锋")
	addSkill("每{cd}秒对当前目标造成[圣盾层数*法强*3]的可暴击魔法伤害，清空自身一半的圣盾", "圣城陨落", "z23_1", 4)
	ename = "z23"
	autoGetSkill()
	supportSpecEvo = 2
	setCamp("铁血")

func _upS():
	._upS()
	buffUtil.addShengDun(self, 1)
	addBuff(buffUtil.b_moLi.new(1))

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="z23_1" and aiCha != null:
		z23_1()

func z23_1():
	var bf = hasBuff("b_shengDun")
	if bf != null:
		azurHurtChara(aiCha, bf.num * att.mgiAtk * 3, Chara.HurtType.MGI, Chara.AtkType.SKILL, "圣城陨落", true)
		bf.num -= int(bf.num*0.5)		