extends "../cazurlineC_5/cazurlineC_5.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「重巡」最上"   #角色的名称
	attCoe.atk += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	lv = 3             #等级的设置
	evos = ["cazurlineC_5_1_1"]
	addSkill("死亡时有50%概率满血复活", "转生")

	autoGetSkill()
	setCamp("重樱")

var p3 = 50
var snum = 0
func _onBattleEnd():
	._onBattleEnd()
	snum = 0

func _onDeath(atkInfo):
	._onDeath(atkInfo)
	if isDeath and (sys.rndPer(50) or snum < 1 and upgraded):
		isDeath = false
		healCha(self, att.maxHp)
		snum += 1
		