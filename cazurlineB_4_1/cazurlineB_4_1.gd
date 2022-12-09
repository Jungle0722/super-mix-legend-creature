extends "../cazurlineB_4/cazurlineB_4.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「轻巡」黛朵"   #角色的名称
	lv = 3             #等级的设置
	evos = ["cazurlineB_4_1_1"]
	addSkill("每{cd}使全体友军的正面效果提高5层(无法对强效果生效，如无敌、活力)", "皇家女仆", "royalMaid", 10)
	autoGetSkill()
	setCamp("皇家")
	itemEvoCha2 = "cex___almiu-dido"
	ename = "daiduo"
var p3 = 5
func _castCdSkill(id):
	._castCdSkill(id)
	if id == "royalMaid":
		royalMaid()
	
func royalMaid():
	utils.createSkillTextEff("皇家女仆", position)
	var chas = getAllChas(2)
	for i in chas:
		for j in i.buffs:
			if j.get("type") != config.EQUITYPE_EQUI and j.life != null and j.life > 0 and not j.isNegetive and j.get("dispel") != 2 and j.get("dispel") != 3:
				j.life = min(20, j.life+p3)