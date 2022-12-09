extends "../cex___warship/cex___warship.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「特殊」思念体"   #角色的名称
	attCoe.atkRan = 20#攻击距离
	attCoe.maxHp = 3#最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 8     #攻击力（每点代表8.5）
	attCoe.mgiAtk = 4  #魔法攻击（每点代表13.7）
	attCoe.def = 4     #物理防御（每点代表15）
	attCoe.mgiDef = 4#魔法防御（每点代表16.6）
	attAdd.cri += 1000
	atkEff = "atk_dao" #攻击时的特效
	isSumm = true
	lv = 4             #等级的设置
	addSkillTxt("普攻会锁定血量最低的友军且附带[目标血上限*0.2]的真实伤害")
	addSkillTxt("出场时获得3秒<模糊>，若出场10秒内被击杀，则获得[攻击*0.1]的金币(上限50)")
	addSkillTxt("免疫魔法伤害")
	addSkillTxt("<亡语>阵亡时对当前目标造成[目标血上限*1]的真实伤害")
var summoner
var flag = false

func upgrade():
	updateTmpAtt("spd", 1)

var index = 0
func _upS():
	._upS()
	index += 1
func _onHurt(atkInfo):
	._onHurt(atkInfo)
	if atkInfo.hurtType == Chara.HurtType.MGI:
		atkInfo.hurtVal = 0
	
func normalAtkChara(cha):
	var chas = getAllChas(2)
	chas.sort_custom(self, "sortByHp")
	chas.erase(self)
	for i in range(1):
		if i >= chas.size():break
		aiCha = chas[i]
		.normalAtkChara(chas[i])
		if not chas[i].isDeath:
			hurtChara(chas[i], chas[i].att.maxHp*0.2, Chara.HurtType.REAL, Chara.AtkType.EFF)

func deathWord():
	.deathWord()
	if isDeath and index <= 10 and summoner.team == 1:
		sys.main.player.plusGold(min(att.atk*0.1, 50))

	var dmg = aiCha.att.maxHp * 1
	if aiCha.team == 1:
		dmg *= 0.3
	hurtChara(aiCha, dmg, Chara.HurtType.REAL, Chara.AtkType.SKILL)