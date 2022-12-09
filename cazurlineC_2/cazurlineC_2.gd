extends "../cazurlineC/cazurlineC.gd"
func _info():
	pass
func _connect():
	._connect()
var p1 = 100
func _extInit():
	._extInit()
	chaName = "「重巡」爱宕"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 1     #攻击力（每点代表8.5）
	attCoe.def += 1
	attCoe.mgiDef += 1
	lv = 2             #等级的设置
	evos = ["cazurlineC_2_1","cazurlineC_2_2"]
	addSkill("普攻对目标十字范围的敌方单位额外造成一次[攻击*1]({damage})的普攻伤害", "十字斩")

	setCamp("重樱")
var cells = [Vector2(-1,0),Vector2(1,0),Vector2(0,1),Vector2(0,-1)]

func _onNormalAtk(cha):
	if not is_instance_valid(cha):return
	if sys.rndPer(p1):
		for i in cells:
			var mcha = matCha(cha.cell+i)
			if mcha != null && mcha.team != team:
				azurHurtChara(mcha, getSkillEffect("十字斩"), Chara.HurtType.PHY, Chara.AtkType.NORMAL, "十字斩")


