extends Node
func _init():
	pass

var skills = {
	"i_al_127Single":[Skill_001], "i_al_152MK17":[Skill_002], "i_al_203Test":[Skill_003], "i_al_380":[Skill_004], "i_al_406MK6":[Skill_005],
	"unknown1":[Skill_006], "i_al_410Test":[Skill_007], "unknown2":[Skill_009], "i_al_oilTank":[Skill_010],
	"i_Hide_al_piggyBank":[Skill_011], "i_Hide_al_steering":[Skill_012], "i_al_vc":[Skill_013], "unknown3":[Skill_014], "i_azurline_113":[Skill_015],
	"i_azurline_127":[Skill_016], "i_azurline_203skc":[Skill_017], "i_azurline_381":[Skill_018], "i_azurline_533":[Skill_019], "unknown4":[Skill_020],
	"i_azurline_fylgc":[Skill_021], "i_azurline_hjmc":[Skill_022], "i_azurline_hkld":[Skill_023], "i_Hide_al_repairKit":[Skill_024], "i_Hide_al_sg":[Skill_025],
	"i_azurline_vh":[Skill_026], "i_Hide_al_zdj":[Skill_027], "i_azurline_zzzl":[Skill_028], "i_Hide_al_kongPao":[Skill_029], "i_Hide_al_fi282":[Skill_030],
	"i_Hide_al_lightLance":[Skill_031], "i_Hide_al_projector":[Skill_032], "i_Hide_al_voodooDoll":[Skill_033], "i_Hide_al_repeater":[Skill_034], "i_Hide_al_tuoluo":[Skill_035],
	"i_azurline_fuhuo":[Skill_036], "i_azurline_huangyouyou":[Skill_037], "i_Hide_al_98delay":[Skill_038], "i_Hide_al_ciwei":[Skill_039], "i_Hide_al_chryDart":[Skill_040],
	"i_Hide_al_awakeningPeal":[Skill_041], "i_Hide_al_candyBullet":[Skill_042], "i_Hide_al_explorerMedal":[Skill_043], "i_Hide_al_gaiLiangSN":[Skill_044],
	"i_Hide_al_heAmmo":[Skill_045], "i_Hide_al_highMagnet":[Skill_046], "i_Hide_al_hotSteel":[Skill_047],
}

class Skill extends Object:
	var text
	#技能绑定于哪件装备，对象
	var item:Item
	var sname
	var upgraded:bool
	var utils = globalData.infoDs["g_azurlineUtils"]
	var buffUtil = globalData.infoDs["g_azurlineBuffs"]
	var cdId
	#升级进度
	var readNum = 0
	#周围一格
	var aroundCells = [Vector2(-1,0),Vector2(1,0),Vector2(0,1),Vector2(0,-1),Vector2(1,1),Vector2(-1,-1),Vector2(1,-1),Vector2(-1,1)]
	#connect记录
	var cons = []
	var tcha
	func makeConnect(origin, object, target):
		object.connect(origin, self, target)
		cons.append({"origin":origin,"target":target, "object":object})
	func setItem(item):
		tcha = item.masCha
		self.item = item
		makeConnect("onBattleStart", sys.main, "start")
	func remove():
		for i in cons:
			i.object.disconnect(i.origin, self, i.target)
		if cdId != null:
			for i in tcha.skills:
				if i.id == cdId:
					tcha.skills.erase(i)
					break
	func start():
		if item == null:return
		if item.masCha != tcha:
			remove()

	func checkCha():
		if item == null:return false
		return item.masCha == tcha

#----------------------------------------------001 127MM单装炮----------------------------------------------
class Skill_001 extends Skill:
	func _init():
		._init()
		text = "每次施放技能，缩短自身所有技能冷却1秒（对冷却已低于1.5秒的技能不生效）"
	func setItem(item):
		.setItem(item)
		makeConnect("onCastCdSkill", tcha, "onCastCdSkill")
		makeConnect("upS", tcha, "upS")
	func onCastCdSkill(id):
		if not enable:return
		enable = false
		for j in tcha.skills:
			if j.cd/(1+tcha.att.cd) - j.nowTime > 1.5:
				j.nowTime += 1
	var enable = true
	func upS():
		enable = true
