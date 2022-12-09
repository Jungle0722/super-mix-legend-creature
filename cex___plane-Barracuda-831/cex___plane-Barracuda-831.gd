extends "../azurline_ctrl/CAS.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「轰炸机」梭鱼·831中队"   #角色的名称
	lv = 4             #等级的设置
	addSkillTxt("普攻附带5层<烧蚀><霜冻><漏水><灼烧>")
	
var baseId = ""
func _onNormalAtk(cha):
	._onNormalAtk(cha)
	if cha != null && not cha.isDeath:
		cha.addBuff(buffUtil.b_shaoShi.new(5, self))
		cha.addBuff(buffUtil.b_freeze.new(5))
		buffUtil.addLouShui(cha, self, 5)
		cha.addBuff(buffUtil.b_shaoZhuo_r.new(5))

