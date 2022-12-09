extends "../cazurlineE/cazurlineE.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「航母」瑞鹤"   #角色的名称
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.mgiAtk += 2     #攻击力（每点代表8.5）
	attCoe.def += 1     #物理防御（每点代表15）
	lv = 3             #等级的设置
	evos = ["cex___als-zuikaku2"]
	addSkill("每次起飞舰载机时，赋予全体友军5秒<鹤之奋进>(提高20%双穿、攻速)", "鹤之奋进")
	addSkill("战斗开始时，若我方场上存在翔鹤，法强提高500%", "五航战的荣耀")

	autoGetSkill()
	supportSpecEvo = 2
	setCamp("重樱")
	canCopy = false
var p3 = 5
func _castCdSkill(id):
	._castCdSkill(id)
	if id=="castPlane":
		sk_ruihe1()

func sk_ruihe1():
	for i in getAllChas(2):
		if i.hasBuff("b_suihe") == null:
			addBuff(b_suihe.new(p3))

class b_suihe:
	extends Buff
	var buffName = "五航战的荣耀"
	var dispel = 2
	func _init(lv = 1):
		attInit()
		id = "b_suihe"
		att.penL = 0.2
		att.mgiPenL = 0.2
		att.spd = 0.2
		life = lv

func _onBattleStart():
	._onBattleStart()
	for i in getAllChas(2):
		if i.id.find("cazurlineE_5_1") > -1:
			addBuff(buffUtil.b_mgiAtkL.new(50))
			break