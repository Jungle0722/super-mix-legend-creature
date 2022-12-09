extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "晃悠悠"
	att.maxHp = 200
	att.cd = 0.3
	info = "每秒对周围1格(十字)范围的敌人造成[目标血上限2%]的真实技能伤害\n召唤物装备时此特效伤害减半\n[color=#DC143C]同时装备三件时可升级，升级后绊爱装备会有奇效..."
	if sys.rndPer(utils.rareItem) && sys.main != null:
		rare()
	
func _connect():
	utils.itemUpgrade(self)
	sys.main.connect("onBattleEnd", self, "onBattleEnd")
	if masCha.isSumm:
		p *= 0.4
	if masCha.chaName.find("绊爱") > -1 and upgraded:
		info = hiddenText
		zhuanShu = true
	else:
		zhuanShu = false
		if upgraded:info = upgradedText
		else:info = normalText

var normalText = "每秒对周围1格(十字)范围的敌人造成[目标血上限2%]的真实技能伤害\n召唤物装备时此特效伤害减半\n[color=#DC143C]同时装备三件时可升级，升级后绊爱装备会有奇效..."
var upgradedText = "每秒对周围1格(十字)范围的敌人造成[目标血上限4%]的真实伤害\n召唤物装备时此特效伤害减半\n[color=#DC143C]绊爱装备后会有奇效..."
var hiddenText = "每秒对周围1格(十字)范围的敌人造成[目标血上限4%]的真实伤害\n召唤物装备时此特效伤害减半\n[color=#DC143C]绊爱专属：绊爱不再痛击队友，而是痛击敌人，同时本装备的特效会对友方单位造成伤害，并获得[伤害量1%]的金币(每回合上限30金)"
var zhuanShu = false
var gold = 0
func _upS():
	if masCha == null || not utils.inBattle(masCha):return
	var p2 = 1
	if masCha.isSumm:p2 = 0.5
	for i in masCha.getCellChas(masCha.cell, 1, 1):
		if masCha.get("tag") == "azurline":
			masCha.azurHurtChara(i, i.att.maxHp*p*p2, Chara.HurtType.REAL, Chara.AtkType.SKILL, "晃悠悠")
		else:
			masCha.hurtChara(i, i.att.maxHp*p*p2, Chara.HurtType.REAL, Chara.AtkType.SKILL)
	if zhuanShu:
		for i in masCha.getCellChas(masCha.cell, 1, 1):
			var dmg = i.att.maxHp*p
			masCha.azurHurtChara(i, dmg, Chara.HurtType.REAL, Chara.AtkType.SKILL, "晃悠悠")
			if gold < 30 and masCha.team == 1:
				sys.main.player.plusGold(min(30, dmg*0.01))

func onBattleEnd():
	gold = 0			

var upgraded = false
var p = 0.02
func upgrade():
	name = "[color=#FFFF00]晃悠悠·改"
	info = upgradedText
	att.maxHp = 400 * relic.equipBonus
	att.cd = 0.5 * relic.equipBonus
	p = 0.04

func rare():
	name = "[color=#FF00FF][稀有]晃悠悠"
	att.maxHp = 300
	att.cd = 0.4