#----------------------------------------------002 试作型三联装152MM炮MK17----------------------------------------------
class Skill_002 extends Skill:
	func _init():
		._init()
		text = "本回合内，每次施放技能，提高自身5%法术穿透"
	func setItem(item):
		.setItem(item)
		makeConnect("onCastCdSkill", tcha, "onCastCdSkill")
	func onCastCdSkill(id):
		var buff = tcha.hasBuff("b_mgiPenL_p")
		if buff == null:
			tcha.addBuff(utils.buffs.b_mgiPenL.new(5))
		else:
			buff.att.mgiPenL += 0.5
#----------------------------------------------003 试作型三联203MM主炮----------------------------------------------
class Skill_003 extends Skill:
	func _init():
		._init()
		text = "普攻附加3层<烧蚀>且获得3层[急速]"
	func setItem(item):
		.setItem(item)
		makeConnect("onAtkChara", tcha, "onAtkChara")
	func onAtkChara(atkInfo:AtkInfo):
		if atkInfo.atkType == Chara.AtkType.NORMAL:
			tcha.addBuff(utils.buffs.b_jiSu_r.new(3))
			if atkInfo.hitCha.team != atkInfo.atkCha.team:
				atkInfo.hitCha.addBuff(utils.buffs.b_shaoShi.new(3, tcha))
#----------------------------------------------004 四联380MM主炮----------------------------------------------
class Skill_004 extends Skill:
	func _init():
		._init()
		text = "每普攻3次，对目标周围(九宫格范围)的敌人造成[物攻*3]的物理伤害"
	func setItem(item):
		.setItem(item)
		makeConnect("onAtkChara", tcha, "onAtkChara")
	var atkNum = 0
	func onAtkChara(atkInfo:AtkInfo):
		if atkInfo.atkType == Chara.AtkType.NORMAL:
			atkNum += 1
			if atkNum >= 3:
				for i in aroundCells:
					var cha = tcha.matCha(atkInfo.hitCha.cell+i)
					if cha != null && cha.team != tcha.team:
						tcha.azurHurtChara(cha, tcha.att.atk * 3, Chara.HurtType.PHY, Chara.AtkType.EFF, "四联380MM主炮")
				atkNum = 0
#----------------------------------------------005 三联406MM主炮MK6----------------------------------------------
class Skill_005 extends Skill:
	func _init():
		._init()
		text = "使自己造成的所有非普攻伤害均能触发吸血(吸血系数为自身物理吸血+法术吸血)"
	func setItem(item):
		.setItem(item)
		makeConnect("onAtkChara", tcha, "onAtkChara")
	func onAtkChara(atkInfo:AtkInfo):
		if atkInfo.hurtType == Chara.HurtType.PHY && atkInfo.atkType != Chara.AtkType.NORMAL:
			tcha.plusHp(atkInfo.hurtVal*(tcha.att.suck+tcha.att.mgiSuck))
#----------------------------------------------006 未知装备----------------------------------------------
class Skill_006 extends Skill:
	func _init():
		._init()
		text = "每次普攻使目标身上的负面效果层数增加3层"
	func setItem(item):
		.setItem(item)
		makeConnect("onAtkChara", tcha, "onAtkChara")
	func onAtkChara(atkInfo:AtkInfo):
		if atkInfo.atkType == Chara.AtkType.NORMAL and atkInfo.hitCha.team != atkInfo.atkCha.team:
			for j in atkInfo.hitCha.buffs:
				if j.get("type") != config.EQUITYPE_EQUI && j.life != null && j.life > 0 and j.isNegetive:
					j.life += min(20, j.life + 3)
#----------------------------------------------007 试作型410MM三联炮----------------------------------------------
class Skill_007 extends Skill:
	func _init():
		._init()
		text = "造成技能伤害时，附加5层<漏水>"
	func setItem(item):
		.setItem(item)
		makeConnect("onAtkChara", tcha, "onAtkChara")
	func onAtkChara(atkInfo:AtkInfo):
		if atkInfo.atkType == Chara.AtkType.SKILL and atkInfo.hitCha.team != atkInfo.atkCha.team:
			utils.buffs.addLouShui(atkInfo.hitCha, tcha, 5)
