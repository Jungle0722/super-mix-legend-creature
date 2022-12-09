extends "../azurline_ctrl/BaseResearchItem.gd"
func init():
	.init()
	name = "[color=#DC143C][传说]电磁弹射器"
	att.atk = 200
	att.mgiAtk = 200
	info = "[color=#DC143C]仅限航母舰娘装备，可以继承给舰载机[/color]\n使自身舰载机伤害提高50%，物理/法术吸血+50%，物理/法术穿透提高30%，且死亡时立即满血复活一次"
var p = 0.5
	
func _connect():
	._connect()
	if masCha.id == "cex___al-merchant":return
	if masCha.get("type") != "cv" and masCha.get("type") != "plane":
		delFromCha()
		return
	masCha.connect("summChara",self,"summChara")
	masCha.connect("onDeath", self, "onDeath")
	sys.main.connect("onBattleEnd",self,"onBattleEnd")
var skFlag = true
func onBattleEnd():
	skFlag = true

func onDeath(atkInfo):
	if not masCha.isDeath or not skFlag:return
	masCha.isDeath = false
	masCha.plusHp(masCha.att.maxHp)
	skFlag = false

func summChara(cha):
	cha.attAdd.atkR += p
	cha.attAdd.penL += 0.3
	cha.attAdd.mgiPenL += 0.3
	cha.attAdd.suck += 0.5
	cha.attAdd.mgiSuck += 0.5
	cha.upAtt()