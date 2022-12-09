extends Node
func _ready():
	pass
func _init():
	call_deferred("azurlineInit")
func _connect():
	pass

var relic
var utils
func azurlineInit():
	relic = globalData.infoDs["g_azurlineRelic"]
	utils = globalData.infoDs["g_azurlineUtils"]

var skills = {1: Skill_001, 2: Skill_002, 3: Skill_003, 4: Skill_004, 5: Skill_005, 6: Skill_006, 7: Skill_007, 8: Skill_008, 9: Skill_009,
10: Skill_010, 11: Skill_011, 12: Skill_012, 13: Skill_013, 14: Skill_014, 15: Skill_015, 16: Skill_016, 17: Skill_017, 18: Skill_018, 19: Skill_019,
20: Skill_020, 21: Skill_021, 22: Skill_022, 23: Skill_023, 24: Skill_024, 25: Skill_025, 26: Skill_026, 27: Skill_027, 28: Skill_028, 29: Skill_029,
30: Skill_030, 31: Skill_031, 32: Skill_032, 33: Skill_033, 34: Skill_034, 35: Skill_035, 36: Skill_036, 37: Skill_037, 38: Skill_038, 39: Skill_039,
40: Skill_040, 41: Skill_041, 42: Skill_042, 43: Skill_043, 44: Skill_044, 45: Skill_045, 46: Skill_046, 47: Skill_047, 48: Skill_048, 49: Skill_049,
50: Skill_050, 51: Skill_051, 52: Skill_052, 53: Skill_053, 54: Skill_054, 55: Skill_055, 56: Skill_056, 57: Skill_057, 58: Skill_058, 59: Skill_059,
60: Skill_060, 61: Skill_061 }
var skills_rnd_nor = []
var skills_cmd_dic = {"重樱": Skill_300, "皇家": Skill_301, "白鹰": Skill_302, "铁血": Skill_303, "碧蓝": Skill_304}
#指挥官可用的随机技能池
var skills_rnd_cmd = []
var skills_cmd_t = []
var skills_cmd_sup = []
var skills_cmd_ad = []
var skills_cmd_ap = []
#常规分类技能池
var skills_t = []
var skills_sup = []
var skills_ad = []
var skills_ap = []
#舰载机技能池
var skills_cv_cas = []
var skills_cv_fighter = []
var skills_cv_tbf = []
#指挥官技能池
var skills_cmd = []
#获得随机技能
func getRandomSkill(rarity:int, type = null, cha = null):
	var skillClass
	sortSkills()
	if type == null:
		skillClass = sys.rndListItem(skills_rnd_nor)
	else:
		match type:
			"ad":
				skillClass = sys.rndListItem(skills_ad)
			"ap":
				skillClass = sys.rndListItem(skills_ap)
			"t":
				skillClass = sys.rndListItem(skills_t)
			"sup":
				skillClass = sys.rndListItem(skills_sup)
			"cas":
				skillClass = sys.rndListItem(skills_cv_cas)
			"fighter":
				skillClass = sys.rndListItem(skills_cv_fighter)
			"tbf":
				skillClass = sys.rndListItem(skills_cv_tbf)
			"cmd":
				skillClass = sys.rndListItem(skills_cmd)
			"cmdr":
				skillClass = sys.rndListItem(skills_rnd_cmd)
			"cmdt":
				skillClass = sys.rndListItem(skills_cmd_t)
			"cmdad":
				skillClass = sys.rndListItem(skills_cmd_ad)
			"cmdap":
				skillClass = sys.rndListItem(skills_cmd_ap)
			"cmdsup":
				skillClass = sys.rndListItem(skills_cmd_sup)
	
	var skill = skillClass.new(rarity)
	return skill
#获得指定技能
func getSkill(id:int, rarity:int = 1):
	return skills.get(id).new(rarity)

func getCmdSkill(id):
	return skills_cmd_dic.get(id).new(3)

func sortSkills():
	if skills_cmd.empty():
		for key in skills_cmd_dic.keys():
			var skill = skills_cmd_dic.get(key)
			skills_cmd.append(skill)

	if skills_t.empty():
		for key in skills.keys():
			var skill = skills.get(key)
			var s = skill.new(1)
			if s.permission == 3:continue
			if s.permission != 1:
				skills_rnd_cmd.append(skill)
			if s.permission != 2:
				skills_rnd_nor.append(skill)
			match s.type:
				"ad":
					if s.permission != 2:
						skills_ad.append(skill)
						if s.enablePlane:
							skills_cv_fighter.append(skill)
							skills_cv_cas.append(skill)
					if s.permission != 1:
						skills_cmd_ad.append(skill)
				"ap":
					if s.permission != 2:
						skills_ap.append(skill)
						if s.enablePlane:
							skills_cv_tbf.append(skill)
					if s.permission != 1:
						skills_cmd_ap.append(skill)
				"t":
					if s.permission != 2:
						skills_t.append(skill)
						if s.enablePlane:
							skills_cv_fighter.append(skill)
					if s.permission != 1:
						skills_cmd_t.append(skill)
				"sup":
					if s.permission != 2:
						skills_sup.append(skill)
						if s.enablePlane:
							skills_cv_tbf.append(skill)
					if s.permission != 1:
						skills_cmd_sup.append(skill)
				"dps":
					if s.permission != 2:
						skills_ad.append(skill)
						skills_ap.append(skill)
						if s.enablePlane:
							skills_cv_fighter.append(skill)
							skills_cv_cas.append(skill)
							skills_cv_tbf.append(skill)
					if s.permission != 1:
						skills_cmd_ad.append(skill)
						skills_cmd_ap.append(skill)
				
class Skill extends Object:
	var text
	var tcha:Chara
	var sid:int
	var sname
	var type
	#稀有度：1标准2稀有3传说
	var rarity:int
	var utils = globalData.infoDs["g_azurlineUtils"]
	var buffUtil = globalData.infoDs["g_azurlineBuffs"]
	var cdId
	#升级进度
	var readNum = 0
	#周围一格
	var aroundCells = [Vector2(-1,0),Vector2(1,0),Vector2(0,1),Vector2(0,-1),Vector2(1,1),Vector2(-1,-1),Vector2(1,-1),Vector2(-1,1)]
	#不能学习此技能的角色ID
	var excludeChas = []
	#connect记录
	var cons = []
	var enablePlane = true
	#0 enable all unit, 1 enable normal, disable cmd, 2 cmd only, 3 disable all
	var permission = 0
	#是否允许AI拥有
	var enableAi = true
	var item
	func makeConnect(origin, object, target):
		object.connect(origin, self, target)
		cons.append({"origin":origin,"target":target, "object":object})
		if origin == "onBattleStart" || origin == "onBattleEnd":
			enablePlane = false
	func _init(rarity = 1):
		self.rarity = rarity

	func setCha(cha):
		tcha = cha
	func sortByHp(a, b):
		return (!a.isSumm && b.isSumm && a.att.maxHp - a.att.hp > 50) || a.att.hp / a.att.maxHp < b.att.hp / b.att.maxHp
	func sortByDistance(a,b):
		return tcha.cellRan(a.cell,tcha.cell) < tcha.cellRan(b.cell,tcha.cell)
	func sortByDistanceDesc(a,b):
		return tcha.cellRan(a.cell,tcha.cell) > tcha.cellRan(b.cell,tcha.cell)
	func sortByFront(a,b):
		if a.team == 1:
			return a.cell.x > b.cell.x
		else:
			return a.cell.x < b.cell.x
	func sortByFrontDesc(a,b):
		if a.team == 1:
			return a.cell.x < b.cell.x
		else:
			return a.cell.x > b.cell.x		
	func remove():
		for i in cons:
			i.object.disconnect(i.origin, self, i.target)
		if cdId != null:
			for i in tcha.skills:
				if i.id == cdId:
					tcha.skills.erase(i)
					break
	func toJson():
		return {"sid":sid,"slv":rarity}
	func setItem(item):
		self.item = item
#----------------------------------------------001战士血统----------------------------------------------
class Skill_001 extends Skill:
	#稀有度因子
	var p1 = 5
	var p2 = 1
	func _init(rarity = 1):
		._init(rarity)
		excludeChas = ["cex___als-tirpitz2"]
		p1 += rarity*2
		p2 = p1/100.0
		enableAi = false
		#7 9 11
		text = "战斗开始时，获得[血上限*{0}%]的攻击".format({"0":p1})
		sname = "战士血统"
		sid = 1
		type = "ad"
	func setCha(cha):
		.setCha(cha)
		makeConnect("onBattleStart", tcha, "onBattleStart")
	func onBattleStart():
		tcha.addBuff(b_sk_atk.new(tcha.att.maxHp*p2))
	class b_sk_atk:
		extends Buff
		var buffName = "战士血统"
		func _init(atk = 0):
			attInit()
			id = "b_sk_atk"	
			att.atk = atk
#----------------------------------------------002高速机动----------------------------------------------				
class Skill_002 extends Skill:
	var p1 = 0
	var p2:float = 0.0
	func _init(rarity):
		._init(rarity)
		p1 += rarity*10
		p2 = p1/10
		#20 30 40
		text = "闪避+{0}%".format({"0":p1})
		sname = "高速机动"
		sid = 2
		type = "t"
	func setCha(cha):
		.setCha(cha)
		makeConnect("onBattleStart", tcha, "onBattleStart")
	func onBattleStart():
		if utils.inBattle(tcha):
			tcha.addBuff(utils.buffs.b_dod.new(p2))
