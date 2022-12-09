extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "四联380MM主炮"
	att.spd = 0.5
	info = "每普攻3次，对目标周围(九宫格范围)的敌人造成[物攻*2.5]的物理伤害\n[color=#DC143C]同时装备三件时可升级[/color]\n基础属性数值随机浮动"
	if sys.rndPer(utils.rareItem) && sys.main != null:
		rare()

func _connect():
	masCha.connect("onAtkChara",self,"onAtkChara")
	utils.itemUpgrade(self)

var atkNum = 0
func onAtkChara(atkInfo:AtkInfo):
	if atkInfo.atkType == Chara.AtkType.NORMAL:
		atkNum += 1
		if atkNum >= 3 and count < 2:
			count += 1
			for i in aroundCells:
				var cha = masCha.matCha(atkInfo.hitCha.cell+i)
				if cha != null && cha.team != masCha.team:
					masCha.azurHurtChara(cha, masCha.att.atk * p, Chara.HurtType.PHY, Chara.AtkType.EFF, "四联380MM主炮")
			atkNum = 0

var p = 2.5
var upgraded = false
func upgrade():
	name = "[color=#FFFF00]四联380MM主炮·改"
	att.spd = 1 * relic.equipBonus
	info = "每普攻3次，对目标周围(九宫格范围)的敌人造成[物攻*5]的物理伤害"
	p = 5

func rare():
	name = "[color=#FF00FF][稀有]四联380MM主炮"
	att.spd = 0.7
	
var count = 0
func _upS():
	count = 0