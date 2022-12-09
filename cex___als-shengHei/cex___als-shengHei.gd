extends "../cazurlineC/cazurlineC.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「重巡」圣黑之星"   #角色的名称
	attCoe.maxHp += 3   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 1     #攻击力（每点代表8.5）
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	attCoe.atkRan = 2#攻击距离
	lv = 3             #等级的设置
	evos = ["cex___als-shengHei2"]
	canCopy = false
	attAdd.reHp += 0.3
	attAdd.cd += 0.3

	addSkill("减少30%所受伤害，提高30%承疗，提高30%冷却速度", "三色秩序")
	addSkill("身后2格的友方单位免受所有非特效伤害(身后持续判定)", "安全领域")
	ename = "shengheizhixin"

	autoGetSkill()
	supportSpecEvo = 2
	setCamp("其他")
	setGunAndArmor("中型","超重型")

func _onHurt(atkInfo):
	._onHurt(atkInfo)
	atkInfo.hurtVal *= 0.7

func _upS():
	._upS()
	var cha = matCha(cell + Vector2(-1, 0))
	if cha != null && cha.team == team and cha.hasBuff("b_shengHei") == null:
		cha.addBuff(b_shengHei.new(2))
	cha = matCha(cell + Vector2(-2, 0))
	if cha != null && cha.team == team and cha.hasBuff("b_shengHei") == null:
		cha.addBuff(b_shengHei.new(2))	

class b_shengHei:
	extends Buff
	var buffName = "安全领域"
	var dispel = 2
	func _init(lv = 1):
		attInit()
		life = lv
		id = "b_shengHei"
	func _connect():
		masCha.connect("onHurt",self,"_onHurt")
	func _onHurt(atkInfo:AtkInfo):
		if atkInfo.hurtVal > 0 && atkInfo.atkType != Chara.AtkType.EFF:
			atkInfo.hurtVal = 0
	func _upS():
		life = min(10, life)	
