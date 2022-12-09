extends "../cazurlineC_5/cazurlineC_5.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「重巡」明尼阿波利斯"   #角色的名称
	attCoe.atk += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	lv = 3             #等级的设置
	evos = ["cazurlineC_5_3_1"]
	addSkill("彻底死亡后，使所有友军获得10层<振奋>与2秒<无敌>", "余威")
	ename = "mingniabolisi"
	autoGetSkill()
	setCamp("白鹰")

func _onCharaDel(cha):
	._onCharaDel(cha)
	if not is_instance_valid(cha) or isSumm:return
	if cha == self:
		for i in getAllChas(2):
			i.addBuff(buffUtil.b_zhenFen.new(10))
			if i.hasBuff("b_wudi") == null:
				i.addBuff(buffUtil.b_wudi.new(2))

	