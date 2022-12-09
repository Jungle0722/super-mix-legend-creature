extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "改良蓄电池阵列"
	att.maxHp = 300
	att.maxHpL = 0.2
	info = "每次受到技能伤害，永久提高2点血量加成(上限4000)\n[color=#DC143C]同时装备三件时可升级[/color]\n该特效无法作为科研素材"
	if sys.rndPer(utils.rareItem) && sys.main != null:
		rare()
var limit = 4000
var p = 2
func _connect():
	utils.itemUpgrade(self)
	masCha.connect("onHurt", self, "onHurt")

func onHurt(atkInfo):
	if atkInfo.atkType == Chara.AtkType.SKILL and att.maxHp < limit:
		att.maxHp += p

var upgraded = false
func upgrade():
	name = "[color=#FFFF00]改良蓄电池阵列·改"
	info = "每次受到技能伤害，永久提高4点血量加成(上限8000)\n该特效无法作为科研素材"
	att.maxHp = 600 * relic.equipBonus
	att.maxHpL = 0.4 * relic.equipBonus
	limit = 8000

func rare():
	name = "[color=#FF00FF][稀有]改良蓄电池阵列"
	att.maxHp = 400
	att.maxHpL = 0.3
