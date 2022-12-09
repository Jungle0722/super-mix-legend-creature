extends "../cazurlineA_1/cazurlineA_1.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「驱逐」猫音"   #角色的名称
	lv = 3             #等级的设置
	addSkill("每发动2次彗星头锤，下一次彗星头锤对全体敌人生效", "夕星")
	autoGetSkill()
	evos = ["cazurlineA_1_3_1"]
	setCamp("其他")
	ename = "maoyin"