#----------------------------------------------003狩猎标记----------------------------------------------
class Skill_003 extends Skill:
	var p1 = 0
	func _init(rarity):
		._init(rarity)
		excludeChas = ["cazurlineB_2", "cazurlineB_2_1", "cazurlineB_2_1_1"]
		p1 += rarity
		#2 3 4
		text = "造成普攻伤害时获得{0}层[狂怒]，并赋予目标{1}层[流血]".format({"0":p1, "1":p1})
		sname = "狩猎标记"
		sid = 3
		type = "ad"
	func setCha(cha):
		.setCha(cha)
		makeConnect("onAtkChara", tcha, "onAtkChara")
	func onAtkChara(atkInfo):
		if atkInfo.atkType == Chara.AtkType.NORMAL:
			tcha.addBuff(buffUtil.b_kuangNu_r.new(p1))
			atkInfo.hitCha.addBuff(buffUtil.b_liuXue_r.new(p1))
#----------------------------------------------004强攻----------------------------------------------
class Skill_004 extends Skill:
	var p1 = 0
	var p2:float = 0.0
	func _init(rarity):
		._init(rarity)
		p1 += rarity*10
		p1 = min(30, p1)
		p2 = p1/10
		# 20 30 30
		text = "攻击+{0}%".format({"0":p1})
		sname = "强攻"
		sid = 4
		type = "ad"
	func setCha(cha):
		.setCha(cha)
		makeConnect("onBattleStart", tcha, "onBattleStart")
	func onBattleStart():
		if utils.inBattle(tcha):
			tcha.addBuff(utils.buffs.b_atkL.new(p2))
#----------------------------------------------005魔力----------------------------------------------
class Skill_005 extends Skill:
	var p1 = 0
	var p2:float = 0.0
	func _init(rarity):
		._init(rarity)
		p1 += rarity*10
		p2 = p1/10
		#20 30 40
		text = "法强+{0}%".format({"0":p1})
		sname = "魔力"
		sid = 5
		type = "ap"
	func setCha(cha):
		.setCha(cha)
		makeConnect("onBattleStart", tcha, "onBattleStart")
	func onBattleStart():
		if utils.inBattle(tcha):
			tcha.addBuff(utils.buffs.b_mgiAtkL.new(p2))
#----------------------------------------------006小队领袖----------------------------------------------
class Skill_006 extends Skill:
	var p1 = 0
	func _init(rarity):
		._init(rarity)
		p1 += rarity
		#2 3 4
		text = "普攻40%概率为周围1格的友军附加{0}层活力".format({"0":p1})
		sname = "小队领袖"
		sid = 6
		type = "dps"
		enableAi = false
	func setCha(cha):
		.setCha(cha)
		makeConnect("onCastCdSkill", tcha, "castCdSkill")
		makeConnect("normalAtkChara", tcha, "normalAtkChara")
	func normalAtkChara(cha):
		if not cha.isDeath:
			sk()
	func castCdSkill(id):
		sk()
	func sk():
		if sys.rndPer(40):
			for i in tcha.getCellChas(tcha.cell, 1, 2):
				buffUtil.addHuoLi(i, tcha, p1)
#----------------------------------------------007前锋支援----------------------------------------------
class Skill_007 extends Skill:
	var p1 = 40
	func _init(rarity):
		._init(rarity)
		p1 += rarity*20
		#80 100 120
		text = "每当使用技能时，赋予[最靠前]的三名[非召唤]队友5层[抵御][魔御]，并恢复[双攻*{0}%]的生命值".format({"0":p1})
		sname = "前锋支援"
		sid = 7
		type = "sup"
	func setCha(cha):
		.setCha(cha)
		makeConnect("onCastCdSkill", tcha, "castCdSkill")
	func castCdSkill(id):
		var chas = tcha.getAllChas(2)
		chas.sort_custom(self,"sortByFront")
		var dmg = (tcha.att.mgiAtk + tcha.att.atk) * p1 * 0.01
		for i in range(3):
			if i >= chas.size():break
			tcha.healCha(chas[i], dmg)
			chas[i].addBuff(buffUtil.b_diYu_r.new(5))
			chas[i].addBuff(buffUtil.b_moYu_r.new(5))
	
#----------------------------------------------008装甲强化----------------------------------------------
class Skill_008 extends Skill:
	var p1 = 10
	func _init(rarity):
		._init(rarity)
		p1 += rarity * 10
		#30 40 50
		text = "提高{0}%双防".format({"0":p1})
		sname = "装甲强化"
		sid = 8
		type = "t"
	func setCha(cha):
		.setCha(cha)
		makeConnect("onBattleStart", tcha, "onBattleStart")
	func onBattleStart():
		if utils.inBattle(tcha):
			tcha.addBuff(utils.buffs.b_twoDefL.new(p1/10))

#----------------------------------------------009舰队支援----------------------------------------------
class Skill_009 extends Skill:
	var p1 = 4
	var p2:float = 0.0
	func _init(rarity):
		._init(rarity)
		excludeChas = ["cazurlineE_1_2", "cazurlineE_1_2_1"]
		p1 += rarity*2
		p2 = p1/100 as float
		#8 10 12
		text = "每5秒恢复生命值最低的3名友军[施法者血上限*{0}%]的生命值(可暴击)".format({"0":p1})
		sname = "舰队支援"
		sid = 9
		type = "sup"
	func setCha(cha):
		.setCha(cha)
		makeConnect("onCastCdSkill", tcha, "castCdSkill")
		tcha.addCdSkill("jdzy", 5)
		cdId = "jdzy"
	func castCdSkill(id):
		if id=="jdzy":
			var chas = tcha.getAllChas(2)
			chas.sort_custom(self,"sortByHp")
			var dmg = tcha.att.maxHp * p2
			if sys.rndPer(tcha.att.cri * 100):dmg *= 2
			for i in range(3):
				if i >= chas.size() : break
				tcha.healCha(chas[i], dmg)
#----------------------------------------------010消防特训----------------------------------------------
class Skill_010 extends Skill:
	var p1 = 5
	var p2 = 0
	func _init(rarity):
		._init(rarity)
		p1 += rarity*10
		p2 = p1/100 as float
		#25 35 45
		text = "受到的特效伤害降低{35}%".format({"0":p1})
		sname = "消防特训"
		sid = 10
		type = "t"
	func setCha(cha):
		.setCha(cha)
		makeConnect("onHurt", tcha, "onHurt")
	func onHurt(atkInfo):
		if atkInfo.atkType == Chara.AtkType.EFF:
			atkInfo.hurtVal *= (1 - p2)
#----------------------------------------------011樱绽凤华----------------------------------------------
class Skill_011 extends Skill:
	var p1 = 14
	func _init(rarity):
		._init(rarity)
		excludeChas = ["cazurlineE_3_1_1"]
		p1 -= rarity*2
		p1 = max(8, p1)
		text = "<固化>每{0}秒使全体友军[无敌]2秒".format({"0":p1})
		sname = "樱绽凤华"
		sid = 11
		type = "sup"
		permission = 2
	func setCha(cha):
		.setCha(cha)
		makeConnect("upS", tcha, "upS")
		makeConnect("onBattleStart", tcha, "onBattleStart")
	var flag = 0
	func upS():
		flag += 1
		if flag >= p1:
			var chas = tcha.getAllChas(2)
			for i in chas:
				if not i.hasBuff("b_yzfh"):
					i.addBuff(utils.buffs.b_yzfh.new(2))
			flag = 0
	func onBattleStart():
		flag = 0
#----------------------------------------------012恶作剧----------------------------------------------
class Skill_012 extends Skill:
	var p1 = 12
	func _init(rarity):
		._init(rarity)
		excludeChas = ["cazurlineE_3_2_1"]
		p1 -= rarity*2
		p1 = max(6, p1)
		#8 6 6
		text = "每{0}秒对一条直线上的敌人造成[法强*2]的魔法伤害，并使其眩晕1秒".format({"0":p1})
		sname = "恶作剧"
		sid = 12
		type = "ap"
	func setCha(cha):
		.setCha(cha)
		makeConnect("onCastCdSkill", tcha, "castCdSkill")
		tcha.addCdSkill("ezj", p1)
		cdId = "ezj"
	func castCdSkill(id):
		if id == "ezj":
			var eff:Eff = tcha.newEff("sk_feiZhan",tcha.sprcPos)
			eff._initFlyPos(tcha.position + (tcha.aiCha.position - tcha.position).normalized() * 800, 800)
			eff.connect("onInCell",self,"effInCell")
	func effInCell(cell):
		var cha = tcha.matCha(cell)
		if cha != null && cha.team != tcha.team :
			tcha.azurHurtChara(cha, tcha.att.mgiAtk * 2, Chara.HurtType.MGI, Chara.AtkType.SKILL, "恶作剧")
			var bf = cha.hasBuff("b_xuanYun")
			if bf == null:
				cha.addBuff(buffUtil.b_xuanYun.new(1))
			else:
				bf.life += 0.1
#----------------------------------------------013BigSeven级防护----------------------------------------------
class Skill_013 extends Skill:
	var p1 = 5
	var p2 = 0
	func _init(rarity):
		._init(rarity)
		excludeChas = ["cazurlineD_3", "cazurlineD_3_1", "cazurlineD_3_1_1", "cazurlineD_3_2", "cazurlineD_3_2_1"]
		p1 += rarity*5
		p2 += rarity
		p2 = min(3, p2)
		text = "开局获得{0}层[抵御][魔御]，受到攻击时获得{1}层[抵御][魔御]，被治疗效果提高30%".format({"0":p1, "1":p2})
		sname = "BigSeven级防护"
		sid = 13
		type = "t"
	func setCha(cha):
		.setCha(cha)
		makeConnect("onBattleStart", tcha, "onBattleStart")
		makeConnect("onHurt", tcha, "onHurt")
	func onBattleStart():
		if utils.inBattle(tcha):
			tcha.addBuff(buffUtil.b_moYu_r.new(p1))
			tcha.addBuff(buffUtil.b_diYu_r.new(p1))
			tcha.addBuff(utils.buffs.b_reHp.new(3))
	func onHurt(atkInfo):
		tcha.addBuff(buffUtil.b_moYu_r.new(p2))
		tcha.addBuff(buffUtil.b_diYu_r.new(p2))
