extends "../cazurlineC_6/cazurlineC_6.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「重巡」巴尔的摩"   #角色的名称
	attCoe.atk += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	lv = 3             #等级的设置
	evos = ["cazurlineC_6_1_1"]
	addSkill("每{cd}秒吸收全场单位的15%护盾为己用(优先吸收敌人的，会受承疗效果影响)", "护盾同化", "shieldAssimilation", 8)

	autoGetSkill()
var p3 = 0.15
func _castCdSkill(id):
    ._castCdSkill(id)
    if id=="shieldAssimilation":
        shieldAssimilation()

func shieldAssimilation():
	for i in getAllChas(1):
		if i.get("shield") == null:continue
		if shield >= shieldLimit:return
		var s = i.get("shield") * p3
		if team == 2:
			s *= 0.5
			if i.chaName.find("巴尔的摩") > -1 or i.chaName.find("海因里希") > -1:
				continue
		changeShield(s)
		i.changeShield(-s)
	for i in getAllChas(2):
		if i.get("shield") == null:continue
		if shield >= shieldLimit:return
		var s = i.get("shield") * p3
		changeShield(s)
		i.changeShield(-s)


