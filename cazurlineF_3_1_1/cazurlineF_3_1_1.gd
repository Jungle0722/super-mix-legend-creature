extends "../cazurlineF_3_1/cazurlineF_3_1.gd"
func _info():
	pass
func _connect():
	._connect()
	pass

func _extInit():
	._extInit()
	chaName = "「辅助」黑暗界·誓约"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 2
	lv = 4             #等级的设置
	addSkill("本回合每次开炮后，提高25%护甲穿透、物攻、冷却，上限100%", "定向炮击")
	addSkillTxt("[color=#C0C0C0][现代化改造]-弹幕伤害翻倍(未解锁)")
	addSkillTxt("[color=#C0C0C0]在一次次的开炮后，黑暗界逐渐有了黑暗的领悟...")
	if upgraded:
		skillStrs[skillStrs.size()-2] = skillStrs[skillStrs.size()-2].replace("未解锁", "已解锁")
	if isAwaken:
		awaken()
func upgrade():
	p3 = 2
	skillStrs[skillStrs.size()-2] = skillStrs[skillStrs.size()-2].replace("未解锁", "已解锁")

func awaken(msg = true):
	chaName = "「辅助」黑暗界·觉醒"
	addSkill("弹幕造成伤害后额外赋予目标10层<霜冻>", "心智觉醒", null, null, skillStrs.size() - 1)
	if not isAwaken:
		sys.newBaseMsg("事件", "黑暗界已经获得了心智觉醒！")
	isAwaken = true

var baseId = ""

func _castCdSkill(id):
	._castCdSkill(id)
	if id == "fire":
		var buff = hasBuff("b_haj_dxpj")
		if buff == null:
			addBuff(b_haj_dxpj.new())
		elif buff.att.atkL < 1:
			buff.att.atkL += 0.25
			buff.att.penL += 0.25
			buff.att.cd += 0.25

class b_haj_dxpj:
	extends Buff
	var buffName = "定向炮击"
	func _init():
		attInit()
		id = "b_haj_dxpj"	
		att.atkL = 0.1
		att.penL = 0.1
		att.cd = 0.1