extends "../cazurlineA_5_2/cazurlineA_5_2.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「驱逐」塔什干·改"   #角色的名称
	attCoe.atk += 1     #攻击力（每点代表8.5））
	attCoe.mgiAtk += 1
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 2  #魔法防御（每点代表16.6）
	lv = 4             #等级的设置
	addSkill("战斗开始时，为正后方的1名友军提供辅助，每{cd}秒使其下3次造成的技能伤害翻倍", "着弹侦测", "zhuoDanZC", 8)
	addSkillTxt("[color=#C0C0C0][现代化改造]-着弹侦测改为对周围(九宫格)范围内的友军生效(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

var baseId = ""
var bindCha = []

class b_tashigan:
	extends Buff
	var buffName = "着弹侦测"
	var dispel = 2
	var num = 3
	func _init():
		attInit()
		id = "b_tashigan"
	func _connect():
		masCha.connect("onAtkChara",self,"_onAtkChara")
	func _onAtkChara(atkInfo:AtkInfo):
		if atkInfo.atkType == Chara.AtkType.SKILL:
			atkInfo.hurtVal *= 2
			num -= 1
		if num <= 0:
			isDel = true

func _onBattleStart():
	._onBattleStart()
	if upgraded:
		for i in getNearChas(cell):
			bindCha.append(i)
	else:
		bindCha.append(sys.main.matCha(cell + Vector2(-1, 0)))

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="zhuoDanZC":
		zhuoDanZC()
		
func _onBattleEnd():
	._onBattleEnd()
	bindCha.clear()

func zhuoDanZC():
	for i in bindCha:
		if i.isDeath:continue
		utils.createSkillTextEff("着弹侦测", position)
		utils.createSkillTextEff("着弹侦测", i.position)
		i.addBuff(b_tashigan.new())

func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	p32 = 4