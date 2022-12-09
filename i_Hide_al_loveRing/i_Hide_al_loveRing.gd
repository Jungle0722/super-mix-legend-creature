extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "[特殊]真爱之戒"
	att.defR = 0.2
	info = "佩戴后即绑定，每参与一场战斗，获得20点[好感度]，100点好感度后即可做[不可描述之事]\n若佩戴者变更，则重置并扣除一半的累积好感\n当前佩戴者：%s，当前好感度：%d" % ["无", 0]
	price = 300
#状态：0损坏1正常2进化
var state = 1
#好感
var num = 0
#佩戴者
var cha = null
func _connect():
	sys.main.connect("onBattleStart",self,"start")
	sys.main.connect("onBattleEnd",self,"end")
	cha = masCha
	if state == 1:
		info = text1 % [masCha.chaName, num]
	if num != 0:
		reset()

const text1 = "佩戴后即绑定，每参与一场战斗，获得20点[好感度]，100点好感度后即可做[不可描述之事]\n若佩戴者变更，则重置并扣除一半的累积好感\n当前佩戴者：%s，当前好感度：%d"
const text2 = "[事后]-战斗开始后提升20%全属性，通关后可获得该角色的真爱成就\n全属性：双攻双防CD攻速双吸双穿暴击爆伤承疗闪避)"

func start():
	if masCha == null || not utils.inBattle(masCha):return
	if state == 2 && cha == masCha:
		masCha.addBuff(b_marry.new())

func end():
	if cha != masCha || not utils.inBattle(masCha):return
	num += 20
	if state == 1: 
		if num >= 100:
			levelUp()
		else:
			info = text1 % [cha.chaName, num]

func reset():
	if state == 2:
		state = 1
	num *= 0.5
	num = int(num)
	var buffName = "无"
	if cha != null:
		name = cha.chaName
	info = text1 % [name, num]

func levelUp():
	state = 2
	info = text2
	
class b_marry:
	extends Buff
	var buffName = "真爱之戒"
	var dispel = 2
	func _init():
		attInit()
		id = "b_marry"
		att.atkL = 0.2
		att.mgiAtkL = 0.2
		att.defL = 0.2 
		att.mgiDefL = 0.2
		att.cd = 0.2
		att.spd = 0.2
		att.suck = 0.2
		att.mgiSuck = 0.2
		att.reHp = 0.2
		att.cri = 0.2
		att.criR = 0.2
		att.dod = 0.2
		att.penL = 0.2
		att.mgiPenL = 0.2
