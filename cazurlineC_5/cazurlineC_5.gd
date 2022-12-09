extends "../cazurlineC/cazurlineC.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「重巡」铃谷"   #角色的名称
	attCoe.atkRan = 3#攻击距离
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 1     #物理防御（每点代表15）
	lv = 2             #等级的设置
	evos = ["cazurlineC_5_1","cazurlineC_5_2","cazurlineC_5_3"]
	addSkill("<亡语>每次死亡提高自身20点四维属性，上限600，每回合触发一次", "轮回")

	prefer = "ad"
	setGunAndArmor("中型","中型")
	setCamp("重樱")

var isSurvive = false
var isSurvive1 = false
var isSurvive2 = false
var limit = 600
var num = 0
var p2 = 20
func deathWord():
	.deathWord()
	if num < limit:
		updateTmpAtt("atk", p2)
		updateTmpAtt("mgiAtk", p2)
		updateTmpAtt("def", p2)
		updateTmpAtt("mgiDef", p2)
		num += p2	

func _onBattleEnd():
	._onBattleEnd()
	isSurvive = false
	isSurvive1 = false
	isSurvive2 = false

#进化后继承属性
func extendsEvo(cha):
	.extendsEvo(cha)
	if cha.get("num") != null:
		self.num = cha.num	