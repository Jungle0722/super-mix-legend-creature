extends "../cazurlineB_4_1/cazurlineB_4_1.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「轻巡」黛朵·μ兵装"   #角色的名称
	evos = ["cex___almiu-dido2"]
	supportSpecEvo = 2
	canCopy = false
	addSkillTxt(jbText)
	prefer = "sup"

var jbText = "[color=#C0C0C0][μ羁绊]-战斗开始时，场上μ兵装舰娘数量达到2/5/8个时，分别获得：20%冷却加成/30%血量加成/兵装解放技能强化[/color]"

######################μ兵装相关######################
var p4 = 0.25

func jiBan1():
	addBuff(buffUtil.b_cd.new(2))

func jiBan2():
	addBuff(buffUtil.b_mgiAtkL.new(3))

func jiBan3():
	p4 = 2

func finalAwaken():
	p4 = 3

func resetAwaken():
	p4 = 1