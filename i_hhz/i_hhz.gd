extends "../azurline_base_item/azurline_base_item.gd"

func init():
	.init()
	name = "黑皇杖"
	att.maxHp = 350
	att.atk = 50
	info = "受到技能伤害进入天神下凡状态，免疫技能伤害，持续8秒\n不受任何负面效果"

func _connect():
	masCha.connect("onHurt",self,"Defense")
	masCha.connect("onAddBuff",self,"onAddBuff")
	sys.main.connect("onBattleStart",self,"StartBattle")

var Starting = false
var hadStarted = false
var goneTime = 0

func StartBattle():
	Starting = false
	hadStarted = false
	goneTime = 0

func _upS():
	if Starting == true:
		goneTime += 1
	if goneTime > 7:
		Starting = false
		hadStarted = true

func Defense(atkInfo:AtkInfo):
	if atkInfo.atkType == Chara.AtkType.SKILL && Starting == true:
		atkInfo.isMiss = true
		atkInfo.atkType = Chara.AtkType.MISS
	if atkInfo.atkType == Chara.AtkType.SKILL && Starting == false && hadStarted == false:
		atkInfo.isMiss = true
		atkInfo.atkType = Chara.AtkType.MISS
		Starting = true

func onAddBuff(buff:Buff):
	if buff.isNegetive :
		buff.isDel = true