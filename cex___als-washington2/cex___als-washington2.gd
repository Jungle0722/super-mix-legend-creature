extends "../cex___als-washington/cex___als-washington.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」华盛顿·改"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 1
	attCoe.def += 1
	attCoe.mgiDef += 1
	lv = 4             #等级的设置
	addSkill("<唯一>战斗开始时，若前方两格之内存在友军[南达科他]，与其绑定，使其替自己承受所有伤害", "羁绊·南达科他")
	addSkill("与自己绑定的南达科他每受到14次普攻，对场上血量最低的敌人发起报复，\n造成[目标血上限100%]的真实伤害", "铁底湾之夜")

	addSkillTxt("[color=#C0C0C0][现代化改造]-天佑白鹰还将为白鹰舰娘提供15%双攻加成(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var p4 = 1
func upgrade():
	p4 = 2
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""

var bindCha
func _onBattleStart():
	._onBattleStart()
	bindCha = null
	for i in range(1, 3):
		bindCha = sys.main.matCha(cell + Vector2(i, 0))
		if bindCha != null:break
	if bindCha != null and bindCha.chaName.find("南达科他") > -1:
		bindCha.addBuff(b_washington2.new(self))

class b_washington2:
	extends Buff
	var buffName = "羁绊·南达科他"
	var dispel = 2
	var cha = null
	var count = 0
	func _init(cha):
		attInit()
		id = "b_washington2"
		self.cha = cha
	func _connect():
		masCha.connect("onHurt",self,"_onHurt")
		cha.connect("onHurt",self,"onHurt2")
	func _onHurt(atkInfo:AtkInfo):
		if atkInfo.atkType == Chara.AtkType.NORMAL:
			count += 1
		if count >= 14:
			var enemy = cha.getFirstCha(1, "sortByHp")
			if enemy != null:
				cha.azurHurtChara(enemy, enemy.att.maxHp, Chara.HurtType.REAL, Chara.AtkType.EFF, "铁底湾之夜")
				count = 0

	func onHurt2(atkInfo:AtkInfo):
		atkInfo.hurtVal = 0
		atkInfo.atkCha.azurHurtChara(masCha, atkInfo.atkVal, atkInfo.hurtType, atkInfo.atkType, atkInfo.get("skill"))