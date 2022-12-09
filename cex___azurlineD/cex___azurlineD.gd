extends "../cazurlineD_1_1/cazurlineD_1_1.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」俾斯麦·誓约"   #角色的名称
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 2     #攻击力（每点代表8.5））
	attCoe.mgiAtk += 2
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	lv = 4             #等级的设置
	addSkill("我方铁血阵营角色阵亡时对凶手造成[目标血量*0.4]的真实特效伤害", "帝国意志")

	addSkillTxt("[color=#C0C0C0][现代化改造]-帝国意志伤害系数+0.2(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	setCamp("铁血")
var baseId = ""
var p4 = 0.4
func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	p4 = 0.6

func _onBattleStart():
	._onBattleStart()
	for i in getAllChas(2):
		if i.get("camp") == "铁血" or i.get("camp") == "撒丁帝国":
			i.addBuff(b_bismark2.new(p4, self))

class b_bismark2:
	extends Buff
	var buffName = "帝国意志"
	var p = 0.25
	var cha = null
	func _init(p = 0.25, cha = null):
		attInit()
		id = "b_bismark2"	
		self.p = p
		self.cha = cha
	func _connect():
		masCha.connect("onDeath",self,"_onDeath")
	func _onDeath(atkInfo):
		if atkInfo.hurtVal > 0 and not atkInfo.atkCha.isDeath:
			cha.azurHurtChara(atkInfo.atkCha, atkInfo.atkCha.att.maxHp*p, Chara.HurtType.REAL, Chara.AtkType.EFF, "帝国意志")