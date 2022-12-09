extends "../cazurlineB_1/cazurlineB_1.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「轻巡」克利夫兰·μ兵装"   #角色的名称
	attCoe.atkRan = 3  #攻击距离
	lv = 2             #等级的设置
	evos = ["cex___almiu-cleveland2"]
	supportSpecEvo = 2
	addSkillTxt(jbText)
	canCopy = false
	prefer = "sup"
	ename = "kelifulan"

var jbText = "[color=#C0C0C0][μ羁绊]-战斗开始时，场上μ兵装舰娘数量达到2/5/8个时，分别获得：20%冷却加成/30%血量加成/兵装解放技能强化[/color]"
######################μ兵装相关######################
var p4 = 2

func jiBan1():
	addBuff(buffUtil.b_cd.new(1))

func jiBan2():
	addBuff(buffUtil.b_maxHpL.new(3))

func jiBan3():
	p4 = 4

func finalAwaken():
	p4 = 6

func resetAwaken():
	p4 = 2