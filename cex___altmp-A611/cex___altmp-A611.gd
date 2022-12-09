extends "../cazurlineA_6_1/cazurlineA_6_1.gd"
func _info():
	pass
func _connect():
	._connect()
var summoner
func _extInit():
	._extInit()
	chaName = "「驱逐」伊卡洛斯·镜像"   #角色的名称
	attCoe.atk += 1     #攻击力（每点代表8.5））
	attCoe.mgiAtk += 1
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	isSumm = true
	lv = 4             #等级的设置
	if team == 1:
		attAdd.defR += 0.1

var baseId = ""

