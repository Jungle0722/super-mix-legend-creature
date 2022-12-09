extends "../cazurlineB_4_2/cazurlineB_4_2.gd"
func _info():
	pass
func _connect():
	._connect()
var baseId = ""
func _extInit():
	._extInit()
	chaName = "「轻巡」圣女贞德·改"   #角色的名称
	attCoe.mgiAtk += 5     #攻击力（每点代表8.5）
	attCoe.maxHp += 1
	lv = 4             #等级的设置
	addSkill("每{cd}秒对目标周围2格的敌人造成[法强*2.5]({damage})的技能伤害，并附加5层<失明>，目标周围2格的友军附加5层<活力>", "神圣新星", "holyBurst", 7)
	addSkillTxt("[color=#C0C0C0][现代化改造]-神圣新星作用范围+1(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	setGunAndArmor("中型","中型")

func _castCdSkill(id):
	._castCdSkill(id)
	if id == "holyBurst" and aiCha != null:
		holyBurst()
	
func holyBurst():
	for i in getCellChas(aiCha.cell,p4,1):
		azurHurtChara(i, getSkillEffect("神圣新星"), Chara.HurtType.MGI, Chara.AtkType.SKILL, "神圣新星", true)
	for i in getCellChas(aiCha.cell,p4,2):
		buffUtil.addHuoLi(i, self, 5)

var p4 = 2
func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	p4 = 3
	