extends "../cazurlineB/cazurlineB.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「轻巡」水星纪念"   #角色的名称
	attCoe.atkRan = 3
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 2     #攻击力（每点代表8.5）
	attCoe.mgiAtk += 2
	attCoe.def += 2     #物理防御（每点代表15）
	attCoe.mgiDef += 2  #魔法防御（每点代表16.6）
	lv = 3             #等级的设置
	evos = ["cex___alcamp-merkuria2"]
	canCopy = false
	ename = "shuixingjinian"

	addSkill("每次普攻50%概率积攒1点[火]，每次使用技能积攒2点[雷]，每次受到普攻50%概率积攒1点[冰]", "元素收集")
	addSkill("每种能量最多积攒3点，每3秒降低1点，每点[火]提高50%双攻，每点[雷]提高50%技能伤害，\n每点[冰]提高15%减伤", "元素反馈")

	autoGetSkill()
	supportSpecEvo = 2
	setCamp("北方联合")
	
var ice:int = 0
var fire:int = 0
var thunder:int = 0
var maxEle:int = 3

var skIndex = 0
func _upS():
	._upS()
	skIndex += 1
	if skIndex >= 3:
		skIndex = 0
		changeIce(-1)
		changeFire(-1)
		changeThunder(-1)

func changeIce(num):
	ice += num
	ice = clamp(ice + num, 0, maxEle)

func changeFire(num):
	fire += num
	fire = clamp(fire + num, 0, maxEle)

func changeThunder(num):
	thunder += num
	thunder = clamp(thunder + num, 0, maxEle)

func _castCdSkill(id):
	._castCdSkill(id)
	changeThunder(1)

func _onBattleEnd():
	._onBattleEnd()
	ice = 0
	fire = 0
	thunder = 0
	skIndex = 0

func _onBattleStart():
	._onBattleStart()
	addBuff(b_merkuria.new())

class b_merkuria:
	extends Buff
	var buffName = "火"
	var dispel = 2
	func _init():
		attInit()
		id = "b_merkuria"
	func _upS():
		att.atkL = masCha.fire * 0.5
		att.mgiAtkL = masCha.fire * 0.5

func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)
	if atkInfo.atkType == Chara.AtkType.SKILL and thunder > 0:
		atkInfo.factor += thunder * 0.5
	if atkInfo.atkType == Chara.AtkType.NORMAL:
		changeFire(1)

func _onHurt(atkInfo):
	._onHurt(atkInfo)
	atkInfo.hurtVal *= (1 - ice * 0.15)
	if atkInfo.atkType == Chara.AtkType.NORMAL:
		changeIce(1)