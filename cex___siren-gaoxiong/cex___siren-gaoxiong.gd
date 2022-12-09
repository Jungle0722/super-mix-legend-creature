extends "../azurline_ctrl/SirenHead.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「神秘」高雄·黑化"   #角色的名称
	attCoe.atkRan = 4  #攻击距离
	attCoe.maxHp = 100  #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 20	 #攻击力（每点代表8.5）
	attCoe.mgiAtk = 15  #魔法攻击（每点代表13.7）
	attCoe.def = 6	#物理防御（每点代表15）
	attCoe.mgiDef = 6  #魔法防御（每点代表16.6）
	attAdd.cd += 0.5
	attAdd.cri += 0.5
	attAdd.suck += 0.3
	lv = 4             #等级的设置

	addSkill("每{cd}秒发射一枚重型鱼雷，对目标敌方单位造成物攻*1的真实伤害，并恢复同等数值的生命值", "鱼雷连射", "gx_ylls", 6)
	addSkill("本场战斗内造成普攻伤害时会吸收该单位35%的四维属性为己用，每个角色只能吸一次", "武勋")
	addSkill("击杀敌方单位时，恢复全部生命值，并对附近2格内的所有敌方单位造成[物攻*0.5]的伤害", "余烬")
	addSkill("暴击后获得1层<圣盾>", "威光")

	addSkill("每{cd}秒弱驱散自身所有负面状态", "塞壬之力", "sr", 4)
	isHead = true
	giftCha = "cex___al-gaoxiong"
	unlock = true

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="sr":
		sr()
	if id=="gx_ylls":
		gx_ylls()
func gx_ylls():
	if aiCha != null:
		var d:Eff = newEff("sk_feiDang",sprcPos)
		d._initFlyCha(aiCha)
		yield(d,"onReach")
		azurHurtChara(aiCha, att.atk, Chara.HurtType.REAL, Chara.AtkType.EFF, "鱼雷连射")
		healCha(self, att.atk)

func _onKillChara(atkInfo:AtkInfo):
	._onKillChara(atkInfo)
	healCha(self, att.maxHp)
	var chas = getCellChas(atkInfo.hitCha.cell, 2, 1)
	for i in chas:
		if i != atkInfo.hitCha:
			azurHurtChara(i, att.atk, Chara.HurtType.PHY, Chara.AtkType.SKILL, "余烬")

func _onBattleStart():
	._onBattleStart()
	if team == 2:
		addItem(sys.newItem(utils.getRandomItem("PHY")))
		addItem(sys.newItem(utils.getRandomItem("PHY")))
		addItem(sys.newItem(utils.getRandomItem("DEF")))
		addBuff(buffUtil.b_jiSu_r.new(10))
		
func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)
	if atkInfo.atkType == AtkType.NORMAL && atkInfo.isCri:
		buffUtil.addShengDun(self, 1)
	if atkInfo.atkType == AtkType.NORMAL && not suckCha.has(atkInfo.hitCha):
		var cha = atkInfo.hitCha
		suckCha.append(cha)
		cha.addBuff(utils.buffs.b_wx_sub.new())
		var buff = hasBuff("b_gx_wuXun")
		if buff == null:
			addBuff(b_gx_wuXun.new(cha.att.atk*0.35, cha.att.mgiAtk*0.35, cha.att.def*0.35, cha.att.mgiDef*0.35))
		else:
			buff.att.atk += cha.att.atk*0.35
			buff.att.mgiAtk += cha.att.mgiAtk*0.35
			buff.att.def += cha.att.def*0.35
			buff.att.mgiDef += cha.att.mgiDef*0.35

var suckCha = []

func _onBattleEnd():
	._onBattleEnd()
	suckCha = []
	
class b_gx_wuXun:
	extends Buff
	func _init(atk, mgiAtk, def, mgiDef):
		attInit()
		id = "b_gx_wuXun"	
		att.atk = atk
		att.mgiAtk = mgiAtk
		att.def = def
		att.mgiDef = mgiDef