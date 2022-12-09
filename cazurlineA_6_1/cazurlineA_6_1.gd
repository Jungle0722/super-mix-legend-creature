extends "../cazurlineA_6/cazurlineA_6.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「驱逐」伊卡洛斯"   #角色的名称
	attCoe.maxHp += 1
	lv = 3             #等级的设置
	evos = ["cazurlineA_6_1_1"]
	addSkill("本回合友军彻底阵亡时，立即发射一枚重型鱼雷(镜像阵亡无法触发)", "反击")
	autoGetSkill()
	ename = "yikaluosi"

func _onCharaDel(cha):
	._onCharaDel(cha)
	if not is_instance_valid(cha) or isDeath or cha.id.find("altmp") > -1:return
	if cha.team == team:
		zxyl(aiCha)