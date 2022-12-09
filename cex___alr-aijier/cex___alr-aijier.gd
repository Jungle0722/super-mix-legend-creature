extends "../cazurlineC/cazurlineC.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「重巡」埃吉尔"
	attCoe.atkRan = 3  #攻击距离
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 4     #攻击力（每点代表8.5）
	attCoe.def += 2     #物理防御（每点代表15）
	attCoe.mgiDef += 2     #物理防御（每点代表15）
	lv = 3
	isResearch = true
	addSkill("每秒吞噬周围(九宫格)敌人元气，吸取其2%的血量", "吞噬之漩")
	addSkill("每秒只会受到不超过1次伤害，每过10秒，每秒可受伤次数+1", "映照之渊")
	addSkill("每{cd}秒冲向血量最高的敌人身边，吸取其10%的血量并嘲讽周围(九宫格)的敌人", "噬啮之颚", "nsze", 10)
	ename = "aijier"
	autoGetSkill()
	setCamp("铁血")
	setGunAndArmor("大型","超重型")
	evos = ["cex___alr-aijier2"]
	canCopy = false
	supportSpecEvo = 2
var count = 0
var hurtNumLimit = 1
var hurtCount = 0
func _upS():
	._upS()
	hurtCount = 0
	count += 1
	if count >= 10:
		count = 0
		hurtNumLimit += 1
	for i in getAroundChas(cell, false):
		healCha(self, i.att.maxHp * 0.02)
		holyDmg(i, i.att.maxHp * 0.02, "吞噬之漩")

func _onHurt(atkInfo):
	._onHurt(atkInfo)
	if atkInfo.hurtVal == 0:return
	if hurtNum >= hurtNumLimit:
		atkInfo.hurtVal = 0
	hurtCount += 1
	
func _onBattleStart():
	._onBattleStart()
	hurtNumLimit = 1

func _castCdSkill(id):
	._castCdSkill(id)
	if id == "nsze":	
		nsze()

func nsze():
	var chas = getAllChas(1)
	chas.sort_custom(self, "sortByHpDesc")
	var vs = [Vector2(0,0),Vector2(1,0),Vector2(-1,0),Vector2(0,1),Vector2(0,-1),Vector2(1,1),Vector2(-1,1),Vector2(-1,-1),Vector2(1,-1)]
	for cha in chas:
		if cha.isDeath || cha.isSumm:continue
		var mv = Vector2(cha.cell.x ,cha.cell.y)
		for i in vs:
			var v = mv+i
			if matCha(v) == null && sys.main.isMatin(v) and setCell(v):
				var pos = sys.main.map.map_to_world(cell)
				ying(pos)
				position = pos
				aiCha = cha
				var dmg = cha.att.maxHp*0.1
				if cha.get("type") == "BOSS":
					dmg *= 0.4
				if upgraded:
					cha.addBuff(buffUtil.b_xuanYun.new(5))
					weakDispel(cha, true)
				healCha(self, dmg)
				holyDmg(cha, dmg, "噬啮之颚")
				if isAwaken:
					var bf = hasBuff("b_aijier")
					if bf == null:
						addBuff(b_aijier.new(dmg * 0.5))
					else:
						bf.att.maxHp += dmg*0.5

				for j in getAroundChas(cell, false):
					j.aiCha = self
					j.addBuff(buffUtil.b_taunt.new(5, self))
				return

class b_aijier:
	extends Buff
	var buffName = "血上限-埃吉尔"
	var dispel = 2
	func _init(num = 0):
		attInit()
		id = "b_aijier"	
		att.maxHp = num