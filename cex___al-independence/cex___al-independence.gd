extends "../cazurlineE/cazurlineE.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「航母」独立·改"   #角色的名称
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.mgiAtk += 2     #攻击力（每点代表8.5）
	attCoe.def += 1     #物理防御（每点代表15）
	lv = 3             #等级的设置
	evos = ["cex___al-independence2"]
	addSkill("赋予自身舰载机30%的双攻", "装备改良")
	addSkill("赋予自身舰载机额外技能：每5秒恢复血量最低的3名友军[双攻*1.5]的血量", "空域辅助")
	autoGetSkill()
	supportSpecEvo = 2
	setCamp("白鹰")
	canCopy = false
	ename = "duli"
	if not is_connected("summChara", self, "doit"):
		connect("summChara", self, "doit")

func doit(cha):
	cha.addBuff(buffUtil.b_atkL.new(3))
	cha.addBuff(buffUtil.b_mgiAtkL.new(3))

	cha.addCdSkill("kyfz", 5)
