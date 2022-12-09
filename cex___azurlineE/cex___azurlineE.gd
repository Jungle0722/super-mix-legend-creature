extends "../cazurlineE_1_1/cazurlineE_1_1.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「航母」胜利·改"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.def += 2
	attCoe.mgiDef += 2
	lv = 4             #等级的设置
	addSkill("胜利之歌对敌人也生效，效果变为负数", "四面楚歌", "qxkm", 10)

	addSkillTxt("[color=#C0C0C0][现代化改造]-胜利之歌直接胜利所需次数-3，赋予的活力层数+1(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	setCamp("皇家")
var baseId = ""
func upgrade():
	limit = 13
	p3 = 4
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
func _onBattleStart():
	._onBattleStart()
	qxkm()

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="qxkm":
		qxkm()

func qxkm():
	var chas = getAllChas(1)
	for i in chas:
		i.addBuff(b_huoLi_enemy.new(3, att.mgiAtk, self))
			
class b_huoLi_enemy:
	extends Buff
	var buffName = "四面楚歌"
	var mgiAtk = 0
	var cha
	func _init(lv = 1, mgiAtk = 0, casCha = null):
		attInit()
		id = "b_huoLi_enemy"
		life = lv
		self.mgiAtk = mgiAtk
		isNegetive = true
		if casCha != null:
			self.cha = casCha
		
	func _upS():
		if life > 6:
			life = 6
		var p = 0.1
		if masCha.team == 1:
			p = 0.01
		var dmg = min(masCha.att.maxHp*p, mgiAtk*life*0.065)

		masCha.forceHurtSelf(dmg)
		cha.increDmgNum(dmg, "四面楚歌", masCha)

