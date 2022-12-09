extends "../cazurlineE/cazurlineE.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「航母」光辉"   #角色的名称
	attCoe.atkRan = 2  #攻击距离
	attCoe.maxHp = 6   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 1     #攻击力（每点代表8.5）
	attCoe.mgiAtk = 4  #魔法攻击（每点代表13.7）
	attCoe.def = 4     #物理防御（每点代表15）
	attCoe.mgiDef = 5  #魔法防御（每点代表16.6）
	lv = 3             #等级的设置
	atkEff = "atk_dao" #攻击时的特效
	evos = ["cazurlineE_1_2_1"]

	addSkill("<先手>每{cd}秒起飞一架受自身血量加成的<舰载机>(←点击可查看说明)", "舰载机", null, null, 0)
	addSkill("每{cd}秒恢复生命值最低的3名友军[施法者血上限*15%]({damage})的生命值(可暴击)", "舰队支援", "supportGH", 5)
	addSkill("受到伤害时回复[5%*血上限]({damage})的血量，受到技能伤害时，会将伤害转移给自己的舰载机", "装甲空母")
	type2 = "doctor"
	autoGetSkill()
	setGunAndArmor("小型","超重型")
	setCamp("皇家")
	itemEvoCha2 = "cex___almiu-illustrious"
	ename = "guanghui"

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="supportGH":
		cast1()

func cast1():
	var chas = getAllChas(2)
	chas.sort_custom(self,"sortByHp")
	var dmg = att.maxHp * 0.16
	if sys.rndPer(att.cri * 100):dmg *= 2+att.criR
	for i in range(3):
		if i >= chas.size() : break
		healCha(chas[i], dmg)

func castPlane():
	var summ = summPlane()
	if summ != null && not summ.isDeath and team == 1:
		var ap = float(att.maxHp)
		summ.attAdd.maxHp += ap*lv/10.0
		summ.plusHp(ap*lv/10.0)
		summ.attAdd.def += ap*lv/20.0
		summ.attAdd.mgiDef += ap*lv/20.0
		summ.attAdd.atk += ap*lv/50.0
		summ.upAtt()
var p3 = 0.05
func _onHurt(atkInfo):
	._onHurt(atkInfo)
	if enable:
		if atkInfo.atkType == Chara.AtkType.SKILL:
			for i in summedCha:
				if not i.isDeath:
					atkInfo.atkCha.azurHurtChara(i, atkInfo.atkVal, atkInfo.hurtType, Chara.AtkType.EFF, atkInfo.get("skill"))
					atkInfo.hurtVal = 0
					return
		healCha(self, att.maxHp*p3)
		enable = false

var enable = true
func _upS():
	._upS()
	enable = true