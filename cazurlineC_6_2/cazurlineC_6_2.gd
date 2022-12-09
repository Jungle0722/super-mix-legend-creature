extends "../cazurlineC_6/cazurlineC_6.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「重巡」海因里希亲王"   #角色的名称
	attCoe.atk += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	lv = 3             #等级的设置
	evos = ["cazurlineC_6_2_1"]
	addSkill("护盾充能系数+40%，每{cd}秒对当前目标造成[自身护盾值*1.2]的物理伤害", "直感之拳", "shieldFist", 7)
	autoGetSkill()
	setCamp("铁血")
	p2 = 0.8

func _castCdSkill(id):
    ._castCdSkill(id)
    if id=="shieldFist" and aiCha != null:
        shieldFist()

func shieldFist():
	azurHurtChara(aiCha, shield*1.2, Chara.HurtType.PHY, Chara.AtkType.SKILL, "直感之拳")

func _onKillChara(atkInfo:AtkInfo):
	._onKillChara(atkInfo)
	if index <= 0:
		index = 3
		shieldFist()

var index = 0
func _upS():
	._upS()
	if index > 0:
		index -= 1