extends "../cazurlineD_2/cazurlineD_2.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「战列」让巴尔"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 1     #攻击力（每点代表8.5）
	lv = 3             #等级的设置
	evos = ["cazurlineD_2_2_1"]
	addSkill("普攻有1%几率夺取目标身上的一件装备(对玩家无效)，回合结束时，提高自身装备属性1%", "海盗之魂")

	autoGetSkill()
	setCamp("自由鸢尾")
var p3 = 1
var p3_1 = 100
var p3_2 = 1.01
func _onBattleEnd():
	._onBattleEnd()
	rndBuff = 0
	if sys.rndPer(p3_1):
		for i in items:
			strengthenEquip(i)
var rndBuff = 0

func _onNormalAtk(cha):
	._onNormalAtk(cha)
	if team == 1 and not cha.isSumm and not cha.items.empty():
		if sys.rndPer(p3):
			utils.createSkillTextEff("抢夺装备", position)
			yield(reTimer(0.1),"timeout")
			sys.main.player.addItem(cha.items[0])
		
func strengthenEquip(item):
	item.att.maxHp *= p3_2
	item.att.atk *= p3_2
	item.att.mgiAtk *= p3_2
	item.att.atkRan *= p3_2
	item.att.def *= p3_2
	item.att.mgiDef *= p3_2
	item.att.cri *= p3_2
	item.att.criR *= p3_2
	item.att.suck *= p3_2
	item.att.mgiSuck *= p3_2
	item.att.reHp *= p3_2
	item.att.spd *= p3_2
	item.att.dod *= p3_2