#----------------------------------------------014反击之誓约----------------------------------------------
class Skill_014 extends Skill:
	var p1 = 100
	var p2 = 1
	func _init(rarity):
		._init(rarity)
		excludeChas = ["cazurlineD_3_1_1"]
		p1 += rarity*100
		p2 = p1/100.0
		#220 280 340
		text = "每8秒，将所受的所有伤害的{0}%施加给当前目标，并清空累计值".format({"0":p1})
		sname = "反击之誓约"
		sid = 14
		type = "t"
	func setCha(cha):
		.setCha(cha)
		makeConnect("onCastCdSkill", tcha, "castCdSkill")
		makeConnect("onHurt", tcha, "onHurt")
		makeConnect("onBattleStart", tcha, "onBattleStart")
		tcha.addCdSkill("fjzsy", 8)
		cdId = "fjzsy"
	var hurtNum = 0
	func castCdSkill(id):
		if id == "fjzsy" && tcha.aiCha != null && hurtNum > 0:
			tcha.azurHurtChara(tcha.aiCha, hurtNum*p2, Chara.HurtType.PHY, Chara.AtkType.SKILL, "反击之誓约")
			hurtNum = 0
	func onHurt(atkInfo):
		if not atkInfo.isMiss && atkInfo.hurtVal > 0:
			hurtNum += atkInfo.hurtVal
	func onBattleStart():
		hurtNum = 0
#----------------------------------------------015致命诱饵----------------------------------------------
class Skill_015 extends Skill:
	var p1 = 2
	func _init(rarity):
		._init(rarity)
		p1 += rarity
		# 4 5 6
		text = "战斗开始时，牺牲自己，将对称的敌人拉到自己位置，使所有射程大于2的友军集火她，赋予其{0}层<暴露><放逐>".format({"0":p1})
		sname = "致命诱饵"
		sid = 15
		type = "sup"
		enableAi = false
	var suckCha = []
	func setCha(cha):
		.setCha(cha)
		makeConnect("onBattleStart", tcha, "onBattleStart")
	func onBattleStart():
		var cell = tcha.cell
		var cha = sys.main.matCha(Vector2(9 - cell.x, cell.y))
		if cha != null && cha.team != tcha.team:
			tcha.forceKillCha(tcha)
			cha.setCell(cell)
			buffUtil.addBaoLu(cha, p1)
			cha.addBuff(buffUtil.b_fangZhu.new(p1))
			for i in tcha.getAllChas(2):
				if i.att.atkRan > 2 or tcha.cellRan(cell, i.cell) < 2:
					i.aiCha = cha

#----------------------------------------------016威光----------------------------------------------
class Skill_016 extends Skill:
	var p1 = 20
	func _init(rarity):
		._init(rarity)
		excludeChas = ["cazurlineC_1_2", "cex___al-gaoxiong", "cex___azurlineC"]
		p1 += rarity*20
		#60 80 100
		text = "普攻暴击后有{0}%的概率获得1层<圣盾>".format({"0":p1})
		sname = "威光"
		sid = 16
		type = "ad"
	var wg = 0
	func setCha(cha):
		.setCha(cha)
		makeConnect("onAtkChara", tcha, "onAtkChara")
	func onAtkChara(atkInfo):
		if atkInfo.atkType == Chara.AtkType.NORMAL && atkInfo.isCri && sys.rndPer(p1):
			buffUtil.addShengDun(tcha, 1)
#----------------------------------------------017烟雾弹----------------------------------------------
class Skill_017 extends Skill:
	var p1 = 7
	var p2 = 3
	func _init(rarity):
		._init(rarity)
		excludeChas = ["cazurlineB_1_2", "cazurlineB_1_2_1"]
		p1 -= rarity
		p2 += rarity
		text = "每{0}秒向最靠前的3名友军位置投掷烟雾弹，使其闪避提升40%，承疗提升30%，持续{1}秒".format({"0":p1, "1":p2})
		sname = "烟雾弹"
		sid = 17
		type = "sup"
	func setCha(cha):
		.setCha(cha)
		makeConnect("onCastCdSkill", tcha, "castCdSkill")
		tcha.addCdSkill("ywd", p1)
		cdId = "ywd"
	func castCdSkill(id):
		if id == "ywd":
			var chas = tcha.getAllChas(2)
			chas.sort_custom(self,"sortByFront")
			for i in range(3):
				if i >= chas.size():break
				var c = chas[i]
				var d:Eff = tcha.newEff("sk_4_1_2", c.sprcPos)
				d._initFlyCha(c)
				c.yieldOnReach(d)
				c.addBuff(utils.buffs.b_ywd.new(5))
#----------------------------------------------018高爆穿甲弹----------------------------------------------
class Skill_018 extends Skill:
	var p1 = 1
	var p2 = 1
	var p3 = 3
	func _init(rarity):
		._init(rarity)
		excludeChas = ["cazurlineC_2_2", "cazurlineC_2_2_1"]
		p1 += rarity
		p3 += rarity
		p2 = p3/100 as float
		#3 4 5    5 6 7
		text = "造成普攻伤害时会附带{0}层<烧蚀>效果，目标身上每层烧蚀使自己对其造成的普攻伤害提高[{1}%]".format({"0":p1, "1":p3})
		sname = "高爆穿甲弹"
		sid = 18
		type = "dps"
	var currentCha = null
	var cspd = 0
	func setCha(cha):
		.setCha(cha)
		makeConnect("onAtkChara", tcha, "onAtkChara")
	func onAtkChara(atkInfo):
		if atkInfo.atkType == Chara.AtkType.NORMAL:
			atkInfo.hitCha.addBuff(utils.buffs.b_shaoShi.new(p1))
			var buff = atkInfo.hitCha.hasBuff("b_shaoShi")
			if buff != null:
				atkInfo.factor += p2 * buff.life
#----------------------------------------------019上游导弹----------------------------------------------
class Skill_019 extends Skill:
	var p1 = 1
	func _init(rarity):
		._init(rarity)
		excludeChas = ["cazurlineA_1_2_1"]
		p1 += rarity*0.8
		#2.6 3.2 4.0
		text = "每8秒发射一枚恐怖的上游导弹，对目标及2格范围内的敌方单位造成[法强*{0}]的伤害".format({"0":p1})
		sname = "上游导弹"
		sid = 19
		type = "ap"
	func setCha(cha):
		.setCha(cha)
		makeConnect("onCastCdSkill", tcha, "castCdSkill")
		tcha.addCdSkill("sydd", 8)
		cdId = "sydd"
	func castCdSkill(id):
		if id == "sydd":
			var eff:Eff = tcha.newEff("sk_yunShi")
			eff.position = tcha.aiCha.position
			var chas = tcha.getCellChas(tcha.aiCha.cell,2,1)
			yield(tcha.reTimer(0.45), "timeout")
			for i in chas:
				tcha.azurHurtChara(i,tcha.att.mgiAtk*p1,Chara.HurtType.MGI,Chara.AtkType.SKILL, "上游导弹")
#----------------------------------------------020高爆装药----------------------------------------------
class Skill_020 extends Skill:
	var p1 = 0.8
	func _init(rarity):
		._init(rarity)
		excludeChas = ["cazurlineA_2_1", "cazurlineA_2_1_1"]
		p1 += rarity*0.2
		text = "造成普攻伤害时附带[法强*{0}]的可暴击伤害".format({"0":p1})
		sname = "高爆装药"
		sid = 20
		type = "ap"
	func setCha(cha):
		.setCha(cha)
		makeConnect("onAtkChara", tcha, "onAtkChara")
	func onAtkChara(atkInfo):
		if atkInfo.atkType == Chara.AtkType.NORMAL:
			var dmg = tcha.att.mgiAtk * p1
			if sys.rndPer(tcha.att.cri * 100):dmg *= (2 + tcha.att.criR)
			tcha.azurHurtChara(atkInfo.hitCha, dmg,  Chara.HurtType.MGI, Chara.AtkType.SKILL, "高爆装药")
#----------------------------------------------021玻璃大炮----------------------------------------------
class Skill_021 extends Skill:
	var p1 = 20
	var p2 = 0
	var p3 = 0
	func _init(rarity):
		._init(rarity)
		p1 += rarity*10
		p2 = p1/10.0
		p3 = p1/100.0 + 1
		text = "造成伤害提高{0}%，受到伤害提高{1}%".format({"0":p1, "1":p1})
		sname = "玻璃大炮"
		sid = 21
		type = "dps"
	func setCha(cha):
		.setCha(cha)
		makeConnect("onBattleStart", tcha, "onBattleStart")
		makeConnect("onHurt", tcha, "onHurt")
	func onBattleStart():
		tcha.addBuff(utils.buffs.b_atkR.new(p2))
	func onHurt(atkInfo):
		atkInfo.hurtVal *= p3
#----------------------------------------------022被迫营业----------------------------------------------
class Skill_022 extends Skill:
	var p1 = 0
	func _init(rarity):
		._init(rarity)
		p1 += rarity*5
		p1 = min(15, p1)
		text = "战斗结束时获得{0}金币".format({"0":p1})
		sname = "被迫营业"
		sid = 22
		type = "sup"
		enableAi = false
		permission = 1
	func setCha(cha):
		.setCha(cha)
		makeConnect("onBattleEnd", tcha, "onBattleEnd")
	func onBattleEnd():
		if tcha.team == 1 && utils.inBattle(tcha):
			sys.main.player.plusGold(p1)
