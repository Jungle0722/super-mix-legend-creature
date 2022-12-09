extends "../azurline_base_item/azurline_rare_item.gd"
func init():
	.init()
	name = "[稀有]存钱罐"
	att.maxHp = 200
	price = 300
	info = "战斗开始后，每秒积蓄2金币，使用技能会增加2点积蓄，受到敌方的伤害会损失30%积蓄，回合结束时结算，每回合上限80\n[color=#DC143C]同时装备两件时可升级[/color]\n[color=#C0C0C0]特效可被科研装备吞噬"

func _connect():
	._connect()
	masCha.connect("onCastCdSkill",self,"onCastCdSkill")
	sys.main.connect("onBattleEnd",self,"end")
	masCha.connect("onHurt",self,"onHurt")

func onCastCdSkill(id):
	num += p

func _upS():
	if masCha == null || not utils.inBattle(masCha):return
	num += p

var p = 2
var num = 0
func end():
	if masCha == null || not utils.inBattle(masCha):return
	num = min(p*80, num)
	sys.main.player.plusGold(num)
	num = 0

func onHurt(atkInfo):
	if atkInfo.hitCha.team != atkInfo.atkCha.team:
		num *= 0.7