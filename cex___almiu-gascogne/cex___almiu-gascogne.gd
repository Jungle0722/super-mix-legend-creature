extends "../cazurlineD_6_1/cazurlineD_6_1.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「战列」加斯科涅·μ兵装"   #角色的名称
	evos = ["cex___almiu-gascogne2"]
	supportSpecEvo = 2
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	canCopy = false
	addSkillTxt(jbText)
	prefer = "sup"

var jbText = "[color=#C0C0C0][μ羁绊]-战斗开始时，场上μ兵装舰娘数量达到2/5/8个时，分别获得：20%冷却加成/1800血上限/兵装解放技能强化[/color]"

######################μ兵装相关######################
var p4 = 1
func jiBan1():
	addBuff(buffUtil.b_cd.new(2))

func jiBan2():
	addBuff(buffUtil.b_maxHp.new(1800))

func jiBan3():
	p4 = 2

func finalAwaken():
	p4 = 3

func resetAwaken():
	p4 = 1