#----------------------------------------------009 ----------------------------------------------
class Skill_009 extends Skill:
	func _init():
		._init()
		text = "获得负面效果时，恢复自身4%血量"
	func setItem(item):
		.setItem(item)
		makeConnect("onAddBuff", tcha, "onAddBuff")
	func onAddBuff(buff:Buff):
		if buff.isNegetive && enable:
			tcha.plusHp(tcha.att.maxHp*0.04)
			enable = false
	var enable = true
	func _upS():
		enable = true
#----------------------------------------------010 航空副油箱----------------------------------------------
class Skill_010 extends Skill:
	func _init():
		._init()
		text = "提高自身舰载机50%血量"
	func setItem(item):
		.setItem(item)
		makeConnect("summChara", tcha, "summChara")
	func summChara(cha):
		var num = cha.att.maxHp*0.5
		cha.attInfo.maxHp += num
		cha.upAtt()
		cha.plusHp(num)
#----------------------------------------------011 存钱罐----------------------------------------------
class Skill_011 extends Skill:
	func _init():
		._init()
		text = "战斗开始后，每秒80%积蓄1金币，使用技能会增加1点积蓄，受到敌方的伤害会损失30%积蓄，回合结束时结算，每回合上限80"
	func setItem(item):
		.setItem(item)
		makeConnect("onCastCdSkill", tcha, "onCastCdSkill")
		makeConnect("onHurt", tcha, "onHurt")
		makeConnect("onBattleEnd", tcha, "onBattleEnd")
	var num = 0
	func onCastCdSkill(id):
		num += 1
	func _upS():
		if tcha == null || not utils.inBattle(tcha):return
		if sys.rndPer(80):
			num += 1
	func end():
		if tcha == null || not utils.inBattle(tcha):return
		num = min(80, num)
		sys.main.player.plusGold(num)
		num = 0
	func onHurt(atkInfo):
		if atkInfo.hitCha.team != atkInfo.atkCha.team:
			num *= 0.7
#----------------------------------------------012 高性能舵机----------------------------------------------
class Skill_012 extends Skill:
	func _init():
		._init()
		text = "每次使用技能，获得5层<振奋>"
	func setItem(item):
		.setItem(item)
		makeConnect("onCastCdSkill", tcha, "onCastCdSkill")
	func onCastCdSkill(id):
		tcha.addBuff(utils.buffs.b_zhenFen.new(5))
#----------------------------------------------013 VC装甲钢板----------------------------------------------
class Skill_013 extends Skill:
	func _init():
		._init()
		text = "免疫<重创><烧蚀><中毒><破甲><霜冻>"
	func setItem(item):
		.setItem(item)
		makeConnect("onAddBuff", tcha, "onAddBuff")
	var includes = ["b_zhongChang", "b_shaoShi", "b_zhonDu", "b_zhonDu_r", "b_perforation", "b_louShui"]
	func onAddBuff(buff:Buff):
		if includes.has(buff.id):
			buff.isDel = true
#----------------------------------------------014 一式穿甲弹----------------------------------------------
class Skill_014 extends Skill:
	func _init():
		._init()
		text = "普攻命中敌方单位时，赋予对方3层<破甲>"
	func setItem(item):
		.setItem(item)
		makeConnect("onAtkChara", tcha, "onAtkChara")
	func onAtkChara(atkInfo):
		if atkInfo.atkType == Chara.AtkType.NORMAL and atkInfo.hitCha.team != atkInfo.atkCha.team:
			atkInfo.hitCha.addBuff(utils.buffs.b_perforation.new(3, tcha))
#----------------------------------------------015 双联113mm高射炮----------------------------------------------
class Skill_015 extends Skill:
	func _init():
		._init()
		text = "造成非普攻伤害时，目标身上每有1层<漏水><烧蚀><霜冻>，提高8%伤害"
	func setItem(item):
		.setItem(item)
		makeConnect("onAtkChara", tcha, "onAtkChara")
	var includes = ["b_shaoShi", "b_louShui", "b_freeze"]
	func onAtkChara(atkInfo:AtkInfo):
		if atkInfo.atkType != Chara.AtkType.NORMAL:
			var num = 0
			for i in atkInfo.hitCha.buffs:
				if includes.has(i.id):num += 1
			atkInfo.factor += num * 0.08
