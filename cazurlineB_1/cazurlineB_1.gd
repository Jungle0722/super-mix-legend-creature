extends "../cazurlineB/cazurlineB.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「轻巡」克利夫兰"   #角色的名称
	attCoe.atkRan = 2  #攻击距离
	attCoe.atk += 1     #攻击力（每点代表8.5）
	attCoe.maxHp += 1
	lv = 2             #等级的设置
	evos = ["cazurlineB_1_1","cazurlineB_1_2"]
	addSkill("<先手>每{cd}秒赋予当前目标<强袭号令>，持续4秒", "强袭号令", "qxhl", 8)
	setGunAndArmor("小型","中型")
	itemEvoCha2 = "cex___almiu-cleveland"
	setCamp("白鹰")

func _castCdSkill(id):
	._castCdSkill(id)
	if id == "qxhl":
		qxhl()

func _onBattleStart():
	._onBattleStart()
	yield(reTimer(0.1),"timeout")
	qxhl()

func qxhl():
	if aiCha == null:return
	if aiCha.hasBuff("b_qxhl") == null:
		aiCha.addBuff(b_qxhl.new(4))

class b_qxhl:
	extends Buff
	var buffName = "强袭号令"
	func _init(lv = 1):
		attInit()
		id = "b_qxhl"
		life = lv
		isNegetive=true
		att.defR = -0.3
	func _connect():
		._connect()
		masCha.connect("onDeath", self, "onDeath")
	func onDeath(atkInfo:AtkInfo):
		sys.main.player.plusGold(8)
