extends "../cazurlineD_2_1/cazurlineD_2_1.gd"
func _info():
	pass
var baseId = ""
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「战列」厌战·改"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 3     #攻击力（每点代表8.5）
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	addSkill("击杀非召唤单位时，永久提高1点攻击(上限800)，并使该单位相邻的敌人<恐惧>2秒", "皇家传奇")
	addSkill("取消普攻，固定每秒对血量最低的敌人造成[攻击*0.5]({damage})的可暴击普攻伤害，大幅加快弹道速度", "神射手·改")
	addSkillTxt("[color=#C0C0C0][现代化改造]-击杀非召唤单位时，获得4层<狂怒><狂暴>(未解锁)")
	addSkillTxt("[color=#C0C0C0]伴随着无数次的杀戮，厌战终将有新的领悟...")
	if upgraded:
		skillStrs[skillStrs.size()-2] = skillStrs[skillStrs.size()-2].replace("未解锁", "已解锁")
	lv = 4 
	if isAwaken:
		awaken()

func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	skillStrs[skillStrs.size()-2] = skillStrs[skillStrs.size()-2].replace("未解锁", "已解锁")

func awaken(msg = true):
	chaName = "「战列」厌战·觉醒"
	addSkill("自身的攻速可以转化为伤害加成，攻击塞壬时，有50%几率额外发射一枚炮弹", "心智觉醒", null, null, skillStrs.size() - 1)
	if not isAwaken:
		sys.newBaseMsg("事件", "厌战已经获得了心智觉醒！")
	isAwaken = true

func _upS():
	._upS()
	var cha = getFirstCha(1, "sortByNowHp")
	if cha == null:return
	var d:Eff = newEff("sk_feiDang",sprcPos)
	d._initFlyCha(cha, 1200)
	yield(d,"onReach")
	azurHurtChara(cha, getSkillEffect("神射手·改"), Chara.HurtType.PHY, Chara.AtkType.NORMAL, "神射手·改", true)
	if cha.get("type") == "BOSS" and sys.rndPer(40) and not cha.isDeath:
		azurHurtChara(cha, getSkillEffect("神射手·改"), Chara.HurtType.PHY, Chara.AtkType.NORMAL, "神射手·改", true)

func normalAtkChara(cha):
	pass

func _onAtkInfo(atkInfo):
	._onAtkInfo(atkInfo)
	if atkInfo.atkCha == self && atkInfo.atkType == Chara.AtkType.NORMAL:
		atkInfo.canCri = true
var atkNum = 0
func _onKillChara(atkInfo):
	._onKillChara(atkInfo)	
	if atkInfo.hitCha.isSumm:return
	if atkNum < 800:
		updateTmpAtt("atk", 1)
		atkNum += 1
	var chas = getCellChas(atkInfo.hitCha.cell, 1, 1)
	for i in chas:
		i.addBuff(buffUtil.b_twoSpd.new(-3, 2))
	if upgraded:
		addBuff(buffUtil.b_kuangNu_r.new(4))
		addBuff(buffUtil.b_kuangBao.new(4))
	if killNum >= 100 and not isAwaken:
		awaken()

func _onBattleStart():
	._onBattleStart()
	if isAwaken:
		addBuff(b_warspite.new())

class b_warspite:
	extends Buff
	var buffName = "心智觉醒"
	var dispel = 2
	func _init():
		attInit()
		id = "b_warspite"
	func _upS():
		att.atkR = masCha.att.spd * 1.2