#----------------------------------------------016 双联127mm高平两用炮----------------------------------------------
class Skill_016 extends Skill:
	func _init():
		._init()
		text = "技能命中敌方单位时，赋予目标7层<烧蚀>"
	func setItem(item):
		.setItem(item)
		makeConnect("onAtkChara", tcha, "onAtkChara")
	func onAtkChara(atkInfo:AtkInfo):
		if atkInfo.atkType == Chara.AtkType.SKILL and atkInfo.hitCha.team != atkInfo.atkCha.team: 
			atkInfo.hitCha.addBuff(utils.buffs.b_shaoShi.new(7))
#----------------------------------------------017 双联203mmSKC主炮----------------------------------------------
class Skill_017 extends Skill:
	func _init():
		._init()
		text = "普攻额外造成目标最大生命值5%的物理伤害"
	func setItem(item):
		.setItem(item)
		makeConnect("onAtkChara", tcha, "onAtkChara")
	func onAtkChara(atkInfo:AtkInfo):
		if atkInfo.atkType == Chara.AtkType.NORMAL and atkInfo.hitCha.team != atkInfo.atkCha.team:
			tcha.azurHurtChara(atkInfo.hitCha,atkInfo.hitCha.att.maxHp*0.05,Chara.HurtType.PHY,Chara.AtkType.EFF, "双联203mmSKC主炮")
#----------------------------------------------018 双联381mm主炮----------------------------------------------
class Skill_018 extends Skill:
	func _init():
		._init()
		text = "战斗开始后，每秒提升8%攻速，上限200%"
	func setItem(item):
		.setItem(item)
		makeConnect("onBattleStart", tcha, "onBattleStart")
	func onBattleStart():
		if checkCha():
			tcha.addBuff(b_spd_incr.new(0.08, 20))
	class b_spd_incr:
		extends Buff
		var dispel = 2
		var p1 = 0.1
		var p2 = 20
		func _init(p1 = 0.1, p2 = 20):
			attInit()
			id = "b_spd_incr"
			self.p1 = p1
			self.p2 = p2
		var num = 0
		func _upS():
			num += 1
			if num > p2:
				num = p2
			att.spd = p1*num
#----------------------------------------------019 五联装533mm鱼雷----------------------------------------------
class Skill_019 extends Skill:
	func _init():
		._init()
		text = "造成10次技能伤害后，发射一条鱼雷，对直线上的所有敌人造成[法强*2]的特效伤害"
	func setItem(item):
		.setItem(item)
		makeConnect("onAtkChara", tcha, "onAtkChara")
	var snum = 0
	func onAtkChara(atkInfo:AtkInfo):
		if atkInfo.atkType == Chara.AtkType.SKILL and atkInfo.hitCha.team != atkInfo.atkCha.team: 
			snum += 1
			if snum >= 10 and tcha.aiCha != null:
				snum = 0
				var eff:Eff = tcha.newEff("sk_chuanTouJian", tcha.sprcPos)
				eff._initFlyPos(tcha.position + (tcha.aiCha.position - tcha.position).normalized() * 1000,250)
				eff.connect("onInCell",self,"effInCell")
	func effInCell(cell):
		var cha = tcha.matCha(cell)
		if cha == null:
			cha = tcha.matCha(cell + Vector2(0, 1))
		if cha != null && cha.team != tcha.team:
			tcha.azurHurtChara(cha, tcha.att.mgiAtk*2, Chara.HurtType.MGI, Chara.AtkType.EFF, "五联装533mm鱼雷")
#----------------------------------------------020 超重弹----------------------------------------------
class Skill_020 extends Skill:
	func _init():
		._init()
		text = "技能命中敌方单位时，赋予对方8层<破甲>"
	func setItem(item):
		.setItem(item)
		makeConnect("onAtkChara", tcha, "onAtkChara")
	func onAtkChara(atkInfo:AtkInfo):
		if atkInfo.atkType == Chara.AtkType.SKILL and atkInfo.hitCha.team != atkInfo.atkCha.team:
			atkInfo.hitCha.addBuff(utils.buffs.b_perforation.new(8, tcha))
#----------------------------------------------021 防鱼雷隔仓----------------------------------------------
class Skill_021 extends Skill:
	func _init():
		._init()
		text = "受到暴击时，减少50%所受伤害"
	func setItem(item):
		.setItem(item)
		makeConnect("onHurt", tcha, "onHurt")
	func onHurt(atkInfo:AtkInfo):
		if atkInfo.isCri:
			atkInfo.hurtVal *= 0.5
