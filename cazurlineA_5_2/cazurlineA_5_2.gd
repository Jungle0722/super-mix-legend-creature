extends "../cazurlineA_5/cazurlineA_5.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「驱逐」塔什干"   #角色的名称
	attCoe.mgiAtk += 1 #魔法攻击（每点代表13.7）
	attCoe.maxHp += 1
	lv = 3             #等级的设置
	evos = ["cazurlineA_5_2_1"]
	addSkill("每{cd}秒使周围2格的友军(含自己)造成的所有伤害为真实伤害，持续3秒", "火力向导", "fireGuide", 10)
	autoGetSkill()
	setCamp("北方联合")
	itemEvoCha2 = "cex___almiu-tashkent"
	ename = "tashigan"
#火力向导 范围
var p3 = 2
#火力向导 持续时间
var p32 = 3
func _castCdSkill(id):
	._castCdSkill(id)
	if id=="fireGuide":
		fireGuide()

func fireGuide():
	var chas = getCellChas(cell,p3,2)
	for i in chas:
		i.addBuff(b_fireGuide.new(p32))
		
class b_fireGuide:
	extends Buff
	var buffName = "火力向导"
	func _init(lv = 1):
		attInit()
		id = "b_fireGuide"
		life = lv
	func _connect():
		masCha.connect("onAtkChara",self,"run")
	func run(atkInfo):
		atkInfo.hurtType = Chara.HurtType.REAL
		atkInfo.hurtVal = atkInfo.atkVal