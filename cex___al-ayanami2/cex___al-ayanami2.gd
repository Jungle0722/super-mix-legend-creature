extends "../cex___al-ayanami/cex___al-ayanami.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「驱逐」绫波·Lv3"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 1     #攻击力（每点代表8.5）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	attCoe.def += 1  #魔法防御（每点代表16.6）
	attAdd.penL += 0.3
	lv = 3             #等级的设置
	evos = ["cex___al-ayanami3"]
	addSkill("物理穿透+30%，每普攻3次，对当前目标一列的所有敌人附加10层<漏水><烧蚀>，\n			每触发3次，发动鬼神演舞", "斩舰刀")
	autoGetSkill()

var zjdIndex = 0
var gsywIndex = 0
var p4 = 4
func zjd():
	gsywIndex += 1
	for i in range(6):
		var cha = matCha(Vector2(aiCha.cell.x, i))
		if cha != null and cha.team != team:
			cha.addBuff(buffUtil.b_shaoShi.new(10))
			buffUtil.addLouShui(cha, self, 10)

	if lv == 4 and gsywIndex >= 3:
		gsywIndex = 0
		gsyw()

func _onNormalAtk(cha):
	._onNormalAtk(cha)
	zjdIndex += 1
	if zjdIndex >= 3 and aiCha != null:
		zjdIndex = 0
		zjd()

func gsyw():
	utils.createSkillTextEff("鬼神演舞", position)
	awakenProcess += 1
	if awakenProcess >= 120 and not isAwaken:
		call("awaken")

	var chas = getCellChas(cell, 2, 1)
	for i in chas:
		if i.hasBuff("b_ayanami") == null:
			i.addBuff(b_ayanami.new())
		var dmg = att.atk*p4
		var hurtType = Chara.HurtType.PHY
		if isAwaken and chas.size() == 1:
			hurtType = Chara.HurtType.REAL
			dmg *= 2

		azurHurtChara(i, dmg, hurtType, Chara.AtkType.NORMAL, "鬼神演舞", true)

func _onBattleEnd():
	._onBattleEnd()
	zjdIndex = 0
	gsywIndex = 0

class b_ayanami:
	extends Buff
	var buffName = "斩舰刀-负面"
	var dispel = 3
	func _init():
		attInit()
		id = "b_ayanami"	
		att.defL = -0.3