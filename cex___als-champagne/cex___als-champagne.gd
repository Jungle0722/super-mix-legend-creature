extends "../cazurlineD/cazurlineD.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「战列」香槟"
	attCoe.atkRan = 3  #攻击距离
	attCoe.maxHp += 5   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 5     #攻击力（每点代表8.5）
	attCoe.def += 2     #物理防御（每点代表15）
	attCoe.mgiDef += 2     #物理防御（每点代表15）
	lv = 3
	autoGetSkill()
	addSkill("每{cd}秒获得5层圣盾", "圣盾充能", "champagne1", 6)
	addSkill("每{cd}秒释放全部圣盾，对当前目标周围2格的敌人造成[圣盾层数*攻击]的物理伤害", "圣盾之力", "champagne2", 5)
	ename = "xiangbin"
	setCamp("自由鸢尾")
	evos = ["cex___als-champagne2"]
	canCopy = false
	supportSpecEvo = 2
	
var p1 = 1
var p2 = 1
func _castCdSkill(id):
	._castCdSkill(id)	
	if id == "champagne1":
		champagne1()
	if id == "champagne2":
		champagne2()	
	if id == "champagne3":
		champagne3()
		
func champagne1():
	buffUtil.addShengDun(self, 5)

func champagne2():
	var bf = hasBuff("b_shengDun")
	if bf != null:
		for i in getCellChas(aiCha.cell, 2, 1):
			azurHurtChara(i, bf.num * att.atk * p1 * p2, Chara.HurtType.PHY, Chara.AtkType.SKILL, "圣盾之力")
		bf.isDel = true	

func champagne3():
	for i in getAllChas(2):
		if i == self:continue
		var bf = i.hasBuff("b_shengDun")
		if bf == null:continue
		buffUtil.addShengDun(self, bf.num)
