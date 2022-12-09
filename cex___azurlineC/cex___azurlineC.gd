extends "../cazurlineC_1_1/cazurlineC_1_1.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「重巡」高雄·花嫁"   #角色的名称
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 2     #攻击力（每点代表8.5））
	attCoe.mgiAtk += 2
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	lv = 4             #等级的设置
	addSkill("战斗开始时对敌方武艺最强者(物攻最高且不为斩首目标)发起挑战，强迫其与自己决斗，\n并附加10秒[恐惧](无法暴击)，若十秒后战斗仍未结束，则将其秒杀", "以暴制暴")

	addSkillTxt("[color=#C0C0C0][现代化改造]-暴击后获得的圣盾层数+1(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	setCamp("重樱")
var baseId = ""
var jueDou = 10

var enemyCha = null
func _onBattleStart():
	._onBattleStart()
	var chas = getAllChas(1)
	chas.sort_custom(self,"sort2")
	enemyCha = chas[0]
	for i in chas:
		if not i.isDeath && not i.isSumm:
			enemyCha = i
	enemyCha.aiCha = self
	enemyCha.addBuff(b_ybzb_kj.new())

func _upS():
	._upS()
	jueDou -= 1
	if jueDou < 0 && enemyCha != null && not enemyCha.isDeath:
		azurHurtChara(enemyCha, enemyCha.att.maxHp*1, Chara.HurtType.REAL, Chara.AtkType.EFF, "以暴制暴")

func sort2(a,b):
	if a.get("type") == "BOSS":
		return false
	return a.att.atk > b.att.atk

func _onBattleEnd():
	._onBattleEnd()
	enemyCha = null
	jueDou = 10

class b_ybzb_kj:
	extends Buff
	var buffName = "恐惧"
	func _init():
		attInit()
		id = "b_ybzb_kj"
		att.cri -= 1
		isNegetive = true
		life = 10

func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	p3 = 2