#----------------------------------------------023死歌----------------------------------------------
class Skill_023 extends Skill:
	var p1 = 10
	func _init(rarity):
		._init(rarity)
		excludeChas = ["cazurlineF_1_1", "cazurlineF_1_1_1"]
		p1 -= rarity
		#8 7 6
		text = "每{0}秒触发自己身上的<亡语>效果".format({"0":p1})
		sname = "死歌"
		sid = 23
		type = "ap"
		permission = 3
	func setCha(cha):
		.setCha(cha)
		makeConnect("upS", tcha, "upS")
		makeConnect("onBattleStart", tcha, "onBattleStart")
	var flag = 0
	func upS():
		flag += 1
		if flag >= p1:
			if tcha.has_method("deathWord"):
				tcha.deathWord()
			flag = 0
	func onBattleStart():
		flag = 0
#----------------------------------------------024意外赠礼----------------------------------------------
class Skill_024 extends Skill:
	var p1 = 1
	func _init(rarity):
		._init(rarity)
		excludeChas = ["cazurlineF_1_2"]
		p1 += rarity
		#3 4 5
		text = "技能造成伤害时，追加{0}层<漏水>效果".format({"0":p1})
		sname = "意外赠礼"
		sid = 24
		type = "ap"
	func setCha(cha):
		.setCha(cha)
		makeConnect("onAtkChara", tcha, "onAtkChara")
	func onAtkChara(atkInfo):
		if atkInfo.atkType == Chara.AtkType.SKILL && sys.rndPer(tcha.att.cri * 100):
			buffUtil.addLouShui(atkInfo.hitCha, tcha, p1)
#----------------------------------------------025自我维修----------------------------------------------
class Skill_025 extends Skill:
	var p1 = 13
	var p2:float = 0.0
	func _init(rarity):
		._init(rarity)
		p1 += rarity*5
		p2 = p1/100 as float
		#23 28 33
		text = "每6秒恢复{0}%生命值".format({"0":p1})
		sname = "自我维修"
		sid = 25
		type = "t"
		enableAi = false
	func setCha(cha):
		.setCha(cha)
		makeConnect("onCastCdSkill", tcha, "castCdSkill")
		tcha.addCdSkill("repairSelf", 6)
		cdId = "repairSelf"
	func castCdSkill(id):
		if id == "repairSelf":
			tcha.healCha(tcha, tcha.att.maxHp*p2)
#----------------------------------------------026护盾猛击----------------------------------------------
class Skill_026 extends Skill:
	var p1 = 25
	var p2:float = 0.0
	func _init(rarity):
		._init(rarity)
		p1 += rarity*25
		p2 = p1/100 as float
		#75 100
		text = "造成普攻伤害时附带自身护盾值{0}%的物理特效伤害".format({"0":p1})
		sname = "护盾猛击"
		sid = 26
		type = "ad"
		permission = 1
	func setCha(cha):
		.setCha(cha)
		makeConnect("onAtkChara", tcha, "onAtkChara")
	func onAtkChara(atkInfo):
		if atkInfo.atkType == Chara.AtkType.NORMAL:
			tcha.azurHurtChara(atkInfo.hitCha, tcha.shield*p2, Chara.HurtType.PHY, Chara.AtkType.EFF, "护盾猛击")
#----------------------------------------------027自然生长----------------------------------------------
class Skill_027 extends Skill:
	func _init(rarity):
		._init(rarity)
		text = "友军角色召唤1个单位时，自身获得永久提高1点双攻，每回合只能触发6次"
		sname = "自然生长"
		sid = 27
		type = "player"
		permission = 1
		enableAi = false
	func setCha(cha):
		.setCha(cha)
		makeConnect("onCharaNewChara", sys.main, "onCharaNewChara")
		makeConnect("onBattleEnd", tcha, "onBattleEnd")
	var index = 0
	func onCharaNewChara(cha):
		if not is_instance_valid(cha):return
		if cha.team != 1 or index >= 6:return
		index += 1
		tcha.updateTmpAtt("atk", 1)
		tcha.updateTmpAtt("mgiAtk", 1)
	func onBattleEnd():
		index = 0
#----------------------------------------------028霜刃----------------------------------------------
class Skill_028 extends Skill:
	var p1 = -1
	func _init(rarity):
		._init(rarity)
		excludeChas = ["cazurlineA_2_2", "cazurlineA_2_2_1"]
		p1 += rarity
		#3 4 5
		text = "造成伤害时附带3层<霜冻>，若目标身上霜冻层数大于10层，造成[双攻*{0}]的真实伤害，清空层数".format({"0":p1})
		sname = "霜刃"
		sid = 28
		type = "dps"
	func setCha(cha):
		.setCha(cha)
		makeConnect("onAtkChara", tcha, "onAtkChara")
	func onAtkChara(atkInfo):
		if atkInfo.atkType == Chara.AtkType.EFF:return
		frostBlade(atkInfo.hitCha)
	func frostBlade(cha):
		cha.addBuff(buffUtil.b_freeze.new(3))
		var buff = cha.hasBuff("b_freeze")
		if buff.life > 10:
			buff.isDel = true
			tcha.azurHurtChara(cha, (tcha.att.mgiAtk + tcha.att.atk) * p1, Chara.HurtType.REAL, Chara.AtkType.EFF, "霜刃")

#----------------------------------------------029重型鱼雷----------------------------------------------
class Skill_029 extends Skill:
	var p1 = 1.5
	func _init(rarity):
		._init(rarity)
		p1 += rarity*1
		#3.5 4.5 5.5
		text = "每5秒发射一枚鱼雷对目标造成[{0}*双攻]的魔法伤害".format({"0":p1})
		sname = "重型鱼雷"
		sid = 29
		type = "ap"
	func setCha(cha):
		.setCha(cha)
		makeConnect("onCastCdSkill", tcha, "castCdSkill")
		tcha.addCdSkill("heavyTorpedo", 5)
		cdId = "heavyTorpedo"
	func castCdSkill(id):
		if id == "heavyTorpedo" and tcha.aiCha != null:
			cast()
	func cast():
		var d:Eff = tcha.newEff("sk_feiDang", tcha.sprcPos)
		d._initFlyCha(tcha.aiCha)
		tcha.yieldOnReach(d)
		tcha.azurHurtChara(tcha.aiCha, (tcha.att.mgiAtk + tcha.att.atk) * p1, Chara.HurtType.MGI, Chara.AtkType.SKILL, "重型鱼雷")
#----------------------------------------------030速攻----------------------------------------------
class Skill_030 extends Skill:
	var p1 = 10
	var p2:float = 0.0
	func _init(rarity):
		._init(rarity)
		p1 += rarity*10
		p2 = p1/10
		text = "攻速+{0}%".format({"0":p1})
		sname = "速攻"
		sid = 30
		type = "ad"
	func setCha(cha):
		.setCha(cha)
		makeConnect("onBattleStart", tcha, "onBattleStart")
	func onBattleStart():
		if utils.inBattle(tcha):
			tcha.addBuff(utils.buffs.b_spd.new(p2))
#----------------------------------------------031月蚀----------------------------------------------
class Skill_031 extends Skill:
	var p1 = 1
	func _init(rarity):
		._init(rarity)
		p1 += rarity*0.5
		#2 2.5 3
		text = "每8秒发动：每秒降下一道月光，对周围2格的随机一名敌人造成[双攻*{0}]的魔法伤害，持续4秒".format({"0":p1})
		sname = "月蚀"
		sid = 31
		type = "ap"
	func setCha(cha):
		.setCha(cha)
		makeConnect("onCastCdSkill", tcha, "castCdSkill")
		tcha.addCdSkill("yueShi", 8)
		cdId = "yueShi"
	func castCdSkill(id):
		if id == "yueShi":
			cast()
	func cast():
			tcha.addBuff(b_yueShi.new(4, p1))
	class b_yueShi:
		extends Buff
		var buffName = "月蚀"
		var p
		var tcha
		func _init(lv = 1, p = 0.1):
			attInit()
			life = lv
			id = "b_yueShi"
			self.p = p
		#周围一格
		var aroundCells = [Vector2(-1,0),Vector2(1,0),Vector2(0,1),Vector2(0,-1),Vector2(1,1),Vector2(-1,-1),Vector2(1,-1),Vector2(-1,1)]
		func _upS():
			var chas = masCha.getCellChas(masCha.cell, 2, 1)
			if chas.size() == 0:return
			chas.shuffle()
			var d1:Eff = sys.newEff("animEff", chas[0].position)
			d1.setImgs(masCha.direc + "eff/starDown", 15, false)
			d1.scale *= 1.8
			d1.normalSpr.position=Vector2(0, -20)

			masCha.azurHurtChara(chas[0], (tcha.att.mgiAtk + tcha.att.atk)*p, Chara.HurtType.MGI, Chara.AtkType.SKILL, "月蚀")
#----------------------------------------------032赏金猎人----------------------------------------------
class Skill_032 extends Skill:
	var p1 = 0
	func _init(rarity):
		._init(rarity)
		p1 += rarity
		text = "击杀敌人时，获得[该敌人等级*{0}]的金币".format({"0":p1})
		sname = "赏金猎人"
		sid = 32
		type = "dps"
		permission = 1
		enableAi = false
	func setCha(cha):
		.setCha(cha)
		makeConnect("onKillChara", tcha, "onKillChara")
	func onKillChara(atkInfo):
		sys.main.player.plusGold(atkInfo.hitCha.lv*p1)
