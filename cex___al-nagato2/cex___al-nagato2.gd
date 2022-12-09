extends "../cex___al-nagato/cex___al-nagato.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」长门·花嫁"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 2
	attCoe.def += 1
	attCoe.mgiDef += 1
	lv = 4             #等级的设置
	addSkill("<唯一>战斗开始时，所有友军射程+1，且造成非特效伤害时，附带长门物攻80%的物理伤害，持续10秒", "舰队指挥")

	addSkillTxt("[color=#C0C0C0][现代化改造]-舰队指挥持续时间翻倍且追加[重樱舰娘使用技能时20%重置冷却]效果(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var p4 = 10
func upgrade():
	p4 = 20
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
func cm_bigSeven():
	var chas = getAllChas(2)
	for i in chas:
		if not i.hasBuff("b_bigSeven") && not i.isSumm:
			i.addBuff(b_bigSeven.new(p4, upgraded, self))
	
func _onBattleStart():
	._onBattleStart()
	cm_bigSeven()

var baseId = ""

#舰队指挥
class b_bigSeven:
	extends Buff
	var buffName = "舰队指挥"
	var buffUtil = globalData.infoDs["g_azurlineBuffs"]
	var dispel = 2
	var upgraded = false
	var cha 
	func _init(lv = 10, upgraded = false, cha = null):
		attInit()
		att.atkRan = 1
		life = lv
		self.upgraded = upgraded
		self.cha = cha
	func _connect():
		masCha.connect("onAtkChara",self,"_onAtkChara")
		if upgraded and masCha.get("camp") == "重樱":
			masCha.connect("onCastCdSkill",self,"onCastCdSkill")
	func _onAtkChara(atkInfo:AtkInfo):
		if atkInfo.atkType != Chara.AtkType.EFF:
			cha.azurHurtChara(atkInfo.hitCha, cha.att.atk*0.8, Chara.HurtType.PHY, Chara.AtkType.EFF, "舰队指挥")
	func onCastCdSkill(id):
		if sys.rndPer(20):
			var skill = masCha.getSkill(id)
			skill.nowTime += skill.cd/(1+masCha.att.cd)