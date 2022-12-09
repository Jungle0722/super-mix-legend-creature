extends "../cex___als-roon/cex___als-roon.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「重巡」罗恩·μ兵装"   #角色的名称
	evos = ["cex___almiu-roonm2"]
	supportSpecEvo = 2
	canCopy = false
	addSkillTxt(jbText)
	prefer = "t"

var jbText = "[color=#C0C0C0][μ羁绊]-战斗开始时，场上μ兵装舰娘数量达到2/5/8个时，分别获得：30%双防/800血上限/兵装解放技能强化[/color]"

######################μ兵装相关######################
var p4 = 1
#兵装解放额外伤害
var p4_1 = 1
func jiBan1():
	addBuff(buffUtil.b_twoDefL.new(3))

func jiBan2():
	addBuff(buffUtil.b_maxHp.new(800))

func jiBan3():
	p4 = 2

func finalAwaken():
	p4 = 3

func resetAwaken():
	p4 = 1