#----------------------------------------------033牺牲精神----------------------------------------------
class Skill_033 extends Skill:
	var p1 = 0
	func _init(rarity):
		._init(rarity)
		p1 += rarity*2
		text = "死亡时，赋予全体友军{0}秒[激愤](双攻提高50%)".format({"0":p1})
		sname = "牺牲精神"
		sid = 33
		type = "sup"
		enableAi = false
	func setCha(cha):
		.setCha(cha)
		makeConnect("onDeath", tcha, "onDeath")
	func onDeath(atkInfo):
		var ally=tcha.getAllChas(2)
		for i in ally:
			i.addBuff(b_jiFen.new(p1))
	class b_jiFen:
		extends Buff
		var buffName = "牺牲精神"
		func _init(lv = 1):
			attInit()
			life = lv
			id = "b_jiFen"
			att.atkL = 0.5
			att.mgiAtkL = 0.5
#----------------------------------------------034巩固后方----------------------------------------------
class Skill_034 extends Skill:
	var p1 = 0
	func _init(rarity):
		._init(rarity)
		p1 += rarity
		#2 3 4
		text = "每8秒赋予[最靠后]的4名友军{0}层<圣盾>".format({"0":p1})
		sname = "巩固后方"
		sid = 34
		type = "sup"
	func setCha(cha):
		.setCha(cha)
		makeConnect("upS", tcha, "upS")
		makeConnect("onBattleStart", tcha, "onBattleStart")
	var flag = 0
	func upS():
		flag += 1
		if flag >= 8:
			var chas = tcha.getAllChas(2)
			chas.sort_custom(self,"sortByFrontDesc")
			for i in range(4):
				if i >= chas.size():break
				buffUtil.addShengDun(chas[i], 2)
			flag = 0
	func onBattleStart():
		flag = 0
#----------------------------------------------035上帝权杖----------------------------------------------
class Skill_035 extends Skill:
	var p1 = 5
	func _init(rarity):
		._init(rarity)
		p1 += rarity*2
		text = "每8秒对目标及周围(九宫格范围)的所有敌人造成总计[法强*{0}]的伤害(所有目标分摊伤害)".format({"0":p1})
		sname = "上帝权杖"
		sid = 35
		type = "ap"
	func setCha(cha):
		.setCha(cha)
		makeConnect("onCastCdSkill", tcha, "castCdSkill")
		tcha.addCdSkill("godScepter", 8)
		cdId = "godScepter"
	func castCdSkill(id):
		if id == "godScepter":
			if tcha.aiCha == null:
				var skill = tcha.getSkill("godScepter")
				skill.nowTime += 2
				return
			var chas = tcha.getAroundChas(tcha.aiCha.cell, false)
			chas.append(tcha.aiCha)
			var dmg = tcha.att.mgiAtk*p1/chas.size() as float
			for i in chas:
				tcha.azurHurtChara(i, dmg, Chara.HurtType.MGI, Chara.AtkType.SKILL, "上帝权杖")
#----------------------------------------------036连续射击----------------------------------------------
class Skill_036 extends Skill:
	#稀有度因子
	var p1 = 10
	func _init(rarity = 1):
		._init(rarity)
		p1 += rarity*10
		p1 = min(50, p1)
		excludeChas = ["cazurlineC_4", "cazurlineC_4_1", "cazurlineC_4_1_1", "cazurlineB_2_1", "cazurlineB_2_1_1", "cex___alr-mainz", "cazurlineC_4_2", "cazurlineC_4_2_1", "cazurlineC_4_3", "cazurlineC_4_3_1"]
		#30 40 50
		text = "每次普攻有{0}%概率追加一次普攻".format({"0":p1})
		sname = "连续射击"
		sid = 36
		type = "ad"
	func setCha(cha):
		.setCha(cha)
		makeConnect("normalAtkChara", tcha, "normalAtkChara")

	func normalAtkChara(cha):
		if sys.rndPer(p1):
			tcha.normalAtk(cha)
#----------------------------------------------037主炮校正----------------------------------------------
class Skill_037 extends Skill:
	#稀有度因子
	var p1 = 1
	var p2 = 0
	func _init(rarity = 1):
		._init(rarity)
		p1 += rarity
		p2 = p1/100.0 as float
		excludeChas = ["cazurlineC_4", "cazurlineC_4_1", "cazurlineC_4_1_1"]
		#3 4 5
		text = "本回合内，每次普攻提高自身{0}%爆伤、攻击(上限120%)".format({"0":p1})
		sname = "主炮校正"
		sid = 37
		type = "ad"
	func setCha(cha):
		.setCha(cha)
		makeConnect("normalAtkChara", tcha, "normalAtkChara")
	func normalAtkChara(cha):
		var buff = tcha.hasBuff("b_zl_zpjz")
		if buff == null:
			tcha.addBuff(b_zl_zpjz.new())
		elif buff.att.cri < 1.2:
			buff.att.criR += p2
			buff.att.atkL += p2
	class b_zl_zpjz:
		extends Buff
		var buffName = "主炮校正"
		func _init():
			attInit()
			id = "b_zl_zpjz"	
			att.criR = 0.02
			att.atkL = 0.02
#----------------------------------------------038弹药后效----------------------------------------------
class Skill_038 extends Skill:
	#稀有度因子
	var p1 = 2
	func _init(rarity = 1):
		._init(rarity)
		p1 += rarity
		excludeChas = ["cazurlineC_4", "cazurlineC_4_1", "cazurlineC_4_1_1"]
		text = "每次普攻赋予敌方单位{0}层随机DEBUFF".format({"0":p1})
		sname = "弹药后效"
		sid = 38
		type = "ad"
	func setCha(cha):
		.setCha(cha)
		makeConnect("normalAtkChara", tcha, "normalAtkChara")
	func normalAtkChara(cha):
		if not cha.isDeath:
			buffUtil.addRndDebuff(tcha, cha, 3)
#----------------------------------------------039爱丽丝之怒----------------------------------------------
class Skill_039 extends Skill:
	#稀有度因子
	var p1 = 30
	func _init(rarity = 1):
		._init(rarity)
		p1 += rarity * 30
		excludeChas = ["cazurlineD_4", "cazurlineD_4_1", "cazurlineD_4_1_1"]
		text = "本回合[非召唤]友军阵亡时，提高自身{0}双攻".format({"0":p1})
		sname = "爱丽丝之怒"
		sid = 39
		type = "dps"
	func setCha(cha):
		.setCha(cha)
		makeConnect("onCharaDel", sys.main, "onCharaDel")
	func onCharaDel(cha):
		if not is_instance_valid(cha):return
		if cha.team == tcha.team and not cha.isSumm:
			var atk = p1
			var buff = tcha.hasBuff("b_yy_alszn")
			if buff == null:
				tcha.addBuff(b_yy_alszn.new(atk))
			elif tcha.team == 1 || tcha.team == 2 && buff.att.atk < 180:
				buff.att.atk += atk
				buff.att.mgiAtk += atk
	class b_yy_alszn:
		extends Buff
		var buffName = "爱丽丝之怒"
		func _init(atk):
			attInit()
			id = "b_yy_alszn"	
			att.atk = atk
			att.mgiAtk = atk
#----------------------------------------------040水线打击----------------------------------------------
class Skill_040 extends Skill:
	#稀有度因子
	var p1 = 0
	func _init(rarity = 1):
		._init(rarity)
		p1 += rarity
		text = "普攻赋予目标{0}层<漏水>".format({"0":p1})
		sname = "水线打击"
		sid = 40
		type = "ad"
	func setCha(cha):
		.setCha(cha)
		makeConnect("normalAtkChara", tcha, "normalAtkChara")
	func normalAtkChara(cha):
		buffUtil.addLouShui(cha, tcha, p1)
#----------------------------------------------041狂暴----------------------------------------------
class Skill_041 extends Skill:
	var p1 = 10
	var p2:float = 0.0
	func _init(rarity):
		._init(rarity)
		p1 += rarity*10
		p2 = p1/10
		text = "暴击+{0}%".format({"0":p1})
		sname = "狂暴"
		sid = 41
		type = "ad"
	func setCha(cha):
		.setCha(cha)
		makeConnect("onBattleStart", tcha, "onBattleStart")
	func onBattleStart():
		if utils.inBattle(tcha):
			tcha.addBuff(utils.buffs.b_cri.new(p2))
#----------------------------------------------042快速冷却----------------------------------------------
class Skill_042 extends Skill:
	var p1 = 0
	var p2:float = 0.0
	func _init(rarity):
		._init(rarity)
		p1 += rarity*10
		p2 = p1/10
		text = "冷却速度+{0}%".format({"0":p1})
		sname = "快速冷却"
		sid = 42
		type = "ap"
	func setCha(cha):
		.setCha(cha)
		makeConnect("onBattleStart", tcha, "onBattleStart")
	func onBattleStart():
		if utils.inBattle(tcha):
			tcha.addBuff(utils.buffs.b_cd.new(p2))
#----------------------------------------------043火海----------------------------------------------
class Skill_043 extends Skill:
	var p1 = 2
	func _init(rarity):
		._init(rarity)
		p1 += rarity
		text = "每8秒赋予所有敌人{0}层<烧蚀>".format({"0":p1})
		sname = "火海"
		sid = 43
		type = "dps"
	func setCha(cha):
		.setCha(cha)
		makeConnect("onCastCdSkill", tcha, "castCdSkill")
		tcha.addCdSkill("flameSea", 8)
		cdId = "flameSea"
	func castCdSkill(id):
		if id == "flameSea":
			for i in tcha.getAllChas(1):
				i.addBuff(buffUtil.b_shaoShi.new(p1))
