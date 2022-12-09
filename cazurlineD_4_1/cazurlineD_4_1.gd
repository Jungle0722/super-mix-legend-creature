extends "../cazurlineD_4/cazurlineD_4.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」黎塞留"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 1
	lv = 3             #等级的设置
	evos = ["cazurlineD_4_1_1"]
	addSkill("开局在自身位置插上战旗，战旗2格范围内的所有友军提高20%冷却速度、攻速，\n每100点攻击提高2%加成", "爱丽丝之帜")
	type2 = "doctor"
	setCamp("自由鸢尾")
	autoGetSkill()
var p3 = 2
var flagCell
var effs
func _upS():
	._upS()
	if flagCell == null:return
	var chas = getCellChas(flagCell, p3, 2)
	for i in chas:
		if i.hasBuff("b_lsl_alszz") == null:
			var n = 0.2 + att.atk / 100.0 * 0.02
			i.addBuff(b_lsl_alszz.new(n))

func _onBattleStart():
	._onBattleStart()
	flagCell = cell
	if team == 1:
		effs = createCustEff(position, "eff/flag", 10, true, 1, Vector2(0, -100))

func _onBattleEnd():
	._onBattleEnd()
	flagCell = null
	if is_instance_valid(effs):
		effs.queue_free()

func _onDeath(atkInfo):
	._onDeath(atkInfo)
	if is_instance_valid(effs):
		effs.queue_free()

class b_lsl_alszz:
	extends Buff
	var buffName = "爱丽丝之帜"
	func _init(cd):
		attInit()
		id = "b_lsl_alszz"	
		att.cd = cd
		att.spd = cd

