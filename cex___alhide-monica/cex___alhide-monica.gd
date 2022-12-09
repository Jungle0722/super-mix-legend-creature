extends "../cazurlineB/cazurlineB.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「轻巡」莫妮卡"   #角色的名称
	attCoe.def += 2  #魔法攻击（每点代表13.7）
	attCoe.mgiDef += 2
	attCoe.maxHp += 1
	attCoe.atkRan = 3
	lv = 3             #等级的设置
	evos = ["cex___alhide-monica2"]
	canCopy = false
	type = "cl"
	addSkill("邀请所有人来打牌，战斗开始时，所有角色都roll点(0-100)，点数低于莫妮卡的敌人，\n			损失50%血量与血上限(对塞壬效果减半)", "鬼牌游戏")
	addSkill("每{cd}秒恢复点数低于莫妮卡的友军50%血量，并使其获得5层<狂怒><急速>", "同花顺", "sk_monica", 5)
	addSkill("若莫妮卡的点数为全场最低，则会使她黯然离场，并使所有敌人获得20层<活力>", "时运")
	ename = "monika"
	autoGetSkill()
	supportSpecEvo = 2
	setCamp("其他")

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="sk_monica1":
		sk_monica1()

func sk_monica1():
	for i in ally:
		if not i.cha.isDeath and i.num < point:
			healCha(i.cha, i.cha.att.maxHp*0.5)
			i.cha.addBuff(buffUtil.b_kuangNu_r.new(5))
			i.cha.addBuff(buffUtil.b_jiSu_r.new(5))

func _onBattleStart():
	._onBattleStart()
	for i in items:
		if i.id == "i_Hide_al_dice":
			touZi = true
			break
	playPai()

func _onBattleEnd():
	._onBattleEnd()
	point = 0
	enemy = []
	ally = []
	touZi = false

var point = 0
var enemy = []
var ally = []
var touZi = false
func playPai():
	enemy = []
	var minPoint = true
	var selfMin = 0
	if touZi:selfMin += 5
	if upgraded:selfMin += 10

	for i in getAllChas(1):
		var res = {"cha":i, "num":sys.rndRan(0, 100)}
		enemy.append(res)

	ally = []
	for i in getAllChas(2):
		if i == self:
			point = sys.rndRan(selfMin, 100)
			utils.createSkillTextEff(point, i.position)
		else:
			var res = {"cha":i, "num":sys.rndRan(0, 100)}
			ally.append(res)

	yield(reTimer(0.2),"timeout")
	for i in enemy:
		if i.num < point:
			if not i.cha.isDeath:
				if i.cha.get("type") == "BOSS":
					i.cha.forceHurtSelf(i.cha.att.maxHp*0.25)
					i.cha.attAdd.maxHpL -= 0.25
					increDmgNum(i.cha.att.maxHp*0.25, "鬼牌游戏", i.cha)
				else:
					i.cha.forceHurtSelf(i.cha.att.maxHp*0.5)
					increDmgNum(i.cha.att.maxHp*0.5, "鬼牌游戏", i.cha)
					i.cha.attAdd.maxHpL -= 0.5
				i.cha.upAtt()
				createCustEff(i.cha.position, "eff/zhongDu", 10, false, 1.2, Vector2(0, -20))
			minPoint = false
	for i in ally:
		if i.num < point:minPoint = false
	if minPoint:
		sys.newBaseMsg("事件", "时运不济，莫妮卡竟是全场点数最低的！")
		forceKillCha(self)
		for i in getAllChas(1):
			buffUtil.addHuoLi(i, self, 20)