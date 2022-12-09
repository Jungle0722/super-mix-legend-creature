extends "../cex___siren-chess1/cex___siren-chess1.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「塞壬」执棋者II型"   #角色的名称
	lv = 3             #等级的设置
	addSkillTxt("[过河卒]-每8秒召唤一名随机2级舰娘，并使其获得5层[狂怒][急速]")
	addCdSkill("ghz", 8)
	evos = ["cex___siren-chess3"]

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="ghz":
		ghz()
func ghz():
	var cha = summChara(sys.rndListItem(utils.lv2))
	if cha != null:
		cha.addBuff(buffUtil.b_kuangNu_r.new(5))
		cha.addBuff(buffUtil.b_jiSu_r.new(5))

