extends "../cazurlineD/cazurlineD.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」伊丽莎白女王"   #角色的名称
	attCoe.atkRan = 3  #攻击距离
	attCoe.atk += 1     #攻击力（每点代表8.5）
	lv = 2             #等级的设置
	evos = ["cazurlineD_5_1"]
	addSkill("<唯一>连接所有皇家阵营的舰娘，任何被连接成员阵亡，均会使其他所有链接成员获得10层<激愤>并获得[血上限30%]的护盾", "皇家舰队")

	setCamp("皇家")
var royalFlag = true
var connChas = []
func _onBattleStart():
	._onBattleStart()
	connChas.append(self)
	for i in getAllChas(2):
		if i.get("camp") == "皇家" and i.get("royalFlag") != true and i != self:
			utils.createSkillTextEff("皇家舰队", i.position)
			connChas.append(i)
	if team == 1:
		for i in connChas:
			if i.hasBuff("b_royalFleet") == null:
				i.addBuff(b_royalFleet.new(connChas))
	else:
		for i in connChas:
			i.addBuff(buffUtil.b_kuangNu_r.new(10))
			i.addBuff(buffUtil.b_moLi.new(10))

class b_royalFleet:
	extends Buff
	var buffName = "皇家舰队"
	var dispel = 2
	var connChas = []
	var buffUtil = globalData.infoDs["g_azurlineBuffs"]
	func _init(connChas = []):
		attInit()
		id = "b_royalFleet"	
		self.connChas = connChas
	func _connect():
		masCha.connect("onDeath",self,"_onDeath")
	func _onDeath(atkInfo):
		if connChas.size() < 2 or not masCha.isDeath:return
		connChas.erase(masCha)
		for i in connChas:
			var bf = i.hasBuff("b_royalFleet")
			if i != masCha and bf != null and not i.isDeath:
				i.addBuff(buffUtil.b_jiFen.new(10))
				i.changeShield(masCha.att.maxHp*0.3)
				bf.connChas.erase(masCha)
		masCha.delBuff(masCha.hasBuff("b_royalFleet"))

func _onBattleEnd():
	._onBattleEnd()
	connChas.clear()