extends Talent

var buffUtil = globalData.infoDs["g_azurlineBuffs"]
func init():
	name = "护盾预充"
func _connect():
	sys.main.connect("onBattleStart",self,"run6")

func run6():
	for i in sys.main.btChas:
		if i.team == 1 and i.get("tag") == "azurline":
			i.plusShield(i.att.maxHp*0.6)

func get_info():
	return "战斗开始时，我方所有角色获得[血上限*60%]的护盾值\n[color=#DC143C]此天赋不需要升级，仅对碧蓝航线角色生效"


