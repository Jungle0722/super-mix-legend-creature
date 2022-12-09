extends "../cex___siren-breaker2/cex___siren-breaker2.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「塞壬」破局者Ⅲ型"   #角色的名称
	lv = 4             #等级的设置
	attCoe.maxHp += 4
	attCoe.def += 1
	attCoe.mgiDef += 1
	addSkillTxt("[翻盘]-每12秒满血复活一名友军，并使其获得10层[狂怒][急速]")
	addCdSkill("fp", 12)

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="fp":
		fp()

func fp():
	if death.size() > 0:
		var cha = death.pop_front()
		if sys.main.matCha(cha.cell) != null:
			for tcell in last:
				if sys.main.matCha(tcell) == null:
					reviveCha(cha)
					sys.main.setMatCha(tcell, cha)
					break
		else:
			reviveCha(cha)

func reviveCha(cha):
	cha.isDeath = false
	cha.plusHp(cha.att.maxHp)
	cha.revive(cha.att.maxHp)
	cha.addBuff(buffUtil.b_kuangNu_r.new(10))
	cha.addBuff(buffUtil.b_jiSu_r.new(10))
	
var death = []
var last = [Vector2(7,0), Vector2(7,1), Vector2(7,2), Vector2(7,3), Vector2(7,4)]
func _onCharaDel(cha):
	._onCharaDel(cha)
	if not is_instance_valid(cha):return
	if cha.team == team && cha.get("type") != "BOSS":
		death.append(cha)
