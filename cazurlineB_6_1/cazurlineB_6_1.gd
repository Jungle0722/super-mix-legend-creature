extends "../cazurlineB_6/cazurlineB_6.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「轻巡」海王星"   #角色的名称
	attCoe.maxHp += 1
	attCoe.mgiDef += 1
	attCoe.atk += 1
	attAdd.spd += 0.4
	lv = 3             #等级的设置
	evos = ["cazurlineB_6_1_1"]
	addSkill("攻速提高40%，被治疗的单位获得5秒<海之祝福>(承疗+20%，减少20%所受伤害)", "海神祝福")

	autoGetSkill()
	
func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)
	if atkInfo.atkType == Chara.AtkType.NORMAL and hasBuff("b_hwx_hzzf") == null:
		atkInfo.hitCha.addBuff(b_hwx_hzzf.new(5))

class b_hwx_hzzf:
	extends Buff
	var buffName = "海神祝福"
	func _init(lv = 1):
		attInit()
		id = "b_hwx_hzzf"
		life = lv
		att.reHp = 0.2
	func _connect():
		masCha.connect("onHurt",self,"run")
	func run(atkInfo):
		atkInfo.hurtVal *= 0.8