#----------------------------------------------022 海军迷彩----------------------------------------------
class Skill_022 extends Skill:
	func _init():
		._init()
		text = "受到普攻时，会赋予攻击者3层<致盲>"
	func setItem(item):
		.setItem(item)
		makeConnect("onHurt", tcha, "onHurt")
	func onHurt(atkInfo:AtkInfo):
		if atkInfo.atkType == Chara.AtkType.NORMAL and atkInfo.hitCha.team != atkInfo.atkCha.team:
			atkInfo.atkCha.addBuff(utils.buffs.b_blindness.new(3))
#----------------------------------------------023 火控雷达----------------------------------------------
class Skill_023 extends Skill:
	func _init():
		._init()
		text = "自身及周围2格友军攻击无视闪避"
	func setItem(item):
		.setItem(item)
		makeConnect("onBattleStart", tcha, "onBattleStart")
	func onBattleStart():
		if not checkCha():return
		for cha in tcha.getCellChas(tcha.cell, 2, 2):
			cha.addBuff(utils.buffs.b_biZhong.new())
#----------------------------------------------024 维修工具----------------------------------------------
class Skill_024 extends Skill:
	func _init():
		._init()
		text = "每秒恢复自身[血上限1%]的生命值"
	func setItem(item):
		.setItem(item)
		makeConnect("upS", tcha, "upS")
	func upS():
		tcha.plusHp(tcha.att.maxHp * 0.01)
#----------------------------------------------025 SG雷达----------------------------------------------
class Skill_025 extends Skill:
	func _init():
		._init()
		text = "雷达锁定当前目标，使其额外承受30%的伤害"
	func setItem(item):
		.setItem(item)
		makeConnect("onAtkChara", tcha, "onAtkChara")
	func onAtkChara(atkInfo):
		if atkInfo.atkType == Chara.AtkType.NORMAL && not atkInfo.hitCha.hasBuff("b_SG") and atkInfo.hitCha.team != atkInfo.atkCha.team:
			atkInfo.hitCha.addBuff(b_SG.new(-0.3))
	class b_SG:
		extends Buff
		func _init(num = -0.15):
			attInit()
			id = "b_SG"	
			isNegetive = true
			att.defR = num
#----------------------------------------------026 VH装甲钢板----------------------------------------------
class Skill_026 extends Skill:
	func _init():
		._init()
		text = "受到的技能伤害降低30%"
	func setItem(item):
		.setItem(item)
		makeConnect("onHurt", tcha, "onHurt")
	func onHurt(atkInfo:AtkInfo):
		if atkInfo.atkType == Chara.AtkType.SKILL:
			atkInfo.hurtVal *= 0.7
#----------------------------------------------027 链式装弹机----------------------------------------------
class Skill_027 extends Skill:
	func _init():
		._init()
		text = "每次普攻加快自身技能冷却0.5秒，每秒最多触发一次"
	func setItem(item):
		.setItem(item)
		makeConnect("onAtkChara", tcha, "onAtkChara")
	var flag = true
	func onAtkChara(atkInfo):
		if atkInfo.atkType == Chara.AtkType.NORMAL && flag:
			var skills = tcha.skills
			for i in skills:
				if i.cd/(1+tcha.att.cd) - i.nowTime > 1:
					i.nowTime += 0.5
			flag = false
	func _upS():
		flag = true
#----------------------------------------------028 珍珠之泪----------------------------------------------
class Skill_028 extends Skill:
	func _init():
		._init()
		text = "当佩戴者死亡时，给全体敌人附加10层<霜冻>[流血]"
	func setItem(item):
		.setItem(item)
		makeConnect("onDeath", tcha, "onDeath")
	func onDeath(atkInfo:AtkInfo):
		deathWord()
	func deathWord():
		var chas = tcha.getAllChas(1)
		for i in chas:
			i.addBuff(utils.buffs.b_freeze.new(6))
			i.addBuff(utils.buffs.b_liuXue_r.new(6))

