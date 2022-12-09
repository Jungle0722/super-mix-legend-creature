extends "../azurline_base_item/azurline_rare_item.gd"
func init():
	.init()
	name = "[稀有]投影仪"
	info = "战斗开始时会召唤一个佩戴者的克隆体\n[明尼阿波利斯、伊卡洛斯]的克隆体会缺失技能，一个角色只能携带一件本装备\n[color=#DC143C]同时装备两件时可升级[/color]\n[color=#C0C0C0]特效可被科研装备吞噬"
	price = 300
	att.atk = 233
	att.mgiAtk = 233
	att.cd = 0.23
	
func _connect():
	._connect()
	for i in masCha.items:
		if i.id == id && i != self:
			delFromCha()
			return
	sys.main.connect("onBattleStart",self,"runStart")

func runStart():
	if sys.main.matCha(masCha.cell) != masCha || masCha.get("type") == "siren":return
	var cha
	if masCha.has_method("summChara"):
		cha = masCha.summChara(masCha.id)
	else:
		cha = masCha.newChara(masCha.id, masCha.cell)

	for i in masCha.items:
		var item = sys.newItem(i.id)
		if i.get("upgraded") == true && i.has_method("upgrade"):
			item.upgrade()
		cha.addItem(item)
	if cha.has_method("upgrade") and masCha.get("upgraded") == true:
		cha.upgrade()
		cha.upgraded = true


