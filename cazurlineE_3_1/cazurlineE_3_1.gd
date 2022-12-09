extends "../cazurlineE_3/cazurlineE_3.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「航母」大凤"   #角色的名称
	attCoe.maxHp += 2
	lv = 3             #等级的设置
	evos = ["cazurlineE_3_1_1"]
	addSkill("每{cd}秒召唤一架神风战机，对敌人发起恐怖的<自杀式袭击>", "神风特攻", "aircraftDF", 5)

	autoGetSkill()
	summLimit = 999
	setGunAndArmor("小型","重型")
	setCamp("重樱")
	itemEvoCha2 = "cex___almiu-taiho"
	ename = "dafeng"
var p3 = 0.0007
func _castCdSkill(id):
	._castCdSkill(id)
	if id=="aircraftDF":
		summSakura()

func summSakura():
	var chara = summChara("cex___plane-sakura", false, true)
	if chara != null:
		chara.ex += att.mgiAtk*p3
		if chaName.find("μ兵装") > -1 and get("p4") > 1:
			chara.ex += 0.5
		chara.summoner = self