extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "[特殊]深度训练设备"
	info = "若佩戴者为塞壬或余烬舰娘，则使其成长速度提高100%\n来源：成就奖励"
	att.atk = 100
	att.mgiAtk = 100
	att.def = 50
	att.mgiDef = 50
	price = 50
func _connect():
	sys.main.connect("onBattleStart",self,"start")

func start():
	if masCha != null and masCha.get("type") == "siren":
		masCha.battleExp += 1