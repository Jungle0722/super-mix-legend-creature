extends "../cazurlineD/cazurlineD.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「战列」腓特烈大帝"
	attCoe.atkRan = 1  #攻击距离
	attCoe.maxHp += 4   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 3     #攻击力（每点代表8.5）
	attCoe.def += 3     #物理防御（每点代表15）
	attCoe.mgiDef += 3  #魔法防御（每点代表16.6）

	addSkill("我方铁血阵营角色获得<禁疗><烧蚀><穿甲>效果时，将其免疫，并对效果来源造成\n				[血上限*0.1]的物理伤害", "混沌奏鸣曲")
	addSkill("每{cd}秒吸收周围3格的所有敌方单位20%的双防为己用，若目标为召唤物，则对其\n				造成[目标血上限100%]的真实伤害", "暗黑狂想曲", "darkSong", 11)
	addSkill("每{cd}秒对全体敌人造成[自身受损生命值30%]的物理伤害", "破坏交响曲", "vengeanceFlame", 6)

	setCamp("铁血")
	autoGetSkill()
	prefer = "t"
	lv = 3
	setGunAndArmor("大型","超重型")
	ename = "feiteliedadi"
	evos = ["cex___als-h392"]
	canCopy = false
	supportSpecEvo = 2
var p4 = 0.3

func _onBattleStart():
	._onBattleStart()
	addBuff(b_h392.new())
	for i in getAllChas(2):
		if i.get("camp") == "铁血" or i.get("camp") == "撒丁帝国":
			i.addBuff(b_h391.new(self))

func _castCdSkill(id):
	._castCdSkill(id)
	if id == "vengeanceFlame":
		var enemy = getAllChas(1)
		var damage = (att.maxHp - att.hp) * p4
		createCustEff(position, "eff/shuiHuanBao", 6, false, 1, Vector2(0, -40))
		if isAwaken:
			damage += att.def * 0.4
		for i in enemy:
			azurHurtChara(i, damage, Chara.HurtType.PHY, Chara.AtkType.EFF, "破坏交响曲")
			if upgraded and att.suck > 0:
				healCha(self, damage*att.suck)

	if id == "darkSong":
		darkSong()

func darkSong():
	var buff = hasBuff("b_h392") 
	if buff == null:
		buff = addBuff(b_h392.new())
	for i in getCellChas(cell, 3, 1):
		if i.att.def < 5 or i.att.mgiDef < 5:continue
		var f1 = i.att.def * 0.2
		var f2 = i.att.mgiDef * 0.2
		var bf = i.hasBuff("b_h392") 
		if bf == null:
			i.addBuff(b_h392.new(-f1, -f2))
		else:
			bf.updateAtt(-f1, -f2)
		buff.updateAtt(f1, f2)
		if i.isSumm:
			azurHurtChara(i, i.att.maxHp, Chara.HurtType.REAL, Chara.AtkType.EFF, "暗黑狂想曲")
			
class b_h391:
	extends Buff
	var buffName = "混沌奏鸣曲"
	var excludes = ["b_reHp_p", "b_shaoShi", "b_perforation"]
	var cha
	func _init(cha = null):
		attInit()
		id = "b_h391"
		self.cha = cha	
	func _connect():
		masCha.connect("onAddBuff", self, "onAddBuff")
	func onAddBuff(buff):
		if buff.isNegetive and excludes.has(buff.id) and buff.get("cha") != null:
			cha.azurHurtChara(buff.cha, masCha.att.maxHp*0.1, Chara.HurtType.PHY, Chara.AtkType.EFF, "混沌奏鸣曲")
			buff.isDel = true

class b_h392:
	extends Buff
	var buffName = "暗黑狂想曲"
	func _init(def = 0, mgiDef = 0):
		attInit()
		id = "b_h392"
		att.def = def
		att.mgiDef = mgiDef
		if att.def < 0:
			isNegetive = true

	func updateAtt(def = 0, mgiDef = 0):
		att.def += def
		att.mgiDef += mgiDef

		att.def = min(5000, att.def)
		att.mgiDef = min(5000, att.mgiDef)
		if att.def < 0:
			isNegetive = true