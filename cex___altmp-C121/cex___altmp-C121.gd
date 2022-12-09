extends "../cazurlineC_1_2/cazurlineC_1_2.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「重巡」久远·镜像"   #角色的名称
	attCoe.atkRan = 2  #攻击距离
	attCoe.atk += 1     #攻击力（每点代表8.5）
	attCoe.def += 1
	attCoe.mgiDef += 1
	attCoe.maxHp += 1
	lv = 4             #等级的设置

var baseId = ""
var summoner
var flag = 0
func _upS():
	._upS()
	flag += 1
	if flag >= 3:
		gx_ylls()
		forceKillCha(self)
		
