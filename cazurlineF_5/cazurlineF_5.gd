extends "../cazurlineF/cazurlineF.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「辅助」绊爱"   #角色的名称
	attCoe.mgiAtk += 1  #魔法攻击（每点代表13.7）
	attCoe.maxHp += 1
	attCoe.def += 1
	attCoe.mgiDef += 1
	lv = 2             #等级的设置
	evos = ["cazurlineF_5_1"]
	addSkill("每{cd}秒对随机队友造成[法强*2]的伤害，并获得[伤害量*1%]({damage})的金币(一回合上限60金)", "痛击队友", "sk_banai2", 5)

	setCamp("其他")
var limit = 60
var p2 = 0.01
var gold = 0
var zhuanShu = false
func _onBattleEnd():
	._onBattleEnd()
	sys.main.player.plusGold(gold)
	gold = 0
	skFlag = true

func _onBattleStart():
	._onBattleStart()	
	for i in items:
		if i.id == "i_azurline_huangyouyou" and team == 1:
			zhuanShu = true
			break

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="sk_banai":
		sk_banai()
	if id=="sk_banai2":
		sk_banai2()

func sk_banai():
	var cha = utils.getRndEnemy(self)
	if team == 2:
		azurHurtChara(cha, min(cha.att.maxHp*0.6, att.mgiAtk*4), Chara.HurtType.MGI, Chara.AtkType.EFF, "保护对手")
	else:
		healCha(cha, att.mgiAtk*3)
	if gold < limit and team == 1:
		gold += att.mgiAtk*3*p2

func sk_banai2():
	var cha
	if zhuanShu:
		cha = utils.getRndEnemy(self)
	else:
		cha = utils.getRndAlly(self)
	if team == 2:
		healCha(cha, att.mgiAtk*3)
	else:
		azurHurtChara(cha, att.mgiAtk*2, Chara.HurtType.MGI, Chara.AtkType.SKILL, "痛击队友", true)
	if gold < limit and team == 1:
		gold += att.mgiAtk*3*p2
var skFlag = true
func _upS():
	._upS()
	if skFlag and gold >= limit:
		skFlag = false
		for i in getAllChas(1):
			if i.hasBuff("b_xuanYun") == null:
				i.addBuff(buffUtil.b_xuanYun.new(4))
