extends "../cazurlineE_3_2/cazurlineE_3_2.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「航母」赤城·μ兵装"   #角色的名称
	evos = ["cex___almiu-akagi2"]
	supportSpecEvo = 2
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.mgiAtk += 1
	canCopy = false
	addSkillTxt("[color=#C0C0C0][μ羁绊]-战斗开始时，场上μ兵装舰娘数量达到2/5/8个时，分别获得：30%冷却加成/20%血量加成/兵装解放技能强化[/color]")
	prefer = "ap"
	ename = "chicheng"