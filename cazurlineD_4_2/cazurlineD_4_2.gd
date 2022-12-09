extends "../cazurlineD_4/cazurlineD_4.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」威尔士亲王"   #角色的名称
	attCoe.atk += 1
	attCoe.atkRan = 5 
	lv = 3             #等级的设置
	evos = ["cazurlineD_4_2_1"]
	addSkill("战斗开始时，牺牲自己正前方1格的友军单位，获得其全部四维属性，并对当前目标造成等额的物理伤害", "遗志")
	autoGetSkill()
	setCamp("皇家")

func _onBattleStart():
	._onBattleStart()
	var cha = sys.main.matCha(cell + Vector2(1, 0))
	if cha != null && cha.team == team:
		forceKillCha(cha)
		addBuff(b_wesqw_yz.new(cha))
		yield(reTimer(0.05),"timeout")
		if aiCha != null:
			var dmg = cha.att.atk + cha.att.mgiAtk + cha.att.def + cha.att.mgiDef
			if team == 2:
				dmg = min(aiCha.att.maxHp, dmg)
			azurHurtChara(aiCha, dmg, Chara.HurtType.PHY, Chara.AtkType.SKILL, "遗志")
		if cha.isDeath and upgraded:
			cha.isDeath = false
			cha.plusHp(cha.att.maxHp)
			cha.revive(cha.att.maxHp)
			cha.addBuff(buffUtil.b_wudi.new(3))

class b_wesqw_yz:
	extends Buff
	var buffName = "遗志"
	func _init(cha):
		attInit()
		id = "b_wesqw_yz"
		att.atk = cha.att.atk
		att.mgiAtk = cha.att.mgiAtk
		att.def = cha.att.def
		att.mgiDef = cha.att.mgiDef

