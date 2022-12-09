extends "../cazurlineD_6/cazurlineD_6.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」加斯科涅"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 1
	lv = 3             #等级的设置
	evos = ["cazurlineD_6_1_1"]
	addSkill("每{cd}秒使全体友军护盾值提高60%", "功率放大", "powerAmplifier", 5)
	
	autoGetSkill()
	itemEvoCha2 = "cex___almiu-gascogne"
	ename = "jiasikenie"
var p2 = 0.6
func _castCdSkill(id):
	._castCdSkill(id)
	if id=="powerAmplifier":
		powerAmplifier()

func powerAmplifier():
	for i in getAllChas(2):
		if i.get("shield") == null:continue
		i.changeShield(i.shield*p2)
