extends "../cazurlineD/cazurlineD.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」三笠"   #角色的名称
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 2     #攻击力（每点代表8.5）
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	lv = 3             #等级的设置
	evos = ["cex___als-mikasa2"]
	canCopy = false

	addSkill("<唯一>我方舰娘获得10%双攻及10%物穿、法穿", "新生重樱联合")
	addSkill("每{cd}秒同一列的所有舰娘开火，对目标分别造成[开火舰娘双攻*0.4]的真实伤害", "丁字战法", "sk_mikasa", 8)

	autoGetSkill()
	supportSpecEvo = 2
	setCamp("重樱")
func _castCdSkill(id):
	._castCdSkill(id)
	if id=="sk_mikasa" and aiCha != null:
		sk_mikasa()

func sk_mikasa():
	utils.createSkillTextEff("丁字战法", position)
	for i in range(6):
		var cha = matCha(Vector2(cell.x, i))
		if cha != null and cha.team == team:
			var d:Eff = cha.newEff("sk_feiDang",cha.sprcPos)
			d._initFlyCha(aiCha)
			cha.yieldOnReach(d)
			if cha.get("camp") == "重樱":
				azurHurtChara(aiCha, (cha.att.atk+cha.att.mgiAtk)*0.8, Chara.HurtType.REAL, Chara.AtkType.EFF, "丁字战法")
			else:
				azurHurtChara(aiCha, (cha.att.atk+cha.att.mgiAtk)*0.4, Chara.HurtType.REAL, Chara.AtkType.EFF, "丁字战法")

func _onBattleStart():
	._onBattleStart()
	for i in getAllChas(2):
		if i.hasBuff("b_mikasa") == null:
			i.addBuff(b_mikasa.new(i.get("camp") == "重樱" and upgraded))

class b_mikasa:
	extends Buff
	var buffName = "新生重樱联合"
	func _init(flag = false):
		attInit()
		id = "b_mikasa"	
		if not flag:
			att.atkL = 0.1
			att.mgiAtk = 0.1
			att.penL = 0.1
			att.mgiPenL = 0.1
		else:
			att.atkL = 0.2
			att.mgiAtk = 0.2
			att.penL = 0.2
			att.mgiPenL = 0.2