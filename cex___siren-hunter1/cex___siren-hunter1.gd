extends "../cex___siren/cex___siren.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「塞壬」追迹者I型"   #角色的名称
	lv = 2             #等级的设置
	attCoe.maxHp = 10
	addSkillTxt("[血迹]-场上每死亡一个非召唤单位，双攻提高50")
	evos = ["cex___siren-hunter2"]
	
func _onCharaDel(cha):
	._onCharaDel(cha)
	if not is_instance_valid(cha):return
	if not cha.isSumm && cha.lv > 1:
		if attAdd.atk < 5000:
			attAdd.atk += 50
			attAdd.mgiAtk += 50