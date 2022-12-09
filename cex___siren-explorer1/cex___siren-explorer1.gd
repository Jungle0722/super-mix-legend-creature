extends "../cex___siren/cex___siren.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「塞壬」探索者I型"   #角色的名称
	lv = 2             #等级的设置
	attCoe.maxHp = 10
	addCdSkill("yh", 10)
	addSkillTxt("[幽火]-每10秒对随机敌方单位进行灼烧，每秒损失最大生命值5%，双抗降低50%，持续10秒")
	evos = ["cex___siren-explorer2"]
	
func _castCdSkill(id):
	._castCdSkill(id)
	if id=="yh":
		yh()

func yh():
	var enemy = getAllChas(1)
	enemy.shuffle()
	enemy[0].addBuff(b_youHuo.new(10, self))

#幽火 每秒损失最大生命值5%，双抗降低50%
class b_youHuo:
	extends Buff
	var cha
	func _init(lv = 1, cha = null):
		attInit()
		id = "b_youHuo"	
		isNegetive = true
		att.mgiDefL = -0.5
		att.defL = -0.5    
		life = lv 
		self.cha = cha
	func _upS():
		cha.holyDmg(masCha, masCha.att.maxHp * 0.05, "幽火")