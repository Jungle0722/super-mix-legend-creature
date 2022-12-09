extends "../cazurlineD/cazurlineD.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「战列」佐治亚"   #角色的名称
	attCoe.atkRan = 4#攻击距离
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 2     #攻击力（每点代表8.5）
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	lv = 3             #等级的设置
	isResearch = true

	addSkill("战斗开始时，将位于自己同行对称位置的敌人引到附近(若该位置没有敌人，则尝试拉取血\n					上限最低的敌人)，使其眩晕3秒，并强制决斗若该目标死亡，永久提高1点攻击、回满血并再次发动挑战宣言", "挑战宣言")
	addSkill("造成伤害时，若目标的主炮口径小于自己，则必定暴击", "口径碾压")
	addSkill("每秒对周围(九宫格范围)的敌人造成[物攻*2]({damage})的可暴击伤害", "装甲碾压")

	autoGetSkill()
	setCamp("白鹰")
	evos = ["cex___alr-georgia2"]
	canCopy = false
	supportSpecEvo = 2

var p4 = 2

var tzCha = null
func _onBattleEnd():
	._onBattleEnd()
	tzCha = null

func _upS():
	._upS()
	if tzCha != null:
		if tzCha.isDeath:
			tzCha == null
			jdSuccess()
		else:
			tzCha.aiCha = self
	for i in getAroundChas(cell, false):
		var dmg = att.atk * p4
		azurHurtChara(i, dmg, Chara.HurtType.PHY, Chara.AtkType.SKILL, "装甲碾压", true)
		if isAwaken:
			i.addBuff(buffUtil.b_liuXue_r.new(4))
			buffUtil.addLouShui(i, self, 4)

func jdSuccess():
	#决斗胜利
	updateTmpAtt("atk", 1)
	tzxy()
	healCha(self, att.maxHp)
	
func _onBattleStart():
	._onBattleStart()
	tzxy()

#挑战宣言
func tzxy():
	#判定对称位置
	var cha = sys.main.matCha(Vector2(9 - cell.x, cell.y))
	if cha == null or cha.team == team:
		#判定血上限最低
		cha = getFirstCha(1, "sortByMaxHp")

	if cha == null:return
	#判定附近位置
	for i in aroundCells:
		if matCha(cell+i) == null and cha.setCell(cell+i):
			tzCha = cha
			tzCha.addBuff(buffUtil.b_xuanYun.new(3))
			aiCha = tzCha
			return

func _onAtkInfo(atkInfo):
	._onAtkInfo(atkInfo)
	if atkInfo.hitCha.get("gunType") != "大型":
		atkInfo.canCri = true


