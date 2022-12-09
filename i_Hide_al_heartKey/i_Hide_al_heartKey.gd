extends "../azurline_base_item/azurline_rare_item.gd"
func init():
	.init()
	name = "[稀有]心之钥匙"
	info = "若佩戴者连续8回合战斗没有阵亡过，则自动使其进化[color=#DC143C](27层后方能使用)[/color]\n当前进度：0/8\n会按照该角色的进化路线进化，若存在多个分支，则随机选择其一\n变更佩戴者会重置进度\n[color=#DC143C]同时装备两件时可升级[/color]"
	price = 200
	att.maxHp = 800
	att.def = 100
	att.mgiDef = 100
	
func _connect():
	._connect()
	sys.main.connect("onBattleEnd",self,"end")
	masCha.connect("onDeath", self, "onDeath")
	num = 0

var txt = "若佩戴者连续8回合战斗没有阵亡过，则自动使其进化[color=#DC143C](27层后方能使用)[/color]\n当前进度：%d/8\n会按照该角色的进化路线进化，若存在多个分支，则随机选择其一\n变更佩戴者会重置进度\n[color=#DC143C]同时装备两件时可升级[/color]"

var num = 0
func end():
	if masCha == null or masCha.evos.empty() or not utils.inBattle(masCha) or difficult.step < 27:return
	num += 1
	if num >= 8:
		utils.evoCha(masCha, sys.rndListItem(masCha.evos))
		num = 0
	info = txt%num

func onDeath(atkInfo):
	if masCha.isDeath:
		num = 0
		info = txt%num
