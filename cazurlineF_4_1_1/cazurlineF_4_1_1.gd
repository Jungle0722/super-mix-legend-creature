extends "../cazurlineF_4_1/cazurlineF_4_1.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「辅助」22·Up"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.mgiAtk += 1
	lv = 4             #等级的设置
	addSkill("每{cd}秒使全场有护盾的友军获得4层<活力><狂怒><魔力>", "强效护盾", "effectiveShield", 8)

	addSkillTxt("[color=#C0C0C0][现代化改造]-强效护盾赋予的BUFF层数翻倍(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

var p4 = 4
func upgrade():
	p4 = 8
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	
var baseId = ""

func _castCdSkill(id):
	._castCdSkill(id)
	if id == "effectiveShield":
		effectiveShield()

func effectiveShield():
	for i in getAllChas(2):
		if not i.has_method("changeShield") or i.shield <= 0:continue
		buffUtil.addHuoLi(i, self, p4)
		i.addBuff(buffUtil.b_kuangNu_r.new(p4))
		i.addBuff(buffUtil.b_moLi.new(p4))
		