#----------------------------------------------044破坏的交响曲----------------------------------------------
class Skill_044 extends Skill:
	var p1 = 10
	var p2 = 0
	func _init(rarity):
		._init(rarity)
		p1 += rarity * 10
		p2 = p1/100.0
		text = "每10秒对全体敌人造成[自身受损生命值{0}%]的物理伤害".format({"0":p1})
		sname = "破坏的交响曲"
		sid = 44
		type = "t"
		permission = 2
		excludeChas = ["cex___als-h39"]
		enableAi = false
	func setCha(cha):
		.setCha(cha)
		makeConnect("onCastCdSkill", tcha, "castCdSkill")
		tcha.addCdSkill("vengeanceFlame", 8)
		cdId = "vengeanceFlame"
	func castCdSkill(id):
		if id == "vengeanceFlame":
			var enemy = tcha.getAllChas(1)
			var damage = (tcha.att.maxHp - tcha.att.hp) * p2
			for i in enemy:
				tcha.azurHurtChara(i, damage, Chara.HurtType.PHY, Chara.AtkType.EFF, "破坏的交响曲")
#----------------------------------------------045化虚为实----------------------------------------------
class Skill_045 extends Skill:
	var p1 = 60
	var p2:float = 0.0
	func _init(rarity):
		._init(rarity)
		p1 += rarity*10
		p2 = p1/100.0
		#80 90 100
		text = "战斗开始时将物攻的{0}%转化为魔攻".format({"0":p1})
		sname = "化虚为实"
		sid = 45
		type = "ap"
		enableAi = false
	func setCha(cha):
		.setCha(cha)
		makeConnect("onBattleStart", tcha, "onBattleStart")
	func onBattleStart():
		if utils.inBattle(tcha):
			tcha.addBuff(b_dd_base2.new(tcha.att.atk, p2))
	class b_dd_base2:
		extends Buff
		var buffName = "化虚为实"
		var dispel = 2
		func _init(atk, p):
			attInit()
			id = "b_dd_base2"	
			att.atk = -atk*p
			att.mgiAtk = atk*p
#----------------------------------------------046圣盾窃取----------------------------------------------
class Skill_046 extends Skill:
	var p1 = 11
	func _init(rarity):
		._init(rarity)
		p1 -= rarity
		text = "每{0}秒窃取所有敌人的圣盾于己身".format({"0":p1})
		sname = "圣盾窃取"
		sid = 46
		type = "t"
		excludeChas = ["cazurlineA_1_1", "cazurlineA_1_1_1"]
		enableAi = false
		permission = 3
	func setCha(cha):
		.setCha(cha)
		makeConnect("upS", tcha, "upS")
		makeConnect("onBattleStart", tcha, "onBattleStart")
	var flag = 0
	func upS():
		flag += 1
		if flag >= p1:
			for i in tcha.getAllChas(1):
				var bf = i.hasBuff("b_shengDun")
				if bf != null:
					buffUtil.addShengDun(tcha, bf.num)
					bf.isDel = true
			flag = 0
	func onBattleStart():
		flag = 0
#----------------------------------------------047冰火领域----------------------------------------------
class Skill_047 extends Skill:
	var p1 = 0.04
	#5 6     9 11
	func _init(rarity):
		._init(rarity)
		p1 += rarity*0.02
		text = "每秒对周围(九宫格范围)敌人造成<目标血上限*{0}>的魔法伤害，并附加3层<烧蚀><霜冻>，对塞壬伤害减半".format({"0":p1})
		sname = "冰火领域"
		sid = 47
		type = "t"
	func setCha(cha):
		.setCha(cha)
		makeConnect("upS", tcha, "upS")
	func upS():
		for i in tcha.getAroundChas(tcha.cell, false):
			var p = 1
			if i.get("type") == "BOSS":p = 0.5
			tcha.azurHurtChara(i, i.att.maxHp * p1 * p, Chara.HurtType.MGI, Chara.AtkType.EFF, "冰火领域")
			i.addBuff(utils.buffs.b_shaoShi.new(3))
			i.addBuff(buffUtil.b_freeze.new(3))
#----------------------------------------------048血怒----------------------------------------------
class Skill_048 extends Skill:
	var p1 = 1
	func _init(rarity):
		._init(rarity)
		p1 += rarity*1
		#3 4 5
		text = "每次使用技能，损失10%血量，额外造成[已损失血量*{0}]的魔法伤害".format({"0":p1})
		sname = "血怒"
		sid = 48
		type = "ap"
		excludeChas = ["cazurlineA_4", "cazurlineA_4_1", "cazurlineA_4_1_1"]
		enableAi = false
	func setCha(cha):
		.setCha(cha)
		makeConnect("onCastCdSkill", tcha, "castCdSkill")
	func castCdSkill(id):
		if tcha.att.hp/tcha.att.maxHp > 0.1:
			if tcha.team != 1:
				tcha.forceHurtSelf(tcha.att.maxHp*0.1)
			else:
				tcha.azurHurtChara(tcha, tcha.att.maxHp*0.1, Chara.HurtType.REAL, Chara.AtkType.EFF, "血怒")
		if tcha.aiCha != null:
			tcha.azurHurtChara(tcha.aiCha, min(5000, tcha.att.maxHp-tcha.att.hp)*p1, Chara.HurtType.MGI, Chara.AtkType.SKILL, "血怒")
#----------------------------------------------049护盾杀手----------------------------------------------
class Skill_049 extends Skill:
	var p1 = 60
	var p2:float = 0.0
	func _init(rarity):
		._init(rarity)
		p1 += rarity*20
		p2 = p1/100.0
		text = "对具有护盾的敌人造成的伤害提高{0}".format({"0":p1})
		sname = "护盾杀手"
		sid = 49
		type = "dps"
		excludeChas = ["cazurlineB_1_2_1"]
		enableAi = false
		permission = 3
	func setCha(cha):
		.setCha(cha)
		makeConnect("onAtkChara", tcha, "onAtkChara")
	func onAtkChara(atkInfo):
		if atkInfo.hitCha.team != tcha.team and atkInfo.hitCha.get("shield") > 0:
			atkInfo.factor += p2

#----------------------------------------------050元气弹----------------------------------------------
class Skill_050 extends Skill:
	var p1 = 0.1
	func _init(rarity):
		._init(rarity)
		p1 += rarity*0.1
		p1 = min(0.3, p1)
		text = "每7秒对当前目标直线上的所有单位造成[双攻双防之和*{0}]的真实伤害".format({"0":p1})
		sname = "元气弹"
		sid = 50
		type = "dps"
		enableAi = false
	func setCha(cha):
		.setCha(cha)
		makeConnect("onCastCdSkill", tcha, "castCdSkill")
		tcha.addCdSkill("yuanQiDan", 7)
		cdId = "yuanQiDan"
	func castCdSkill(id):
		if id == "yuanQiDan":
			var eff:Eff = tcha.newEff("sk_feiZhan",tcha.sprcPos)
			eff._initFlyPos(tcha.position + (tcha.aiCha.position - tcha.position).normalized() * 800, 800)
			eff.connect("onInCell",self,"effInCell")
	func effInCell(cell):
		var cha = tcha.matCha(cell)
		if cha != null && cha.team != tcha.team :
			tcha.azurHurtChara(cha, (tcha.att.mgiAtk+tcha.att.atk+tcha.att.def+tcha.att.mgiDef) * p1, Chara.HurtType.REAL, Chara.AtkType.SKILL, "元气弹")
			
#----------------------------------------------051元气斩----------------------------------------------
class Skill_051 extends Skill:
	var p1 = 0.1
	func _init(rarity):
		._init(rarity)
		p1 += rarity*0.2
		p1 = min(0.5, p1)
		text = "每次普攻对当前目标附加[双攻双防之和*{0}]的物理伤害".format({"0":p1})
		sname = "元气斩"
		sid = 51
		type = "dps"
		enableAi = false
	func setCha(cha):
		.setCha(cha)
		makeConnect("normalAtkChara", tcha, "normalAtkChara")
	func normalAtkChara(cha):
		var dmg = (tcha.att.mgiAtk+tcha.att.atk+tcha.att.def+tcha.att.mgiDef) * p1
		tcha.azurHurtChara(cha, dmg, Chara.HurtType.REAL, Chara.AtkType.SKILL, "元气斩")

#----------------------------------------------052灵魂灼烧----------------------------------------------
class Skill_052 extends Skill:
	var p1 = 0.01
	func _init(rarity):
		._init(rarity)
		p1 += rarity*0.02
		p1 = min(0.09, p1)
		text = "每10秒对所有具有<烧蚀>的敌人造成[双攻*烧蚀层数*{0}]的真实特效伤害".format({"0":p1})
		sname = "灵魂灼烧"
		sid = 52
		type = "dps"
	func setCha(cha):
		.setCha(cha)
		makeConnect("onCastCdSkill", tcha, "castCdSkill")
		tcha.addCdSkill("soulFire", 10)
		cdId = "soulFire"
		if tcha.isSumm:
			p1 *= 0.5
	func castCdSkill(id):
		if id == "soulFire":
			for i in tcha.getAllChas(1):
				for j in i.buffs:
					if j.id == "b_shaoShi":
						tcha.azurHurtChara(i, (tcha.att.atk+tcha.att.mgiAtk)*p1*j.life, Chara.HurtType.REAL, Chara.AtkType.EFF, "灵魂灼烧")

#----------------------------------------------053全方位防御----------------------------------------------
class Skill_053 extends Skill:
	var p1 = 0
	func _init(rarity):
		._init(rarity)
		p1 += rarity*10
		#20 30 40
		text = "受到伤害时，{0}%概率获得1层<圣盾>".format({"0":p1})
		sname = "全方位防御"
		sid = 53
		type = "t"
		excludeChas = ["cex___als-roon", "cex___als-roon2", "cex___almiu-roonm", "cex___almiu-roonm2"]
		enableAi = false
	func setCha(cha):
		.setCha(cha)
		makeConnect("onHurt", tcha, "onHurt")
	func onHurt(atkInfo:AtkInfo):
		if sys.rndPer(p1):
			buffUtil.addShengDun(tcha, 1)

