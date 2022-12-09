extends "../cazurlineE_1_2/cazurlineE_1_2.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「航母」光辉·μ兵装"   #角色的名称
	evos = ["cex___almiu-illustrious2"]
	supportSpecEvo = 2
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	canCopy = false
	addSkillTxt(jbText)
	prefer = "t"

var jbText = "[color=#C0C0C0][μ羁绊]-战斗开始时，场上μ兵装舰娘数量达到2/5/8个时，分别获得：20%血上限/800血上限/兵装解放技能强化[/color]"

######################μ兵装相关######################
var p4 = 200
func jiBan1():
	addBuff(buffUtil.b_maxHpL.new(2))

func jiBan2():
	addBuff(buffUtil.b_maxHp.new(800))

func jiBan3():
	p4 = 170

func finalAwaken():
	p4 = 150

func resetAwaken():
	p4 = 200