extends "../cex___warship/cex___warship.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「驱逐」雪风"   #角色的名称
	attCoe.atkRan = 1#攻击距离
	attCoe.maxHp = 7#最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 2     #攻击力（每点代表8.5）
	attCoe.mgiAtk = 2  #魔法攻击（每点代表13.7）
	attCoe.def = 3     #物理防御（每点代表15）
	attCoe.mgiDef = 3#魔法防御（每点代表16.6）
	lv = 3             #等级的设置
	evos = ["cazurlineA_3_1_1"]
	addSkill("雪风会保护大家的！战斗开始时，使最靠前的5名友军(除自己)获得100%闪避，持续8秒", "吴之雪风")
	addSkill("当场上存在其他友军时，并将所受普攻伤害由1名血量最高的友军和1名随机敌军分摊", "不沉的幸运舰")
	addCdSkill("snowWind", 60)
	xfSkillFlag = false
	autoGetSkill()
	setCamp("重樱")
	type = "dd"
	prefer = "t"
	setGunAndArmor("小型", "轻型")

var enemy = null
var ally = null
func _onBattleStart():
	._onBattleStart()
	enemy = null
	ally = null

	var chas = getAllChas(2)
	chas.sort_custom(self,"sortByFront")
	var index = 0
	for i in chas:
		if index >= chas.size():break
		if i == self:continue
		i.addBuff(buffUtil.b_dod.new(10, 8))	
		index += 1


func _onHurt(atkInfo):
	._onHurt(atkInfo)
	if atkInfo.atkType == Chara.AtkType.NORMAL or atkInfo.atkType == Chara.AtkType.SKILL and isAwaken:
		fentan(atkInfo)
	
	
func fentan(atkInfo):
	if enemy == null || enemy.isDeath:
		reSelect(true)
	if ally == null || ally.isDeath:
		reSelect(false)
	if enemy != null && not enemy.isDeath:
		if team == 1:
			var dmg = atkInfo.atkVal*0.5
			if isAwaken:dmg *= 3
			azurHurtChara(enemy, dmg, atkInfo.hurtType, Chara.AtkType.EFF, "不沉的幸运舰")
	
	if ally == null or ally.isDeath or team == 2:
		atkInfo.hurtVal *= 0.5
	else:
		atkInfo.atkCha.azurHurtChara(ally, atkInfo.atkVal*0.6, atkInfo.hurtType, Chara.AtkType.EFF, atkInfo.get("skill"))
		atkInfo.hurtVal = 0

func reSelect(isEnemy=false):
	if not isEnemy:
		var allys = getAllChas(2)
		if allys.size() == 0:
			return
		allys.sort_custom(self,"sortXF")
		for i in allys:
			if i.get("xfSkillFlag") && not i.isDeath && not i.hasBuff("b_xueFeng") and not isSumm:
				ally = i
				ally.addBuff(b_xueFeng.new(self))
				break
	else:
		var enemys = getAllChas(1)
		if enemys.size() == 0:
			return
		enemys.shuffle()
		for i in enemys:
			if i.get("xfSkillFlag") && not i.isDeath && i.get("type") != "BOSS":
				enemy = i
				break

func sortXF(a,b):
	if a.get("type") == "BOSS":return false
	return a.att.maxHp > b.att.maxHp

class b_xueFeng:
	extends Buff
	var buffName = "雪风分摊"
	var cha
	func _init(cha):
		attInit()
		id = "b_xueFeng"	
		# att.defL = 0.2
		# att.mgiDefL = 0.2
		# att.reHp = 0.2 
		self.cha = cha
	func _connect():
		masCha.connect("onDeath", self, "onDeath")
	func onDeath(atkInfo):
		cha.awakenProcess += 1
		if not cha.isAwaken and cha.awakenProcess >= 4:
			cha.awaken()
	