#----------------------------------------------029 超空泡发生器---------------------------------------------
class Skill_029 extends Skill:
	func _init():
		._init()
		text = "对塞壬造成的伤害提高50%"
	func setItem(item):
		.setItem(item)
		makeConnect("onAtkChara", tcha, "onAtkChara")
	func onAtkChara(atkInfo:AtkInfo):	
		if atkInfo.hitCha.get("type") == "BOSS":
			atkInfo.factor += 0.5

#----------------------------------------------030 FI-282直升机---------------------------------------------
class Skill_030 extends Skill:
	func _init():
		._init()
		text = "每秒对当前目标造成[攻击*1]的可暴击物理普攻伤害"
	func setItem(item):
		.setItem(item)
		makeConnect("upS", tcha, "upS")
	func upS():
		if not tcha.isDeath:
			tcha.azurHurtChara(tcha.aiCha, tcha.att.atk, Chara.HurtType.PHY, Chara.AtkType.NORMAL, "FI-282直升机", true)
#----------------------------------------------031 光矛----------------------------------------------
class Skill_031 extends Skill:
	func _init():
		._init()
		text = "每5秒，对所有具有护盾的敌人造成[目标护盾值*200%]的魔法伤害"
	func setItem(item):
		.setItem(item)
		makeConnect("upS", tcha, "upS")
		makeConnect("onBattleEnd",tcha,"onBattleEnd")
	var num = 0
	func upS():
		num += 1
		if num >= 5:
			for i in tcha.getAllChas(1):
				if i.get("shield") > 0:
					tcha.azurHurtChara(i, i.get("shield")*2, Chara.HurtType.MGI, Chara.AtkType.SKILL, "光矛")
			num = 0
	func onBattleEnd():
		num = 0
#----------------------------------------------032 投影仪----------------------------------------------
class Skill_032 extends Skill:
	func _init():
		._init()
		text = "战斗开始时会召唤一个佩戴者的克隆体，不会继承装备与额外加成属性"
	func setItem(item):
		.setItem(item)
		makeConnect("onBattleStart",tcha,"onBattleStart")
	func onBattleStart():
		if not checkCha():return
		if sys.main.matCha(tcha.cell) != tcha || tcha.get("type") == "siren":return
		tcha.summChara(tcha.id)
#----------------------------------------------033 巫毒人偶----------------------------------------------
class Skill_033 extends Skill:
	func _init():
		._init()
		text = "造成法术伤害时，强驱散佩戴者当前普攻目标的所有增益效果"
	func setItem(item):
		.setItem(item)
		makeConnect("onAtkChara",tcha,"onAtkChara")
	func onAtkChara(atkInfo):
		if tcha.aiCha == null or atkInfo.hurtType != Chara.HurtType.MGI or atkInfo.hitCha.team == atkInfo.atkCha.team:return
		for j in tcha.aiCha.buffs:
			if not j.isNegetive && j.get("type") != config.EQUITYPE_EQUI:
				j.isDel = true
#----------------------------------------------034 复读机----------------------------------------------
class Skill_034 extends Skill:
	func _init():
		._init()
		text = "佩戴者每次施放技能，40%概率会立即再施放一次"
	func setItem(item):
		.setItem(item)
		makeConnect("onCastCdSkill", tcha, "onCastCdSkill")
		makeConnect("upS", tcha, "upS")
	func onCastCdSkill(id):
		if enable && sys.rndPer(40):
			var skill = tcha.getSkill(id)
			enable = false
			skill.nowTime += skill.cd/(1+tcha.att.cd)
	var enable = true
	func upS():
		enable = true

#----------------------------------------------035 陀螺仪----------------------------------------------
class Skill_035 extends Skill:
	func _init():
		._init()
		text = "战斗开始时提高80%闪避，每秒减少2%"
	func setItem(item):
		.setItem(item)
		makeConnect("upS", tcha, "upS")
	func upS():
		if tcha.hasBuff("b_al_tuoluoyi") == null:
			tcha.addBuff(b_al_tuoluoyi.new(0.8))
	class b_al_tuoluoyi:
		extends Buff
		var buffName = "陀螺仪"
		var dispel = 2 
		func _init(p):
			attInit()
			id = "b_al_tuoluoyi"
			att.dod = p
		func _upS():
			if att.dod > 0:
				att.dod -= 0.02