#----------------------------------------------054舰队荣耀----------------------------------------------
class Skill_054 extends Skill:
	var p1 = 3
	func _init(rarity):
		._init(rarity)
		p1 += rarity*1
		text = "每8秒赋予全体友军{0}层[狂怒][急速]".format({"0":p1})
		sname = "舰队荣耀"
		sid = 54
		type = "sup"
		permission = 2
		excludeChas = ["cex___al-hood", "cex___al-hood2"]
		enableAi = false
	func setCha(cha):
		.setCha(cha)
		makeConnect("onCastCdSkill", tcha, "castCdSkill")
		tcha.addCdSkill("fleetHonor", 8)
		cdId = "fleetHonor"
	func castCdSkill(id):
		if id == "fleetHonor":
			for i in tcha.getAllChas(2):
				if not i.isDeath:
					i.addBuff(buffUtil.b_kuangNu_r.new(p1))
					i.addBuff(buffUtil.b_jiSu_r.new(p1))
#----------------------------------------------055那不勒斯之光----------------------------------------------
class Skill_055 extends Skill:
	var p1 = 15
	func _init(rarity):
		._init(rarity)
		p1 += rarity*5
		p1 = min(p1, 30)
		text = "受到普攻伤害时，{0}%概率使攻击者<眩晕>2秒".format({"0":p1})
		sname = "那不勒斯之光"
		sid = 55
		type = "t"
		excludeChas = ["cex___als-northCarolina", "cex___als-northCarolina2"]
		enableAi = false
	func setCha(cha):
		.setCha(cha)
		makeConnect("onHurt", tcha, "onHurt")
	func onHurt(atkInfo:AtkInfo):
		if atkInfo.atkType == Chara.AtkType.NORMAL and sys.rndPer(p1):
			atkInfo.atkCha.addBuff(buffUtil.b_xuanYun.new(2))

#----------------------------------------------056希腊火----------------------------------------------
class Skill_056 extends Skill:
	var p1 = 30
	func _init(rarity):
		._init(rarity)
		p1 += rarity*10
		text = "造成伤害时，降低目标{0}%的承疗效果，持续4秒，该效果无法被驱散但对塞壬效果减半".format({"0":p1})
		sname = "希腊火"
		sid = 56
		type = "sup"
		enableAi = false
		permission = 2
	func setCha(cha):
		.setCha(cha)
		makeConnect("onAtkChara", tcha, "onAtkChara")
	func onAtkChara(atkInfo):
		if atkInfo.hitCha.hasBuff("b_sk_056") == null:
			atkInfo.hitCha.addBuff(b_sk_056.new(4, p1/100.0))
	class b_sk_056:
		extends Buff
		var buffName = "希腊火"
		var dispel = 2
		func _init(lv = 1, num = 0.5):
			attInit()
			id = "b_sk_056"
			life = lv
			att.reHp = -num
		func _connect():
			._connect()
			if masCha.get("type") == "BOSS":
				life *= 0.5

#----------------------------------------------057短兵相接----------------------------------------------
class Skill_057 extends Skill:
	var p1 = 10
	func _init(rarity):
		._init(rarity)
		p1 += rarity*10
		text = "每秒对周围2格的敌人造成[本回合已受伤害量]的物理技能伤害，每造成10次技能伤害，恢复自身{0}%血量".format({"0":p1})
		sname = "短兵相接"
		sid = 57
		type = "t"
		permission = 3
		enableAi = false
	func setCha(cha):
		.setCha(cha)
		makeConnect("onHurt", tcha, "onHurt")
		makeConnect("onBattleEnd", tcha, "onBattleEnd")
		makeConnect("onAtkChara", tcha, "onAtkChara")
		makeConnect("upS", tcha, "upS")
	var hurtNum = 0
	var skillNum = 0
	func onHurt(atkInfo):
		hurtNum += atkInfo.hurtVal
	func onBattleEnd():
		hurtNum = 0
		skillNum = 0
	func onAtkChara(atkInfo):	
		if atkInfo.atkType == Chara.AtkType.SKILL:
			skillNum += 1
		if skillNum >= 6:
			skillNum = 0
			tcha.healCha(tcha, tcha.att.maxHp*(p1/100.0))
	func upS():
		for i in tcha.getCellChas(tcha.cell, 3, 1):
			tcha.azurHurtChara(i, hurtNum, Chara.HurtType.PHY, Chara.AtkType.SKILL, "短兵相接")


#----------------------------------------------058水漫金山----------------------------------------------
class Skill_058 extends Skill:
	var p1 = 10
	func _init(rarity):
		._init(rarity)
		text = "施放技能时扣10金，若一回合扣了50金，则一次性获得100金"
		sname = "水漫金山"
		sid = 58
		type = "dps"
		permission = 3
	func setCha(cha):
		.setCha(cha)
		makeConnect("onBattleEnd", tcha, "onBattleEnd")
		makeConnect("onCastCdSkill", tcha, "castCdSkill")
	var skillNum = 0
	func onBattleEnd():
		skillNum = 0
	func castCdSkill(id):	
		if skillNum >= 50:return
		skillNum += 10
		sys.main.player.plusGold(-10)
		if skillNum >= 50:
			sys.main.player.plusGold(100)
			skillNum += 100

#----------------------------------------------059同赴国难----------------------------------------------
class Skill_059 extends Skill:
	var p1 = 2
	func _init(rarity):
		._init(rarity)
		p1 += rarity*2
		text = "死亡时为全体敌方单位附加{0}层<流血><烧蚀>".format({"0":p1})
		sname = "同赴国难"
		sid = 59
		type = "sup"
		enableAi = false
	func setCha(cha):
		.setCha(cha)
		makeConnect("onDeath", tcha, "onDeath")
	func onDeath(atkInfo):
		for i in tcha.getAllChas(1):
			i.addBuff(buffUtil.b_liuXue_r.new(p1))
			i.addBuff(buffUtil.b_shaoShi.new(p1))

#----------------------------------------------60炮击指令----------------------------------------------
class Skill_060 extends Skill:
	func _init(rarity):
		._init(rarity)
		text = "每8秒对敌方随机单位发起[我方非航母舰娘数量]次数的炮击，伤害与我方舰娘主炮口径、指挥官双攻相关"
		sname = "炮击指令"
		sid = 60
		type = "dps"
		permission = 2
	func setCha(cha):
		.setCha(cha)
		makeConnect("onCastCdSkill", tcha, "castCdSkill")
		tcha.addCdSkill("fireOrder", 8)
		cdId = "fireOrder"
	func castCdSkill(id):
		if id == "fireOrder":
			utils.createSkillTextEff("炮击指令", tcha.position)
			var chas = tcha.getAllChas(2)
			for i in chas:
				if i.get("type") == "cv":continue
				var bonus = getGunTypeBonus(i)
				var dmg = (tcha.att.atk + tcha.att.mgiAtk) * bonus * 0.7
				tcha.azurHurtChara(utils.getRndEnemy(tcha), dmg, Chara.HurtType.PHY, Chara.AtkType.SKILL, "炮击指令")
	func getGunTypeBonus(cha):
		var type = cha.get("gunType")
		if type == "大型":
			return 1.5
		elif type == "小型":
			return 1
		else:
			return 1.25

#----------------------------------------------061天雷罪灭----------------------------------------------
class Skill_061 extends Skill:
	var p1 = 10
	func _init(rarity):
		._init(rarity)
		text = "每10秒审判罪孽最为深重之人(伤害最高的敌人)，对其造成[法强*5]的真实伤害"
		sname = "天雷罪灭"
		sid = 61
		type = "dps"
		permission = 3
	func setCha(cha):
		.setCha(cha)
		makeConnect("onCastCdSkill", tcha, "castCdSkill")
		tcha.addCdSkill("tianleizm", 10)
		cdId = "tianleizm"
	func castCdSkill(id):	
		if id == "tianleizm":
			tcha.summoner.tianleizm(null, false)

##################################################################################################################
######################################指挥官专属技能###############################################################
##################################################################################################################


#----------------------------------------------200进攻指令----------------------------------------------
class Skill_200 extends Skill:
	func _init(rarity):
		._init(rarity)
		text = "战斗开始时，全体友军提高15%双攻"
		sname = "进攻指令"
		sid = 200
		type = "sup"
		permission = 2
	func setCha(cha):
		.setCha(cha)
		makeConnect("onBattleStart", tcha, "onBattleStart")
	func onBattleStart():
		var chas = tcha.getAllChas(2)
		for i in chas:
			i.addBuff(buffUtil.b_twoAtkL.new(1.5, 0, false))
#----------------------------------------------201防御指令----------------------------------------------
class Skill_201 extends Skill:
	func _init(rarity):
		._init(rarity)
		text = "战斗开始时，全体友军获得15%减伤（与其他减伤乘算）"
		sname = "防御指令"
		sid = 201
		type = "cmd"
		permission = 2
	func setCha(cha):
		.setCha(cha)
		makeConnect("onBattleStart", tcha, "onBattleStart")
	func onBattleStart():
		var chas = tcha.getAllChas(2)
		for i in chas:
			i.addBuff(b_defendOrder.new())
	class b_defendOrder:
		extends Buff
		var buffName = "防御指令"
		var dispel = 2
		func _init():
			attInit()
			id = "b_defendOrder"
		func _connect():
			masCha.connect("onHurt", self, "onHurt")
		func onHurt(atkInfo:AtkInfo):
			if atkInfo.hurtVal > 0 && not atkInfo.isMiss and sys.rndPer(15):
				atkInfo.hurtVal = 0
