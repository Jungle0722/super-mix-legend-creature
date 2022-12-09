extends "../cazurlineD_3/cazurlineD_3.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」君主"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.def += 2
	attCoe.mgiDef += 2
	lv = 3             #等级的设置
	evos = ["cazurlineD_3_1_1"]
	addSkill("每{cd}秒将威胁最大（物攻魔攻之和最高）的5名敌方单位身上的增益效果弱驱散,\n				并恢复(转移Buff数量*最大生命值*1.5%)的生命值", "君王之睥睨", "jzskill", 5)

	autoGetSkill()
	setCamp("皇家")

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="jzskill":
		castJZ()

func castJZ():
	utils.createSkillTextEff("君王之睥睨", position)
	var buffNum = 0
	var chas = getAllChas(1)
	chas.sort_custom(self, "sortByAllAtkDesc")
	var num = []
	for i in chas:
		if num.size() >= 5:
			break
		var buffs = i.buffs
		for j in buffs:
			if not j.isNegetive && j.get("type") != config.EQUITYPE_EQUI && j.get("dispel") != 2 and j.get("dispel") != 3:
				j.isDel = true
				buffNum+=1
				if not num.has(i):
					num.append(i)
	if buffNum > 0:
		healCha(self, buffNum * att.maxHp * 0.015)