#----------------------------------------------036 四神之力----------------------------------------------
class Skill_036 extends Skill:
	func _init():
		._init()
		text = "<限定>本回合内，死亡后，满血复活"
	func setItem(item):
		.setItem(item)
		makeConnect("onDeath", tcha, "onDeath")
		makeConnect("onBattleStart", sys.main, "onBattleStart")
	var enable = true
	func onBattleStart():
		enable = true
	func onDeath(atkInfo):
		if enable and tcha.isDeath:
			enable = false
			tcha.isDeath = false
			tcha.plusHp(tcha.att.maxHp)

#----------------------------------------------037 晃悠悠----------------------------------------------
class Skill_037 extends Skill:
	func _init():
		._init()
		text = "每秒对周围1格(九宫格)范围的敌人造成[目标血上限3%]的真实技能伤害"
	func setItem(item):
		.setItem(item)
		makeConnect("upS", tcha, "upS")
	func upS():
		for i in tcha.getAroundChas(tcha.cell, false):
			tcha.azurHurtChara(i, i.att.maxHp*0.03, Chara.HurtType.REAL, Chara.AtkType.SKILL, "晃悠悠")

#----------------------------------------------038 九八式射击延迟装置----------------------------------------------
class Skill_038 extends Skill:
	func _init():
		._init()
		text = "延长技能冷却时间50%，提高自身技能伤害50%"
	func setItem(item):
		.setItem(item)
		makeConnect("onAtkChara", tcha, "onAtkChara")
		makeConnect("onCastCdSkill", tcha, "onCastCdSkill")
	func onCastCdSkill(id):
		var sk = tcha.getSkill("id")
		sk.nowTime -= sk.cd/(1 + tcha.att.cd) * 0.5 
	func onAtkChara(atkInfo:AtkInfo):
		if atkInfo.atkType == Chara.AtkType.SKILL:
			atkInfo.hurtVal *= 1.5	

#----------------------------------------------039 刺猬炮----------------------------------------------
class Skill_039 extends Skill:
	func _init():
		._init()
		text = "每8秒对目标造成1点的8次技能伤害与8次普攻伤害"
	func setItem(item):
		.setItem(item)
		makeConnect("upS", tcha, "upS")
	var index = 0
	func upS():
		index += 1
		if index >= 8 and tcha.aiCha != null:
			index = 0
			for i in range(8):
				if tcha.aiCha == null or tcha.aiCha.isDeath:continue
				tcha.hurtChara(tcha.aiCha, 1, Chara.HurtType.REAL, Chara.AtkType.EFF)

#----------------------------------------------040 菊花镖----------------------------------------------
class Skill_040 extends Skill:
	func _init():
		._init()
		text = "从目标侧后方造成的伤害提高50%"
	func setItem(item):
		.setItem(item)
		makeConnect("onAtkChara", tcha, "onAtkChara")
	func onAtkChara(atkInfo:AtkInfo):
		var cha = atkInfo.hitCha
		if tcha.team == cha.team:return
		if tcha.team == 1:
			if tcha.cell.x >= cha.cell.x:
				atkInfo.hurtVal *= 1.5
		if tcha.team == 2:
			if tcha.cell.x <= cha.cell.x:
				atkInfo.hurtVal *= 1.5
#----------------------------------------------041 觉醒宝珠---------------------------------------------
class Skill_041 extends Skill:
	func _init():
		._init()
		text = "若佩戴者拥有<亡语>技能，则每8秒触发其亡语效果"
	func setItem(item):
		.setItem(item)
		makeConnect("upS", tcha, "upS")
	var index = 0
	func upS():
		index += 1
		if index >= 8 and not tcha.isDeath:
			index = 0
			for i in range(8):
				if tcha.has_method("deathWord"):
					tcha.deathWord()
#----------------------------------------------042 糖衣炮弹---------------------------------------------
class Skill_042 extends Skill:
	func _init():
		._init()
		text = "战斗开始时，使位于自己同行对称位置的敌人<眩晕>15秒"
	func setItem(item):
		.setItem(item)
		makeConnect("onBattleStart", sys.main, "onBattleStart")
	func onBattleStart():
		if not utils.inBattle(tcha):return
		var cell = tcha.cell
		var cha = sys.main.matCha(Vector2(9 - cell.x, cell.y))
		if cha != null && cha.team != tcha.team:
			cha.addBuff(utils.buffs.b_xuanYun.new(15))
