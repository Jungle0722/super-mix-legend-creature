extends "../azurline_ctrl/BaseResearchItem.gd"
func init():
	.init()
	name = "[color=#DC143C][传说]双联120mm高平两用炮Mk11"
	att.cd = 1
	att.mgiAtkL = 0.2
	att.mgiAtk = 100
	info = "[color=#DC143C]仅限驱逐舰娘装备[/color]\n使自身造成的所有技能伤害均为真实伤害"

#当前、上一任携带者
var preCha
func _connect():
	._connect()
	if masCha.id == "cex___al-merchant":return
	if masCha.get("type") != "dd":
		delFromCha()
		return
	masCha.connect("onAtkChara",self,"run")

func run(atkInfo:AtkInfo):
	if atkInfo.atkType == Chara.AtkType.SKILL:
		atkInfo.hurtType = Chara.HurtType.REAL
		atkInfo.hurtVal = atkInfo.atkVal




