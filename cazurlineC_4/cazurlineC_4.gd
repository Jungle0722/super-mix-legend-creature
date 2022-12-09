extends "../cazurlineC/cazurlineC.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「重巡」伦敦"   #角色的名称
	attCoe.atkRan = 3#攻击距离
	attCoe.atk += 2     #物理防御（每点代表15）
	attCoe.def += 1
	attCoe.maxHp += 1
	lv = 2             #等级的设置
	evos = ["cazurlineC_4_1","cazurlineC_4_2","cazurlineC_4_3"]
	addSkill("每次普攻有55%概率追加一次普攻", "连续射击")

	prefer = "ad"
	setGunAndArmor("中型","中型")
	setCamp("皇家")
var skFlag = false
func normalAtkChara(tcha):
	if not is_instance_valid(tcha):return
	if sys.rndPer(55):
		if skFlag:
			repel(tcha)
		if ename == "aikesaite":
			delayYx()
		normalAtkChara(tcha)
	.normalAtkChara(tcha)

#延迟引信
func delayYx():
	for i in utils.getRndEnemys(self, 2):
		i.addBuff(b_delayYx.new(self))

class b_delayYx:
	extends Buff
	var buffName = "延迟引信"
	var cha
	var dispel = 2
	var buffUtil = globalData.infoDs["g_azurlineBuffs"]
	func _init(cha):
		attInit()
		id = "b_delayYx"	
		isNegetive = true
		self.cha = cha
	var index = 0
	func _upS():
		index += 1
		if masCha.isDeath or cha.isDeath:isDel = true
		if index >= 5:
			if cha.team == 1:
				cha.azurHurtChara(masCha, min(masCha.att.maxHp*0.6, cha.att.atk * 3), Chara.HurtType.REAL, Chara.AtkType.SKILL, "延迟引信")
			else:
				cha.azurHurtChara(masCha, min(masCha.att.maxHp*1.2, cha.att.atk * 5), Chara.HurtType.PHY, Chara.AtkType.SKILL, "延迟引信")
			masCha.addBuff(buffUtil.b_shaoShi.new(6))
			isDel = true

#击退
func repel(cha):
	var tmp = cha.cell
	if doRepel(cell, cha):
		doRepel(tmp, cha)

func doRepel(from, cha):
	var matCell = cha.cell - from
	matCell.x = max(-1, matCell.x)
	matCell.x = min(1, matCell.x)
	matCell.y = max(-1, matCell.y)
	matCell.y = min(1, matCell.y)
	matCell += cha.cell
	if not sys.main.isMatin(matCell) or matCha(matCell) != null:
		azurHurtChara(cha, getSkillEffect("动能打击"), Chara.HurtType.PHY, Chara.AtkType.SKILL, "动能打击", true)
		cha.addBuff(buffUtil.b_shaoShi.new(10, self))
	else:
		cha.setCell(matCell)