#----------------------------------------------043 开拓者奖章---------------------------------------------
class Skill_043 extends Skill:
	func _init():
		._init()
		text = "血量大于50%时，获得35%伤害提升，血量低于50%时，获得35%伤害减免"
	func setItem(item):
		.setItem(item)
		makeConnect("onAtkChara", tcha, "onAtkChara")
		makeConnect("onHurt", tcha, "onHurt")
	func onAtkChara(atkInfo:AtkInfo):
		if tcha.att.hp / tcha.att.maxHp >= 0.5:
			atkInfo.factor += 0.35
	func onHurt(atkInfo:AtkInfo):	
		if tcha.att.hp / tcha.att.maxHp <= 0.5:
			atkInfo.hurtVal *= 0.65

#----------------------------------------------044 改良声呐---------------------------------------------
class Skill_044 extends Skill:
	func _init():
		._init()
		text = "受到攻击后，赋予攻击者1层<暴露>"
	func setItem(item):
		.setItem(item)
		makeConnect("onHurt", tcha, "onHurt")
	func onHurt(atkInfo:AtkInfo):	
		if atkInfo.atkCha.team != tcha.team:
			buffUtil.addBaoLu(atkInfo.atkCha, 1)

#----------------------------------------------045 燃烧弹---------------------------------------------
class Skill_045 extends Skill:
	func _init():
		._init()
		text = "造成技能伤害时，降低目标60%的承疗效果，持续4秒，该效果无法被驱散但对塞壬效果减半，无法叠加"
	func setItem(item):
		.setItem(item)
		makeConnect("onAtkChara", tcha, "onAtkChara")
	func onAtkChara(atkInfo:AtkInfo):	
		if atkInfo.atkType == Chara.AtkType.SKILL and atkInfo.hitCha.hasBuff("b_heAmmo") == null:
			atkInfo.hitCha.addBuff(buffUtil.b_heAmmo.new())

#----------------------------------------------046 高能磁铁---------------------------------------------
class Skill_046 extends Skill:
	func _init():
		._init()
		text = "每4秒，将周围3格的敌人向自身吸附，并赋予其1秒眩晕"
	func setItem(item):
		.setItem(item)
		makeConnect("upS", tcha, "upS")
	var index = 0
	func upS():
		index += 1
		if index >= 4 and not tcha.isDeath:
			index = 0
			var inCells = []
			for i in utils.getAllCells(2):
				if tcha.cellRan(tcha.cell, i) <= 3:
					inCells.append(i)
			inCells.sort_custom(self, "sort")
			for i in tcha.getCellChas(tcha.cell, 3, 1):
				for j in inCells:
					if tcha.matCha(j) == null:
						i.setCell(j)
						i.addBuff(buffUtil.b_xuanYun.new(1))
						break	
	func sort(a, b):
		return tcha.cellRan(a, tcha.cell) < tcha.cellRan(b, tcha.cell)

#----------------------------------------------047 结晶化热强钢---------------------------------------------
class Skill_047 extends Skill:
	func _init():
		._init()
		text = "护甲值可以额外减免技能伤害，最多抵消80%伤害"
	func setItem(item):
		.setItem(item)
		makeConnect("onHurt", tcha, "onHurt")
	func onHurt(atkInfo:AtkInfo):	
		var diff = atkInfo.hurtVal * 0.8 - tcha.att.def
		if diff > 0:
			atkInfo.hurtVal = diff
		else:
			atkInfo.hurtVal *= 0.2




#----------------------------------------------200 EMP---------------------------------------------
class Skill_200 extends Skill:
	func _init():
		._init()
		text = "下回合开始时，使敌方所有角色损失2件装备，对塞壬效果减半\n一次性消耗品，拖到小卖部上即可生效"
	func setItem(item):
		.setItem(item)
		makeConnect("onBattleStart", sys.main, "onBattleStart")
		makeConnect("onBattleEnd", sys.main, "end")
	func onBattleStart():
		for i in tcha.getAllChas(1):
			var index = i.items.size() - 1
			var num = 0
			while(index >= 0 and num < 2):
				i.delItem(i.items[index])
				index -= 1
				num += 1
				if i.get("type") == "BOSS":
					break
	func end():
		remove()