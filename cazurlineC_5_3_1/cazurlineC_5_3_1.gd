extends "../cazurlineC_5_3/cazurlineC_5_3.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「重巡」明尼阿波利斯·改"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.atk += 1  #魔法防御（每点代表16.6）
	lv = 4             #等级的设置
	addSkill("彻底死亡后，将自身的四维赋予当前四维最高的友军(排除召唤物)", "馈赠")

	addSkillTxt("[color=#C0C0C0][现代化改造]-每次轮回提高的属性翻倍(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""
func upgrade():
	p2 = 40
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

func _onCharaDel(cha):
	._onCharaDel(cha)
	if not is_instance_valid(cha):return
	if cha == self:
		var ally = getFirstCha(2, "sortBySwDesc", false, true, true)
		if ally != null:
			ally.addBuff(b_c531.new(att.atk, att.mgiAtk, att.def, att.mgiDef))

class b_c531:
	extends Buff
	var buffName = "馈赠"
	var dispel = 2
	func _init(atk, mgiAtk, def, mgiDef):
		attInit()
		id = "b_c531"
		att.atk = atk
		att.mgiAtk = mgiAtk
		att.def = def
		att.mgiDef = mgiDef