extends "../cazurlineA_5_2/cazurlineA_5_2.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「驱逐」塔什干·μ兵装"   #角色的名称
	evos = ["cex___almiu-tashkent2"]
	supportSpecEvo = 2
	canCopy = false
	addSkillTxt(jbText)
	prefer = "ap"

var jbText = "[color=#C0C0C0][μ羁绊]-战斗开始时，场上μ兵装舰娘数量达到2/5/8个时，分别获得：20%攻速/20%血量加成/兵装解放技能强化[/color]"

######################μ兵装相关######################
var p4 = 0
func jiBan1():
	addBuff(buffUtil.b_spd.new(2))

func jiBan2():
	addBuff(buffUtil.b_maxHpL.new(2))

func jiBan3():
	p4 = 1

func finalAwaken():
	p4 = 2

func resetAwaken():
	p4 = 0