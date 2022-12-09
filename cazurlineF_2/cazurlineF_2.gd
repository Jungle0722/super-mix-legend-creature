extends "../cazurlineF/cazurlineF.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「辅助」不知火"   #角色的名称
	attCoe.mgiAtk += 1  #魔法攻击（每点代表13.7）
	lv = 2             #等级的设置
	evos = ["cazurlineF_2_1","cazurlineF_2_2","cazurlineF_2_3"]
	addSkill("每{cd}秒随机恢复一名非满血友军[法强*2]({damage})的生命值(可暴击)，有5%几率治疗敌人\n					(将向敌人收取10块钱的医疗费)", "随缘治疗", "syzl", 6)
	type2 = "doctor"
	setCamp("重樱")
	ename = "buzhihuo"

func _castCdSkill(id):
	._castCdSkill(id)
	if id == "syzl":
		syzl()

func syzl():
	var ally=getAllChas(2)
	heal(ally)
	if sys.rndPer(5):
		var enemy = getAllChas(1)
		heal(enemy)
		sys.main.player.plusGold(10)

func heal(chas):
	chas.shuffle()
	var dmg = att.mgiAtk*2
	if sys.rndPer(att.cri * 100):dmg *= 2+att.criR
	for i in chas:
		if i.att.hp < i.att.maxHp:
			healCha(i, dmg)
			break

	