#----------------------------------------------202空袭指令----------------------------------------------
class Skill_202 extends Skill:
	func _init(rarity):
		._init(rarity)
		text = "每6秒使场上的舰载机获得8层<活力><狂怒><魔力>"
		sname = "空袭指令"
		sid = 202
		type = "cmd"
		permission = 2
	func setCha(cha):
		.setCha(cha)
		makeConnect("onCastCdSkill", tcha, "castCdSkill")
		tcha.addCdSkill("airRaidOrder", 6)
		cdId = "airRaidOrder"
	func castCdSkill(id):
		if id == "airRaidOrder":
			var chas = tcha.getAllChas(2)
			for i in chas:
				if not i.isSumm:continue
				buffUtil.addHuoLi(i, tcha, 8)
				i.addBuff(buffUtil.b_kuangNu_r.new(8))
				i.addBuff(buffUtil.b_moLi.new(8))
#----------------------------------------------203炮击指令----------------------------------------------
class Skill_203 extends Skill:
	func _init(rarity):
		._init(rarity)
		text = "每8秒对敌方随机单位发起[我方非航母舰娘数量]次数的炮击，伤害与我方舰娘主炮口径、指挥官双攻相关"
		sname = "炮击指令"
		sid = 203
		type = "cmd"
		permission = 2
	func setCha(cha):
		.setCha(cha)
		makeConnect("onCastCdSkill", tcha, "castCdSkill")
		tcha.addCdSkill("fireOrder", 8)
		cdId = "fireOrder"
	func castCdSkill(id):
		if id == "fireOrder":
			utils.createSkillTextEff("炮击指令", tcha.position)
			var chas = tcha.getAllChas(2)
			for i in chas:
				if i.get("type") == "cv":continue
				var bonus = getGunTypeBonus(i)
				var dmg = (tcha.att.atk + tcha.att.mgiAtk) * bonus * 0.7
				tcha.azurHurtChara(utils.getRndEnemy(tcha), dmg, Chara.HurtType.PHY, Chara.AtkType.SKILL, "炮击指令")
	func getGunTypeBonus(cha):
		var type = cha.get("gunType")
		if type == "大型":
			return 1.5
		elif type == "小型":
			return 1
		else:
			return 1.25
#----------------------------------------------204补给指令----------------------------------------------
class Skill_204 extends Skill:
	func _init(rarity):
		._init(rarity)
		text = "战斗结束时，获得[军衔等级*5]的金币补给"
		sname = "补给指令"
		sid = 204
		type = "cmd"
		permission = 2
	func setCha(cha):
		.setCha(cha)
		makeConnect("onBattleEnd", tcha, "onBattleEnd")
	func onBattleEnd():
		sys.main.player.plusGold(tcha.get("rank") * 5)
#----------------------------------------------205维修指令----------------------------------------------
class Skill_205 extends Skill:
	func _init(rarity):
		._init(rarity)
		text = "每7秒使全体友军恢复[目标角色血上限30%]的血量"
		sname = "维修指令"
		sid = 205
		type = "cmd"
		permission = 2
	func setCha(cha):
		.setCha(cha)
		makeConnect("onCastCdSkill", tcha, "castCdSkill")
		tcha.addCdSkill("repairOrder", 7)
		cdId = "repairOrder"
	func castCdSkill(id):
		if id == "repairOrder":
			var chas = tcha.getAllChas(2)
			for i in chas:
				tcha.healCha(i, i.att.maxHp*0.3)
#----------------------------------------------206干扰指令----------------------------------------------
class Skill_206 extends Skill:
	func _init(rarity):
		._init(rarity)
		text = "全体敌人造成的伤害降低18%"
		sname = "干扰指令"
		sid = 206
		type = "cmd"
		permission = 2
	func setCha(cha):
		.setCha(cha)
		makeConnect("onBattleStart", tcha, "onBattleStart")
	func onBattleStart():
		var chas = tcha.getAllChas(1)
		for i in chas:
			i.addBuff(buffUtil.b_atkR.new(-1.8, 0, false))


##################################################################################################################
######################################指挥官专属阵营技能############################################################
##################################################################################################################
#----------------------------------------------300 舰队指挥·重樱----------------------------------------------
class Skill_300 extends Skill:
	func _init(rarity):
		._init(rarity)
		text = "装备重樱军旗后，我方所有重樱阵营的角色，在战斗结束时，永久提升3点四维属性"
		sname = "舰队指挥·重樱"
		sid = 300
		type = "cmd"
		permission = 2
	func setCha(cha):
		.setCha(cha)
		makeConnect("onBattleEnd", tcha, "onBattleEnd")
	func onBattleEnd():
		var flag = false
		for i in tcha.items:
			if i.id == "i_Hide_al_flagcy":
				flag = true
				break
		if flag:
			for i in tcha.getAllChas(2):
				if i.get("camp") == "重樱":
					i.updateTmpAtt("atk", 3, false)
					i.updateTmpAtt("mgiAtk", 3, false)
					i.updateTmpAtt("def", 3, false)
					i.updateTmpAtt("mgiDef", 3, false)
					i.upAtt()
#----------------------------------------------301 舰队指挥·皇家----------------------------------------------
class Skill_301 extends Skill:
	func _init(rarity):
		._init(rarity)
		text = "装备皇家军旗后，我方所有皇家阵营的角色(含召唤物)，造成的伤害可以暴击，受到的非暴击伤害降低25%"
		sname = "舰队指挥·皇家"
		sid = 301
		type = "cmd"
		permission = 2
	func setCha(cha):
		.setCha(cha)
		makeConnect("onBattleStart", tcha, "onBattleStart")
		makeConnect("onCharaNewChara", tcha, "onCharaNewChara")
		makeConnect("onHurt", tcha, "onHurt")

	func onHurt(atkInfo):
		if not atkInfo.isCri:
			atkInfo.hurtVal *= 0.75

	var flag = false
	func onBattleStart():
		flag = false
		for i in tcha.items:
			if i.id == "i_Hide_al_flaghj":
				flag = true
				break
		if flag:
			for i in tcha.getAllChas(2):
				if i.get("camp") == "皇家":
					i.criFlag = true
	func onCharaNewChara(cha):
		if flag:
			cha.criFlag = true			

#----------------------------------------------302 舰队指挥·白鹰----------------------------------------------
class Skill_302 extends Skill:
	func _init(rarity):
		._init(rarity)
		text = "装备白鹰军旗后，我方所有白鹰阵营的角色，免疫负面效果"
		sname = "舰队指挥·白鹰"
		sid = 302
		type = "cmd"
		permission = 2
	func setCha(cha):
		.setCha(cha)
		makeConnect("onBattleStart", tcha, "onBattleStart")

	var flag = false
	func onBattleStart():
		flag = false
		for i in tcha.items:
			if i.id == "i_Hide_al_flagby":
				flag = true
				break
		if flag:
			for i in tcha.getAllChas(2):
				if i.get("camp") == "白鹰":
					i.addBuff(buffUtil.b_mianYi_by.new())
	class b_mianYi_by:
		extends Buff
		var buffName = "舰队指挥·白鹰"
		var dispel = 2
		func _init():
			attInit()
			id = "b_mianYi_by"
		func _connect():
			masCha.connect("onAddBuff",self,"onAddBuff")
		func onAddBuff(buff):
			if buff.isNegetive:
				buff.isDel = true				

#----------------------------------------------303 舰队指挥·铁血----------------------------------------------
class Skill_303 extends Skill:
	func _init(rarity):
		._init(rarity)
		text = "Z旗提供的属性加成及特效效果提高40%"
		sname = "舰队指挥·铁血"
		sid = 303
		type = "cmd"
		permission = 2
	func setCha(cha):
		.setCha(cha)
		makeConnect("onBattleStart", tcha, "onBattleStart")
	func onBattleStart():
		yield(sys.get_tree().create_timer(1), "timeout")
		var chas = tcha.getAllChas(1)
		for i in chas:
			var bf = i.hasBuff("b_flag_z")
			if bf != null:
				bf.att.defL *= 1.4
				bf.att.mgiDefL *= 1.4
				bf.att.maxHp *= 1.4
				bf.bonus = 1.4

#----------------------------------------------304 舰队指挥·碧蓝----------------------------------------------
class Skill_304 extends Skill:
	func _init(rarity):
		._init(rarity)
		text = "装备碧蓝战旗后，我方所有北方联合/自由鸢尾/其他阵营的角色，战斗开始后每秒提高4%冷却速度、攻速、暴伤、吸血(上限75%)"
		sname = "舰队指挥·碧蓝"
		sid = 304
		type = "cmd"
		permission = 2
	func setCha(cha):
		.setCha(cha)
		makeConnect("onBattleStart", tcha, "onBattleStart")
	var flag = false
	func onBattleStart():
		flag = false
		for i in tcha.items:
			if i.id == "i_Hide_al_flagx":
				flag = true
				break
		if flag:
			for i in tcha.getAllChas(2):
				if i.get("camp") == "北方联合" or i.get("camp") == "自由鸢尾" or i.get("camp") == "其他":
					i.addBuff(b_skill_304.new())
	class b_skill_304:
		extends Buff
		var dispel = 2
		var buffName = "舰队指挥·碧蓝"
		func _init():
			attInit()
			id = "b_skill_304"
		func _upS():
			if att.spd < 0.75:
				att.spd += 0.04	
			if att.cd < 0.75:
				att.cd += 0.04		
			if att.criR < 0.75:
				att.criR += 0.04	
				att.suck += 0.04
				att.mgiSuck += 0.04					