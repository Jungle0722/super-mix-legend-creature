extends "../cex___warship/cex___warship.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「轰炸机」神风特攻队"   #角色的名称
	attCoe.atkRan = 4  #攻击距离
	attCoe.maxHp = 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 1     #攻击力（每点代表8.5）
	attCoe.mgiAtk = 1  #魔法攻击（每点代表13.7）
	attCoe.def = 1     #物理防御（每点代表15）
	attCoe.mgiDef = 1 #魔法防御（每点代表16.6）
	lv = 1             #等级的设置
	atkEff = "atk_dang" #攻击时的特效
	isSumm = true

func _upS():
	._upS()
	if not hasBuff("b_sniper"):
		addBuff(buffUtil.b_sniper.new())
var summoner
var baseId = ""
var ex = 0
func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)
	if atkInfo.atkType == AtkType.NORMAL: 
		var chas = getCellChas(atkInfo.hitCha.cell,1)
		for i in chas:
			summoner.azurHurtChara(i, min(40000, i.att.maxHp) * (0.65 + ex), HurtType.MGI, Chara.AtkType.EFF, "神风")
		forceKillCha(self)

func _onDeath(atkInfo):
	._onDeath(atkInfo)
	var chas = getCellChas(aiCha.cell, 1)
	for i in chas:
		summoner.azurHurtChara(i, min(40000, i.att.maxHp) * (0.65 + ex), HurtType.MGI, Chara.AtkType.EFF, "神风")
	forceKillCha(self)