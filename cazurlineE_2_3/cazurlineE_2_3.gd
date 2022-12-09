extends "../cazurlineE_2/cazurlineE_2.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「航母」英仙座"   #角色的名称
	attCoe.maxHp += 3   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.mgiAtk += 1     #攻击力（每点代表8.5）
	lv = 3             #等级的设置
	evos = ["cazurlineE_2_3_1"]
	addSkill("<固化>每秒对血量最低的敌人造成[法强*2.4]({damage})的伤害", "群星坠落")
	ename = "yingxianzuo"
	autoGetSkill()
	setCamp("皇家")
#群星坠落伤害加成
var p3 = 1
func _upS():
	._upS()
	qxzl()

func qxzl():
	var cha = getFirstCha(1, "sortByNowHp")
	if cha != null:
		createCustEff(cha.position, "eff/starDown", 10, false, 1.8, Vector2(0, -20))
		if team == 2:
			p3 = 0.1
		azurHurtChara(cha, getSkillEffect("群星坠落") * p3, Chara.HurtType.MGI, Chara.AtkType.SKILL, "群星坠落")
		if upgraded and not cha.isDeath and team == 1:
			cha.addBuff(buffUtil.b_shaoZhuo_r.new(5, self))

func getSkillEffect(name):
	.getSkillEffect(name)
	if name == "群星坠落":
		return att.mgiAtk * 2.2		