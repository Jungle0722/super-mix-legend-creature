extends "../cazurlineC/cazurlineC.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「重巡」安克雷奇"
	attCoe.atkRan = 20  #攻击距离
	attCoe.maxHp += 3   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.mgiAtk += 3     #攻击力（每点代表8.5）
	attCoe.def += 2     #物理防御（每点代表15）
	attCoe.mgiDef += 2     #物理防御（每点代表15）
	lv = 3
	isResearch = true
	autoGetSkill()

	addSkill("攻击会优先锁定正前方的敌人(即同行)，对与自己同一行的敌人造成的伤害提高100%", "线列战术")
	addSkill("<固化><先手>每12秒对当前目标发射具有穿透性的光束，并持续轰击5秒，\n每半秒对被轰击的敌人造成[法强*1]({damage})的可暴击技能伤害", "极子光矛")

	setCamp("白鹰")
	evos = ["cex___alr-anchorage2"]
	canCopy = false
	supportSpecEvo = 2
	ename = "ankeleiqi"
		
var skFlag = 0
func _upS():
	._upS()
	setAiCha(aiCha)
	skFlag += 1
	if skFlag >= 12:
		skFlag = 0
		var index = 0
		var tcell = aiCha.cell
		var tpos = aiCha.global_position
		for num in range(32):
			index += 1
			createJiGuang(tpos, self)
			var dmg = getSkillEffect("极子光矛")
			if upgraded:
				dmg *= (1 + att.cd)
			if index >= 3:
				index = 0
				var lineChas = utils.lineChas(cell, tcell, 10)
				for cha in utils.lineChas(cell, tcell, 10):
					if cha.team != team:
						azurHurtChara(cha, dmg, Chara.HurtType.MGI, Chara.AtkType.SKILL, "极子光矛", true)
						if lv == 4 and sys.rndPer(30):
							#激光折射
							var enemy = null
							var chas = []
							for i in getAllChas(1):
								if not lineChas.has(i):
									chas.append(i)
							if not chas.empty():
								enemy = sys.rndListItem(chas)
							if enemy == null:
								continue
							createJiGuang(enemy.global_position, cha)
							for cha2 in utils.lineChas(cha.cell, enemy.cell, 10):
								if cha2.team != team:
									azurHurtChara(cha2, dmg, Chara.HurtType.MGI, Chara.AtkType.SKILL, "极子光矛", true)
			yield(reTimer(0.15),"timeout")
			if not sys.main.isAiStart:return

func createJiGuang(toPos, cha):
	var eff:Eff = cha.newEff("sk_jiGuan", cha.global_position)
	eff.sprLookAt(toPos)
	eff.scale *= 2
	eff.normalSpr.position = Vector2(0, -25)
	eff.spr.scale.x = 1.5		

func _onBattleStart():
	._onBattleStart()
	skFlag = 10

func _onBattleEnd():
	._onBattleEnd()
	skFlag = 0

func setAiCha(cha):
	if cha.cell.y == cell.y:
		aiCha = cha
		return
	var chas = []
	for i in getAllChas(1):
		if i.cell.y == cell.y and not i.isDeath:
			chas.append(i)
	if chas.empty():
		.setAiCha(cha)
	else:
		chas.sort_custom(self, "sortByDistance")
		aiCha = chas[0]
		$ui / Label.text = "%s|%s" % [name, aiCha.name]

func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)		
	if atkInfo.hitCha.cell.y == cell.y:
		atkInfo.factor += 1
	
func getSkillEffect(name):
	.getSkillEffect(name)
	if name == "极子光矛":
		return att.mgiAtk * 1