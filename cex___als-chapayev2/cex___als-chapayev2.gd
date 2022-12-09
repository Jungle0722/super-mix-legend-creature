extends "../cex___als-chapayev/cex___als-chapayev.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「轻巡」恰巴耶夫·改"   #角色的名称
	attCoe.atkRan = 3
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.mgiAtk += 1
	attCoe.def += 1
	attCoe.mgiDef += 1
	lv = 4             #等级的设置
	addSkill("战斗开始时，将正前方的友军阵营改为北方联合，北方联合阵营的友军受到技能伤害时，\n					立即对攻击者发动精准诱导", "北境血统")
	addSkillTxt("[color=#C0C0C0][现代化改造]-虚空白骑兵触发概率+10%(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
func upgrade():
	p3 = 30
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""

func _onBattleStart():
	._onBattleStart()
	var cha = sys.main.matCha(cell + Vector2(1, 0))
	if cha != null && cha.team == team:
		if cha.get("camp") != "北方联合" and cha.get("campTmp") != "北方联合" and cha.get("tag") == "azurline":
			cha.campTmp = "北方联合"

	for i in getAllChas(2):
		if (i.get("camp") == "北方联合" or i.get("campTmp") == "北方联合") and i.chaName.find("恰巴耶夫") == -1:
			i.addBuff(b_chapayev1.new(self))
			
#北境血统
class b_chapayev1:
	extends Buff
	var buffName = "北境血统"
	var cha
	var dispel = 2
	var utils = globalData.infoDs["g_azurlineUtils"]
	func _init(cha = null):
		id = "b_chapayev1"
		self.cha = cha
	func _connect():
		if masCha.chaName.find("恰巴耶夫") == -1:
			masCha.connect("onHurt",self,"onHurt")
	func onHurt(atkInfo):
		if atkInfo.atkType == Chara.AtkType.SKILL:
			cha.preciseInduction(atkInfo.atkCha)
