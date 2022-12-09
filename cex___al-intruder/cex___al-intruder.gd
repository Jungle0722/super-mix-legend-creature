extends "../azurline_ctrl/Siren.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「塞壬」侵扰者·Lv%d"%level    #角色的名称
	lv = 3             #等级的设置
	attCoe.atkRan = 4#攻击距离
	attCoe.maxHp = 4#最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 4     #攻击力（每点代表8.5）
	attCoe.mgiAtk = 4  #魔法攻击（每点代表13.7）
	attCoe.def = 4     #物理防御（每点代表15）
	attCoe.mgiDef = 4#魔法防御（每点代表16.6）
	atkEff = "atk_dang" #攻击时的特效
	evos = ["cex___al-intruder2"]
	addSkill("每{cd}秒召唤一名随机3级舰娘，并使其获得10层[狂怒][急速]", "援军", "yj", 10)
	addSkill("每{cd}秒对全体敌人造成[物攻*2]({damage})的伤害", "强袭", "qiXi", 10)
	if id == "cex___al-intruder":
		addSkillTxt("[color=#C0C0C0]参加18场战斗后，将进化为传奇单位[/color]")

func levelUp():
	.levelUp()
	updateAtt()

func updateAtt():
	updateTmpAtt("maxHp", 100, false)
	updateTmpAtt("atk", 15, false)
	updateTmpAtt("mgiAtk", 0, false)
	updateTmpAtt("def", 10, false)
	updateTmpAtt("mgiDef", 10, false)
	updateTmpAtt("spd", 0.03, false)
	if level == 20 and gSiren.sirenAwaken:
		call("awaken")
		updateTmpAtt("maxHp", 1000, false)
		updateTmpAtt("atk", 150, false)
		updateTmpAtt("mgiAtk", 100, false)
		updateTmpAtt("def", 100, false)
		updateTmpAtt("mgiDef", 100, false)
	upAtt()

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="qiXi":
		qiXi()
	if id=="yj":
		yj()
#强袭系数 
var p3 = 2
func qiXi():
	utils.createSkillTextEff("强袭", position)
	var chas = getAllChas(1)
	for i in chas:
		azurHurtChara(i, att.atk*p3, Chara.HurtType.PHY, Chara.AtkType.EFF, "强袭")
		
var summ = utils.lv3
func yj():
	var cha = newChara(summ[sys.rndRan(0,summ.size()-1)], self.cell)
	if cha != null:
		cha.addBuff(buffUtil.b_kuangNu_r.new(10))
		cha.addBuff(buffUtil.b_jiSu_r.new(10))

func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)
	if atkInfo.atkType == Chara.AtkType.NORMAL and lv == 4:
		qx(atkInfo.hitCha)

func qx(cha):
	var eff:Eff = newEff("sk_feiZhan",sprcPos)
	eff._initFlyPos(position + (cha.position - position).normalized() * 1200, 800)
	eff.connect("onInCell",self,"effInCell")

#势如破竹系数
var p4 = 1.5
func effInCell(cell):
	var cha = matCha(cell)
	if cha == null:
		cha = matCha(cell + Vector2(0, 1))
	if cha == null:
		cha = matCha(cell + Vector2(0, -1))
	if cha != null && cha.team != team:
		azurHurtChara(cha, att.atk * p4, Chara.HurtType.PHY, Chara.AtkType.SKILL, "势如破竹")
