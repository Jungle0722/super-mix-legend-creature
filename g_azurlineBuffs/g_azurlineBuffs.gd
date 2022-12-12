extends Node
func _ready():
	pass
func _init():
	config.bfDir["<烧蚀>"] = "每层额外降低2%双防、承疗，最高20层，每秒减少层数，不可驱散，对塞壬效果减半"
	config.bfDir["<重创>"] = "魔抗降低50%，每秒减少层数"
	config.bfDir["<活力>"] = "每2秒恢复[施法者双攻*(层数*0.1+0.4)]的生命值，提高[层数*2%]的攻速、[层数*2%]的冷却，每秒减少层数"
	config.bfDir["「穿甲航弹」"] = "双穿提高75%，攻击提高50，每秒减少层数"
	config.bfDir["「高爆航弹」"] = "攻击提高100，普攻造成周围一格的溅射伤害，每秒减少层数"
	config.bfDir["<强化水侦>"] = "降低并反弹30%技能伤害，且延长施法者1秒的技能CD"
	config.bfDir["<燃烧号令>"] = "承疗-130%（承疗为负数将会把受治疗量转为受伤害）"
	config.bfDir["<暴露>"] = "15%易伤，叠加时每次增加5%"
	config.bfDir["<无敌>"] = "免疫任何伤害，不受弱驱散效果影响"
	config.bfDir["<狂化>"] = "提高200%攻速"
	config.bfDir["<恐惧>"] = "双速降低30%"
	config.bfDir["<涅槃>"] = "最大生命值永久提升300"
	config.bfDir["<致盲>"] = "普攻20%概率偏离，每层额外增加2%，最高20层，每秒减少层数"
	config.bfDir["<虚弱>"] = "双攻降低50%"
	config.bfDir["<自杀式袭击>"] = "攻击敌人时会自爆，对周围一格的所有敌军造成[目标最大生命值*0.65]的魔法伤害，每10点航母法强提高0.01系数"
	config.bfDir["<黑暗侵蚀>"] = "普攻对自身造成[攻击*0.5]伤害，施放技能对自身造成[法强]伤害"
	config.bfDir["狂怒"] = "提高20%攻击，每层额外增加2%，最高20层，每秒减少层数"
	config.bfDir["急速"] = "提高20%攻速，每层额外增加2%，最高20层，每秒减少层数"
	config.bfDir["流血"] = "额外受到20%伤害，每层额外增加2%，最高20层，每秒减少层数"
	config.bfDir["抵御"] = "提高20%护甲，每层额外增加2%，最高20层，每秒减少层数"
	config.bfDir["魔御"] = "提高20%魔抗，每层额外增加2%，最高20层，每秒减少层数"
	config.bfDir["灼烧"] = "每秒受到2%血上限的真实伤害，每层额外提高0.2%，最高20层，每秒减少层数"
	config.bfDir["中毒"] = "降低10%承疗双抗，每层额外降低1%，最高20层，每秒减少层数"
	config.bfDir["<霜冻>"] = "降低该角色[10+层数*2]%的攻速、技能冷却速度，最高20层，每秒递减，效果期间会自动将[结霜]转化为[霜冻]，对塞壬效果减半"
	config.bfDir["<破甲>"] = "每层降低10点双抗,每秒减少层数"
	config.bfDir["<PowerUp>"] = "提高自身75%伤害，30%减伤（乘算）"
	config.bfDir["<掠夺>"] = "移除目标身上的装备，将其全部属性加成到自己身上，仅本回合有效，回合结束有5%概率获得这些装备"
	config.bfDir["<穿甲弹>"] = "对敌人身后2格的目标造成100%的伤害，并附带5层<破甲>"
	config.bfDir["<高爆弹>"] = "附带10层<烧蚀><灼烧>"
	config.bfDir["<高爆穿甲弹>"] = "对敌人身后2格的目标造成100%的伤害，并附带5层<破甲>，10层<烧蚀><灼烧>"
	config.bfDir["<魔力>"] = "提高20%法强，每层额外增加2%，最高20层，每秒减少层数"
	config.bfDir["<限定>"] = "本回合内仅触发一次"
	config.bfDir["<固化>"] = "不受技能冷却效果影响，也无法受到技能复制机制影响"
	config.bfDir["<唯一>"] = "无法叠加"
	config.bfDir["<沉睡>"] = "无法行动，沉睡1秒后受到攻击则解除"
	config.bfDir["<先手>"] = "开局会施放一次"
	config.bfDir["<强袭号令>"] = "受到伤害提高30%，被击杀获得8金币，每秒减少层数"
	config.bfDir["<威胁最大>"] = "物攻魔攻之和最高"
	config.bfDir["<漏水>"] = "每秒损失[2%+双攻*层数*0.0005%]的血量，最高20层，每秒减少层数。若有多个角色同时施加漏水，则伤害按照双攻最高角色来计算"
	config.bfDir["<圣盾>"] = "免疫一次普攻伤害，最多12层"
	config.bfDir["<亡语>"] = "该技能类型为亡语，会受到相关效果的影响，装备亡语效果只有50%概率会被第三者触发(如伊吹的回响等等)"
	config.bfDir["<舰载机>"] = "受航母属性加成，继承航母的所有装备及装备属性(某些有开局触发机制的装备无法继承该机制，例如投影仪、双联381mm主炮等等)"
	config.bfDir["<坚守>"] = "提高20%双防，每层额外增加2%，最高20层，每秒减少层数"
	config.bfDir["<强攻>"] = "提高20%双攻，每层额外增加2%，最高20层，每秒减少层数"
	config.bfDir["<速攻>"] = "提高20%攻击、攻速，每层额外增加2%，最高20层，每秒减少层数"
	config.bfDir["<剧毒>"] = "普攻对自身造成[施法者双攻*层数*0.04]伤害，施放技能对自身造成普攻的双倍伤害，最高20层，每秒减少层数"
	config.bfDir["<心神合一>"] = "普攻有50%概率对目标一列的所有敌人发起一次普攻，只能被强驱散效果驱散"
	config.bfDir["眩晕"] = "无法移动、攻击、施放技能，但技能CD会照常冷却，对塞壬效果减半"
	config.bfDir["<模糊>"] = "在场上有队友存活时，无法被敌人锁定为攻击目标，但也会受到溅射或强制指定目标的伤害"
	config.bfDir["潜行"] = "获得<模糊>效果，下次发动普攻时，造成3倍伤害，并失去潜行效果"
	config.bfDir["<反击>"] = "对攻击者立即发起一次普通攻击"
	config.bfDir["<振奋>"] = "提高20%攻击、法强、魔抗、护甲，每层额外增加2%，最高20层，每秒减少层数"
	config.bfDir["<激愤>"] = "提高20%攻击、法强、魔抗、护甲、攻速、冷却速度、暴击，每层额外增加2%，最高20层，每秒减少层数"
	config.bfDir["<沉默>"] = "无法施放技能"

	config.bfDir["<低强度>"] = "能被所有驱散效果驱散"
	config.bfDir["<中强度>"] = "只能被强驱散效果驱散"
	config.bfDir["<高强度>"] = "无法被任何驱散效果驱散"

	config.bfDir["弱驱散"] = "可以驱散低强度BUFF，如狂怒、急速等等"
	config.bfDir["强驱散"] = "可以驱散除高强度之外的所有BUFF，如无敌、圣盾等等"

	config.bfDir["<死战>"] = "效果期间免疫死亡，100%反击(视为普攻)，造成的伤害提高50%"
	config.bfDir["<退化>"] = "变为低一级的随机单位，并失去含部分难度加成在内的所有增益"

	config.bfDir["<狂暴>"] = "提高20%暴击伤害，每层额外增加4%，最高20层，每秒减少层数"
	config.bfDir["<瘫痪>"] = "四维降低50%"
	config.bfDir["神圣伤害"] = "无视护甲、魔抗与所有减伤，对塞壬造成的伤害不能超过其血上限10%"
	config.bfDir["<龙卷风>"] = "每秒对正中心的敌人造成[攻击*0.8]的真实伤害并赋予1秒<眩晕>，对周围两格的敌人造成[攻击*0.8]的魔法伤害"
	config.bfDir["<无光之盾>"] = "血量低于50%时触发，8秒内吸收所有伤害，效果结束后，10秒内每秒受到吸收伤害的12%的伤害"
	config.bfDir["彻底死亡时"] = "该角色真正阵亡，即不触发任何复活机制的死亡，也不能被亡语技能触发"
	config.bfDir["<放逐>"] = "无法造成任何伤害"
	call_deferred("azurlineInit")

func _connect():
	pass
var relic
func azurlineInit():
	relic = globalData.infoDs["g_azurlineRelic"]

#随机Debuff
var debuffs = [b_shaoShi, b_xuanYun, b_freeze, b_weak, b_blindness, b_darkErode, b_liuXue_r, b_paralysis, b_louShui]
func addRndDebuff(cha, target, num):
	var bf = sys.rndListItem(debuffs)
	if bf == b_louShui:
		addLouShui(target, cha, num)
	elif bf == b_juDu:
		addJuDu(target, cha, num)
	else:
		target.addBuff(bf.new(num))

#随机Buff
var buffs = [b_kuangNu_r, b_jiSu_r, b_moYu_r, b_diYu_r, b_ywd]
func getRndBuff():
	return sys.rndListItem(buffs)
#添加活力BUFF
func addHuoLi(target, caster, lv):
	var buff = target.hasBuff("b_huoLi")
	if buff == null:
		target.addBuff(b_huoLi.new(lv, caster))
	elif caster.att.atk+caster.att.mgiAtk > buff.cha.att.atk + buff.cha.att.mgiAtk:
		buff.cha = caster
		buff.life += lv
	else:
		buff.life += lv

#添加漏水BUFF
func addLouShui(target, caster, lv):
	var buff = target.hasBuff("b_louShui")
	if buff == null:
		target.addBuff(b_louShui.new(lv, caster))
	elif caster.att.atk+caster.att.mgiAtk > buff.cha.att.atk+buff.cha.att.mgiAtk:
		buff.cha = caster
		buff.life += lv
	else:
		buff.life += lv

#添加剧毒BUFF
func addJuDu(target, caster, lv):
	var buff = target.hasBuff("b_juDu")
	if buff == null:
		target.addBuff(b_juDu.new(lv, caster))
	elif caster.att.atk+caster.att.mgiAtk > buff.cha.att.atk+buff.cha.att.mgiAtk:
		buff.cha = caster
		buff.life += lv
	else:
		buff.life += lv

#添加圣盾
func addShengDun(target, lv):
	var buff = target.hasBuff("b_shengDun")
	if buff == null:
		target.addBuff(b_shengDun.new(lv))
	elif buff.num < 10:
		buff.num += (lv)
#添加暴露
func addBaoLu(target, lv):
	var buff = target.hasBuff("b_expose")
	if buff == null:
		target.addBuff(b_expose.new(lv))
	else:
		buff.reset(lv)

#添加黯灭破甲BUFF
func addAnMie(target, lv):
	var buff = target.hasBuff("b_Dt_DefenseReduce")
	if buff == null:
		target.addBuff(b_Dt_DefenseReduce.new(lv))
	else:
		buff.reset(lv)
#-----------------------------------------------------------------------BUFF--------------------------------------------------------------------------
#重创,魔抗降低50%
class b_zhongChang:
	extends Buff
	var buffName = "重创"
	func _init(num = 0):
		attInit()
		id = "b_zhongChang"	
		isNegetive = true
		att.mgiDefL = -0.5     
		if num > 0:
			life = num   
#烧蚀
class b_shaoShi:
	extends Buff
	var buffName = "烧蚀"
	var cha
	var relic = globalData.infoDs.get("g_azurlineRelic")
	func _init(lv = 1, cha = null):
		attInit()
		id = "b_shaoShi"	
		isNegetive = true
		life = lv
		self.cha = cha
	func _upS():
		life = min(20, life)
		var p1 = 1
		if masCha.get("type") == "BOSS":p1 = 0.5
		att.reHp = -(0.02 * life) * pw * p1
		att.defL = -(0.02 * life) * pw * p1
		att.mgiDefL = -(0.02 * life) * pw * p1
		if relic.betterShaoShi:
			att.atkL = -(0.02 * life) * pw * p1

#彩虹 闪避+50%
class b_caiHong:
	extends Buff
	var buffName = "彩虹"
	func _init(lv = 1):
		attInit()
		id = "b_caiHong"	
		att.dod = 0.5
		life = lv

#必定命中
class b_biZhong:
	extends Buff
	var buffName = "必定命中"
	func _init():
		attInit()
		id = "b_biZhong"
	func _connect():
		masCha.connect("onAtkChara",self,"run")
	func run(atkInfo):
		if atkInfo.atkType == Chara.AtkType.MISS || atkInfo.isMiss:
			atkInfo.isMiss = false
			atkInfo.atkType = Chara.AtkType.NORMAL
			
#樱绽凤华 无敌
class b_yzfh:
	extends Buff
	var buffName = "无敌"
	func _init(lv = 1):
		attInit()
		id = "b_yzfh"
		life = lv
	func _connect():
		masCha.connect("onHurt", self, "onHurt")
	func onHurt(atkInfo:AtkInfo):
		if atkInfo.hurtVal > 0 && not atkInfo.isMiss:
			atkInfo.hurtVal = 0

#眩晕
class b_xuanYun:
	extends Buff
	var buffName = "眩晕"
	func _init(lv = 1):
		attInit()
		id = "b_xuanYun"
		life = lv
		isNegetive=true
	var eff2
	var utils = globalData.infoDs["g_azurlineUtils"]
	func _connect():
		._connect()
		masCha.aiOn = false
		if masCha.get("type") == "BOSS":
			life /= 2
		eff2 = sys.newEff("animEff", masCha.position)
		eff2.setImgs(utils.path + "/eff/yunXuan", 5, true)
		eff2.scale *= 1
		eff2.normalSpr.position=Vector2(0, -70)
	func _del():
		._del()
		masCha.aiOn = true
		if is_instance_valid(eff2):
			eff2.queue_free()
	func _process(delta):
		if masCha != null && is_instance_valid(eff2):
			eff2.position = masCha.position
	func _upS():
		life = min(15, life)

#霜冻 降低该角色[10+层数*4]%的攻速、技能冷却速度，最高20层，每秒递减，效果期间会自动将[结霜]转化为[霜冻]
class b_freeze:
	extends Buff
	var buffName = "霜冻"
	var relic = globalData.infoDs.get("g_azurlineRelic")
	func _init(lv = 1):
		attInit()
		id = "b_freeze"	
		isNegetive = true
		life = lv
	func _upS():
		var jieShuang = masCha.hasBuff("b_jieShuang")
		if jieShuang != null:
			jieShuang.isDel = true
			life += jieShuang.life
		life = min(20, life)
		var addi = 1
		if masCha.get("type") == "BOSS":
			addi = 0.5
		att.spd = -(0.1+0.02*life*pw*addi)
		att.cd = -(0.1+0.02*life*pw*addi)
		if relic.betterFreeze:
			att.mgiAtkL = -(0.1+0.02*life*pw*addi)
#冻结
class b_dongJie:
	extends Buff
	var buffName = "冻结"
	func _init():
		attInit()
		id = "b_dongJie"	
		isNegetive = true
	func _upS():
		masCha.aiOn = false

	func _connect():
		._connect()
		masCha.aiOn = false
		
	func _del():
		._del()
		masCha.aiOn = true

#破甲
class b_perforation:
	extends Buff
	var buffName = "破甲"
	var cha
	func _init(lv = 1, cha = null):
		attInit()
		id = "b_perforation"	
		isNegetive = true
		life = lv
		self.cha = cha

	func _upS():
		att.def = -10 * life
		att.mgiDef = -10 * life
#重点支援
class b_zdzy:
	extends Buff
	var buffName = "重点支援"
	var num
	func _init(num = 0):
		attInit()
		self.num = num
		life = 4
		att.def = 150
		att.mgiDef = 150
		id = "b_zdzy"
	func _connect():
		masCha.connect("onHurt",self,"_onHurt")
	func _onHurt(atkInfo:AtkInfo):
		if atkInfo.atkType == Chara.AtkType.NORMAL:
			count += 1
	var count = 0
	func _upS():
		if count > 0:
			masCha.plusHp(num * count)
			count = 0
#活力
class b_huoLi:
	extends Buff
	var buffName = "活力"
	var cha = null
	var dispel = 2
	func _init(lv = 1, cha = null):
		attInit()
		id = "b_huoLi"
		life = lv
		self.cha = cha	
	var index = 0
	func _upS():
		if cha == null:return
		life = min(20, life)
		att.spd = 0.02 * life * pw
		att.cd = 0.02 * life * pw
		index += 1
		if index >= 2:
			index = 0
			cha.healCha(masCha, (cha.att.mgiAtk+cha.att.atk)*(life*0.1 + 0.4) * pw)

#无敌
class b_wudi:
	extends Buff
	var buffName = "无敌"
	var dispel = 2
	func _init(lv = 1):
		attInit()
		life = lv
		id = "b_wudi"
	func _connect():
		masCha.connect("onHurt",self,"_onHurt")
	func _onHurt(atkInfo:AtkInfo):
		if atkInfo.hurtVal > 0 && not atkInfo.isMiss:
			atkInfo.hurtVal = 0
	func _upS():
		life = min(10, life)

#变更承伤（乘算）
class b_hurtVal:
	extends Buff
	var buffName = "变更承伤率（乘算）"
	var dispel = 1
	var num = 1
	func _init(num = 1, duration = 0, disp = false):
		attInit()
		id = "b_hurtVal"
		self.num = num
		if num > 1:
			isNegetive = true
		if duration > 0:
			life = duration
		else:
			id += "_p"
		if disp:
			id += "_d"
			if disp:
				self.dispel = 2
	func _connect():
		masCha.connect("onHurt",self,"_onHurt")
	func _onHurt(atkInfo:AtkInfo):
		if atkInfo.hurtVal > 0 && not atkInfo.isMiss:
			atkInfo.hurtVal *= num

#承疗
class b_reHp:
	extends Buff
	var buffName = "承疗"
	var cha
	func _init(num = 1.0, cha = null, duration = 0):
		attInit()
		id = "b_reHp"	
		self.cha = cha
		if num < 0:
			isNegetive = true
		att.reHp = 0.1 * num
		if duration > 0:
			life = duration
		else:
			id += "_p"
#最强之盾
class b_NP_zqzd:
	extends Buff
	var buffName = "最强之盾"
	var castCha = null
	var exclude = ["zqzd", "snowWind", "luoYingShenfu"]
	func _init(cast = null):
		attInit()
		id = "b_NP_zqzd"
		castCha = cast
	func _connect():
		masCha.connect("onHurt",self,"_onHurt")
	func _onHurt(atkInfo:AtkInfo):
		for i in masCha.skills:
			if exclude.has(i.id):
				return
		if atkInfo.hurtVal > 0 && not atkInfo.isMiss && atkInfo.atkType != Chara.AtkType.EFF && not castCha.isDeath:
			castCha.storage += atkInfo.hurtVal*0.4
			atkInfo.hurtVal *= 0.6
#武勋-Debuff
class b_wx_sub:
	extends Buff
	var buffName = "武勋-负面"
	func _init(p = -0.25):
		attInit()
		id = "b_wx_sub"		
		isNegetive = true
		att.atkL = -p
		att.mgiAtkL = -p
		att.defL = -p
		att.mgiDefL = -p
#弹弹乐
class b_tantanle:
	extends Buff
	var buffName = "弹弹乐"
	var num = 1
	var maxNum = 4
	var utils = globalData.infoDs["g_azurlineUtils"]
	func _init(num = 1, maxNum = 4):
		attInit()
		id = "b_tantanle"
		life = 2
		self.num = num
		self.maxNum = maxNum
		isNegetive=true
	func _connect():
		._connect()
		masCha.aiOn = false
		eff2 = sys.newEff("animEff", masCha.position)
		eff2.setImgs(utils.path + "/eff/yunXuan", 5, true)
		eff2.scale *= 1
		eff2.normalSpr.position=Vector2(0, -70)
	var eff2
	func _process(delta):
		if masCha != null && is_instance_valid(eff2):
			eff2.position = masCha.position
	func _del():
		._del()
		if is_instance_valid(eff2):
			eff2.queue_free()
		masCha.aiOn = true
		if num >= maxNum:
			return
		var chas = masCha.getCellChas(masCha.cell,2,2)
		if chas == null || chas.size() == 0:
			return
		chas.shuffle()
		var t
		for i in chas:
			if i != masCha && not i.isDeath && not i.hasBuff("b_tantanle"):
				t = i
		if t != null:
			var d:Eff = masCha.newEff("sk_4_1_2",masCha.sprcPos)
			d._initFlyCha(t)
			yield(d,"onReach")
			t.addBuff(b_tantanle.new(num + 1))

#烟雾弹
class b_ywd:
	extends Buff
	var buffName = "烟雾弹"
	func _init(lv = 1):
		attInit()
		id = "b_ywd"
		life = lv
		att.dod = 0.4
		att.reHp = 0.3
#魔攻百分比
class b_mgiAtkL:
	extends Buff
	var buffName = "魔攻百分比"
	func _init(num = 1.0, duration = 0):
		attInit()
		id = "b_mgiAtkL"	
		if num < 0:
			isNegetive = true
		att.mgiAtkL = 0.1 * num
		if duration > 0:
			life = duration
		else:
			id += "_p"
#物攻百分比
class b_atkL:
	extends Buff
	var buffName = "物攻百分比"
	func _init(num = 1.0, duration = 0):
		attInit()
		id = "b_atkL"	
		if num < 0:
			isNegetive = true
		att.atkL = 0.1 * num
		if duration > 0:
			life = duration
		else:
			id += "_p"
			
#闪避
class b_dod:
	extends Buff
	var buffName = "闪避"
	func _init(num = 1.0, duration = 0):
		attInit()
		id = "b_dod"	
		if num < 0:
			isNegetive = true
		att.dod = 0.1 * num
		if duration > 0:
			life = duration
		else:
			id += "_p"

#漏水  每秒损失[血上限*层数*0.0005%]的血量，每秒减少层数
class b_louShui:
	extends Buff
	var buffName = "漏水"
	var cha
	var dispel = 1
	var relic = globalData.infoDs.get("g_azurlineRelic")
	func _init(lv = 1, cha = null):
		attInit()
		id = "b_louShui"
		life = lv
		self.cha = cha
		isNegetive = true
	func _upS():
		life = min(20, life)
		doDmg()
		if relic.louShuiRelic and masCha.team == 2:
			cha.azurHurtChara(masCha, min(40000, masCha.att.maxHp*0.05), Chara.HurtType.REAL, Chara.AtkType.EFF, "水鬼")

	func allDmg():
		doDmg(life)
		isDel = true
	func doDmg(times = 1):
		var rate = min(0.12, 0.000005 * (cha.att.mgiAtk+cha.att.atk) * life + 0.02) * pw
		var dmg = min(40000, masCha.att.maxHp) * rate * times
		if masCha.team == 1:
			dmg = min(masCha.att.maxHp * 0.05, dmg)
		cha.azurHurtChara(masCha, dmg, Chara.HurtType.REAL, Chara.AtkType.EFF, "漏水")
		

#虚弱，减少双攻
class b_weak:
	extends Buff
	var buffName = "虚弱"
	func _init(lv = 1):
		attInit()
		id = "b_weak"
		life = lv
		isNegetive = true
		att.atkL = -0.5
		att.mgiAtkL = -0.5
#嘲讽
class b_taunt:
	extends Buff
	var buffName = "被嘲讽"
	var tcha
	func _init(lv = 1, tcha = null):
		life = lv
		isNegetive = true
		self.tcha = tcha
		id = "b_taunt"
	func _del():
		masCha.aiCha = null
		._del()
	func _upS():
		life = min(20, life)
		if tcha.isDeath:
			life = 0
		elif masCha.aiCha != tcha:
			masCha.aiCha = tcha
#反击
class b_counterattack:
	extends Buff
	var buffName = "反击"
	#反击概率，不可太高，减少套娃
	var r = 30
	var dispel = 2
	func _init(lv = 1, r = 30):
		attInit()
		id = "b_counterattack"
		life = lv
		self.r = r
	func _connect():
		._connect()
		masCha.connect("onHurt", self, "onHurt")
	func onHurt(atkInfo:AtkInfo):
		if atkInfo.atkType != Chara.AtkType.EFF && sys.rndPer(r) && atkInfo.atkCha.hasBuff("b_counterattack") == null and atkInfo.atkCha.team != masCha.team:
			masCha.normalAtkChara(atkInfo.atkCha)
	var num = 0
	func _upS():
		num = 0
#致盲
class b_blindness:
	extends Buff
	var buffName = "致盲"
	func _init(lv = 1):
		attInit()
		id = "b_blindness"
		life = lv
		isNegetive = true
	func _connect():
		masCha.connect("onAtkChara",self,"_onAtkChara")
	func _onAtkChara(atkInfo:AtkInfo):
		if atkInfo.atkType == Chara.AtkType.NORMAL && sys.rndPer((20 + life * 2)*pw):
			atkInfo.isMiss = true
			atkInfo.atkType = Chara.AtkType.MISS

#放逐
class b_fangZhu:
	extends Buff
	var buffName = "放逐"
	func _init(lv = 1):
		attInit()
		id = "b_fangZhu"
		life = lv
		isNegetive = true
	func _connect():
		masCha.connect("onAtkChara",self,"_onAtkChara")
	func _onAtkChara(atkInfo:AtkInfo):
		atkInfo.hurtVal = 0			

#暴露
class b_expose:
	extends Buff
	var buffName = "暴露"
	var p1 = 0
	var p2 = 1
	func reset(num):
		p1 += num
		p2 = 1 + (p1 * 0.1)
	func _init(num = 1):
		attInit()
		id = "b_expose"
		reset(num)
		isNegetive = true
	func _connect():
		masCha.connect("onHurt",self,"onHurt")
	func onHurt(atkInfo:AtkInfo):
		if atkInfo.hurtVal > 0:
			atkInfo.hurtVal *= p2

#攻速
class b_spd:
	extends Buff
	var buffName = "攻速"
	func _init(num = 1.0, duration = 0):
		attInit()
		id = "b_spd"	
		if num < 0:
			isNegetive = true
		att.spd = 0.1 * num
		if duration > 0:
			life = duration
			lv = duration
		else:
			id += "_p"

#冷却
class b_cd:
	extends Buff
	var buffName = "冷却速度"
	func _init(num = 1.0, duration = 0):
		attInit()
		id = "b_cd"	
		if num < 0:
			isNegetive = true
		att.cd = 0.1 * num
		if duration > 0:
			life = duration
			lv = duration
		else:
			id += "_p"
#暴击
class b_cri:
	extends Buff
	var buffName = "暴击"
	func _init(num = 1.0, duration = 0):
		attInit()
		id = "b_cri"	
		if num < 0:
			isNegetive = true
		att.cri = 0.1 * num
		if duration > 0:
			life = duration
			lv = duration
		else:
			id += "_p"

#双防
class b_twoDefL:
	extends Buff
	var buffName = "双防"
	func _init(num = 1.0, duration = 0):
		attInit()
		id = "b_twoDefL"	
		if num < 0:
			isNegetive = true
		att.defL = 0.1 * num
		att.mgiDefL = 0.1 * num
		if duration > 0:
			life = duration
			lv = duration
		else:
			id += "_p"
			
#护甲
class b_defL:
	extends Buff
	var buffName = "护甲"
	func _init(num = 1.0, duration = 0):
		attInit()
		id = "b_defL"	
		if num < 0:
			isNegetive = true
		att.defL = 0.1 * num
		if duration > 0:
			life = duration
			lv = duration
		else:
			id += "_p"
#固定护甲
class b_def:
	extends Buff
	var buffName = "固定护甲"
	func _init(num = 1.0, duration = 0):
		attInit()
		id = "b_def"	
		if num < 0:
			isNegetive = true
		att.def = num
		if duration > 0:
			life = duration
			lv = duration
		else:
			id += "_p"

#双攻
class b_twoAtkL:
	extends Buff
	var buffName = "双攻"
	var dispel = 1
	func _init(num = 1.0, duration = 0, dispelable = true):
		attInit()
		id = "b_twoAtkL"	
		if num < 0:
			isNegetive = true
		att.atkL = 0.1 * num
		att.mgiAtkL = 0.1 * num
		if duration > 0:
			life = duration
			lv = duration
		else:
			id += "_p"
		if dispelable:self.dispel = 2

#双速
class b_twoSpd:
	extends Buff
	var buffName = "双速"
	func _init(num = 1.0, duration = 0):
		attInit()
		id = "b_twoSpd"	
		if num < 0:
			isNegetive = true
		att.spd = 0.1 * num
		att.cd = 0.1 * num
		if duration > 0:
			life = duration
			lv = duration
		else:
			id += "_p"

#黑暗侵蚀
class b_darkErode:
	extends Buff
	var buffName = "黑暗侵蚀"
	func _init(lv = 1):
		attInit()
		id = "b_darkErode"
		life = lv
		isNegetive = true
	func _connect():
		masCha.connect("onAtkChara",self,"_onAtkChara")
		masCha.connect("onCastCdSkill",self,"onCastCdSkill")
	func _onAtkChara(atkInfo:AtkInfo):
		if atkInfo.atkType == Chara.AtkType.NORMAL:
			masCha.azurHurtChara(masCha, masCha.att.atk*0.5, Chara.HurtType.PHY, Chara.AtkType.EFF, "黑暗侵蚀-自残")
	func onCastCdSkill(id):
		masCha.azurHurtChara(masCha, masCha.att.mgiAtk, Chara.HurtType.MGI, Chara.AtkType.EFF, "黑暗侵蚀-自残")
#剧毒
class b_juDu:
	extends Buff
	var buffName = "剧毒"
	var cha = null
	func _init(lv = 1, cha = null):
		attInit()
		id = "b_juDu"
		life = lv
		isNegetive = true
		self.cha = cha
	func _connect():
		masCha.connect("onAtkChara",self,"_onAtkChara")
		masCha.connect("onCastCdSkill",self,"onCastCdSkill")
	func _upS():
		life = min(20, life)
	func _onAtkChara(atkInfo:AtkInfo):
		if atkInfo.atkType == Chara.AtkType.NORMAL:
			if not cha.isDeath:
				cha.azurHurtChara(masCha, (cha.att.atk+cha.att.mgiAtk)*life*0.04, Chara.HurtType.PHY, Chara.AtkType.EFF, "剧毒")
			else:
				masCha.azurHurtChara(masCha, (cha.att.atk+cha.att.mgiAtk)*life*0.04, Chara.HurtType.PHY, Chara.AtkType.EFF, "剧毒-自残")
	func onCastCdSkill(id):
		if not cha.isDeath:
			cha.azurHurtChara(masCha, (cha.att.atk+cha.att.mgiAtk)*life*0.08, Chara.HurtType.MGI, Chara.AtkType.EFF, "剧毒")
		else:
			masCha.azurHurtChara(masCha, (cha.att.atk+cha.att.mgiAtk)*life*0.08, Chara.HurtType.MGI, Chara.AtkType.EFF, "剧毒-自残")
#狂怒
class b_kuangNu_r:
	extends Buff
	var buffName = "狂怒"
	func _init(lv = 1):
		attInit()
		life = lv
		id = "b_kuangNu_r"
	func _upS():
		life = min(20, life)
		att.atkL = ( 0.20 + life * 0.02 ) * pw
#狂暴
class b_kuangBao:
	extends Buff
	var buffName = "狂暴"
	func _init(lv = 1):
		attInit()
		life = lv
		id = "b_kuangBao"
	func _upS():
		life = min(20, life)
		att.criR = ( 0.20 + life * 0.04 ) * pw
#急速
class b_jiSu_r:
	extends Buff
	var buffName = "急速"
	func _init(lv = 1):
		attInit()
		life = lv
		id = "b_jiSu_r"
	func _upS():
		life = min(20, life)
		att.spd = (0.20 + life * 0.02 ) * pw
#流血
class b_liuXue_r:
	extends Buff
	var buffName = "流血"
	func _init(lv = 1):
		attInit()
		life = lv
		id = "b_liuXue_r"
		isNegetive = true
	func _connect():
		masCha.connect("onHurt",self,"onHurt")
	func onHurt(atkInfo:AtkInfo):
		if atkInfo.atkType != Chara.AtkType.EFF:
			atkInfo.hurtVal *= (1.2 + life * 0.02) * pw
			# atkInfo.atkCha.hurtChara(masCha,atkInfo.atkVal * (0.2 + life * 0.02) * pw,Chara.HurtType.PHY,Chara.AtkType.EFF)
#振奋
class b_zhenFen:
	extends Buff
	var buffName = "振奋"
	func _init(lv = 1):
		attInit()
		life = lv
		id = "b_zhenFen"
	func _upS():
		life = min(20, life)
		att.defL = (0.20 + life * 0.02) * pw
		att.mgiDefL = (0.20 + life * 0.02) * pw
		att.atkL = (0.20 + life * 0.02) * pw
		att.mgiAtkL = (0.20 + life * 0.02) * pw

#激愤
class b_jiFen:
	extends Buff
	var buffName = "激愤"
	func _init(lv = 1):
		attInit()
		life = lv
		id = "b_jiFen"
	func _upS():
		life = min(20, life)
		att.defL = (0.20 + life * 0.02) * pw
		att.mgiDefL = (0.20 + life * 0.02) * pw
		att.atkL = (0.20 + life * 0.02) * pw
		att.mgiAtkL = (0.20 + life * 0.02) * pw		
		att.spd = (0.20 + life * 0.02) * pw	
		att.cd = (0.20 + life * 0.02) * pw	
		att.cri = (0.20 + life * 0.02) * pw	

#强攻
class b_qiangGong:
	extends Buff
	var buffName = "强攻"
	func _init(lv = 1):
		attInit()
		life = lv
		id = "b_qiangGong"
	func _upS():
		life = min(20, life)
		att.atkL = (0.20 + life * 0.02) * pw
		att.mgiAtkL = (0.20 + life * 0.02) * pw

#抵御
class b_diYu_r:
	extends Buff
	var buffName = "抵御"
	func _init(lv = 1):
		attInit()
		life = lv
		id = "b_diYu_r"
	func _upS():
		life = min(20, life)
		att.defL = (0.20 + life * 0.02) * pw
#魔御
class b_moYu_r:
	extends Buff
	var buffName = "魔御"
	func _init(lv = 1):
		attInit()
		life = lv
		id = "b_moYu_r"
	func _upS():
		life = min(20, life)
		att.mgiDefL = (0.20 + life * 0.02) * pw
#烧灼
class b_shaoZhuo_r:
	extends Buff
	var buffName = "烧灼"
	func _init(lv = 1, cha = null):
		attInit()
		life = lv
		id = "b_shaoZhuo_r"
		isNegetive = true
		if cha != null:
			casCha = cha
	func _upS():
		life = min(20, life)
		casCha.azurHurtChara(masCha,masCha.att.maxHp * (0.02 + life * 0.002) * pw,Chara.HurtType.REAL,Chara.AtkType.EFF, "烧灼")
#中毒
class b_zhonDu_r:
	extends Buff
	var buffName = "中毒"
	func _init(lv = 1):
		attInit()
		life = lv
		id = "b_zhonDu_r"
		isNegetive = true
	func _upS():
		life = min(20, life)
		att.reHp = - (0.10 + life * 0.01) * pw
		att.defL = - (0.10 + life * 0.01) * pw
		att.mgiDefL = - (0.10 + life * 0.01) * pw
#反召唤物
class b_antiSumm:
	extends Buff
	var buffName = "反召唤物"
	var num = 1
	var dispel = 2
	func _init(num = 1):
		attInit()
		id = "b_antiSumm"
		self.num = 1 + 0.1*num
	func _connect():
		masCha.connect("onAtkChara",self,"_onAtkChara")
	func _onAtkChara(atkInfo:AtkInfo):
		if atkInfo.hurtVal > 0 && atkInfo.hitCha.isSumm:
			atkInfo.hurtVal *= num

#瘫痪
class b_paralysis:
	extends Buff
	var buffName = "瘫痪"
	func _init(lv = 0):
		attInit()
		id = "b_paralysis"
		if lv > 0:
			life = lv
		isNegetive = true
		att.atkL = -0.5
		att.mgiAtkL = -0.5
		att.defL = -0.5
		att.mgiDefL = -0.5
#神射手
class b_sniper:
	extends Buff
	var buffName = "射程"
	var dispel = 2
	func _init():
		attInit()
		att.atkRan = 15		
		id = "b_sniper"	

#增伤
class b_atkR:
	extends Buff
	var buffName = "百分比增伤"
	var dispel = 1
	func _init(num = 1.0, duration = 0, dispelable = true):
		attInit()
		id = "b_atkR"	
		if num < 0:
			isNegetive = true
		att.atkR = 0.1 * num
		noLife = true
		life = duration
		if duration > 0:
			noLife = false
			lv = duration
		else:
			id += "_p"
		if dispelable: self.dispel = 2
#难度增伤
class b_atkR_diff:
	extends Buff
	var dispel = 2
	func _init(num = 1.0):
		attInit()
		id = "b_atkR_diff"	
		att.atkR = 0.1 * num
		att.reHp = -0.1
	
#减伤
class b_defR:
	extends Buff
	var buffName = "减伤"
	func _init(num = 1.0, duration = 0):
		attInit()
		id = "b_atkR"	
		if num < 0:
			isNegetive = true
		att.defR = 0.1 * num
		noLife = true
		life = duration
		if duration > 0:
			noLife = false
			lv = duration
		else:
			id += "_p"
#法穿
class b_mgiPenL:
	extends Buff
	var buffName = "法穿"
	func _init(num = 1.0, duration = 0):
		attInit()
		id = "b_mgiPenL"	
		if num < 0:
			isNegetive = true
		att.mgiPenL = 0.1 * num
		noLife = true
		life = duration
		if duration > 0:
			noLife = false
			lv = duration
		else:
			id += "_p"

#双穿
class b_twoPenL:
	extends Buff
	var buffName = "双穿"
	func _init(num = 1.0, duration = 0):
		attInit()
		id = "b_twoPenL"	
		if num < 0:
			isNegetive = true
		att.mgiPenL = 0.1 * num
		att.penL = 0.1 * num
		noLife = true
		life = duration
		if duration > 0:
			noLife = false
			lv = duration
		else:
			id += "_p"

#双吸
class b_twoSuck:
	extends Buff
	var buffName = "双吸"
	func _init(num = 1.0, duration = 0):
		attInit()
		id = "b_twoSuck"	
		if num < 0:
			isNegetive = true
		att.suck = 0.1 * num
		att.mgiSuck = 0.1 * num
		noLife = true
		life = duration
		if duration > 0:
			noLife = false
			lv = duration
		else:
			id += "_p"

#魔力
class b_moLi:
	extends Buff
	var buffName = "魔力"
	func _init(lv = 1):
		attInit()
		life = lv
		id = "b_moLi"
	func _upS():
		life = min(20, life)
		att.mgiAtkL = ( 0.20 + life * 0.02 ) * pw

#圣盾
class b_shengDun:
	extends Buff
	var buffName = "圣盾"
	var eff2
	var num = 0
	var azurCtrl = globalData.infoDs["g_azurline"]
	var buffUtil = globalData.infoDs["g_azurlineBuffs"]
	var dispel = 2
	func _init(num = 1):
		attInit()
		id = "b_shengDun"
		self.num = num
	func _connect():
		masCha.connect("onHurt", self, "onHurt")
		eff2 = sys.newEff("animEff", masCha.position)
		eff2.setImgs(masCha.utils.path + "/eff/shengDun", 5, true)
		eff2.scale *= 0.9
		eff2.normalSpr.position=Vector2(0, -50)
	func onHurt(atkInfo:AtkInfo):
		if atkInfo.hurtVal > 0 && not atkInfo.isMiss and num > 0 and (atkInfo.atkType == Chara.AtkType.NORMAL or atkInfo.atkType == Chara.AtkType.SKILL and azurCtrl.holyShieldRein and masCha.team == 1):
			atkInfo.hurtVal = 0
			num -= 1
			# if azurCtrl.holyShieldRein and sys.rndPer(20):
			# 	num += 1
			if masCha.has_method("afterShengDun"):
				masCha.afterShengDun(atkInfo.atkCha)
			if azurCtrl.holyShield and masCha.team == 1:
				masCha.addBuff(buffUtil.b_kuangNu_r.new(2))
				masCha.addBuff(buffUtil.b_jiSu_r.new(2))
				buffUtil.addHuoLi(masCha, masCha, 2)

		if num <= 0:
			isDel = true
	func _process(delta):
		if masCha != null && is_instance_valid(eff2):
			eff2.position = masCha.position
	func _del():
		._del()
		if is_instance_valid(eff2):
			eff2.queue_free()
	func _upS():
		num = min(40, num)		
#模糊
class b_vague:
	extends Buff
	var buffName = "模糊"
	func _init(lv = 1):
		attInit()
		life = lv
		id = "b_vague"
#百分比血上限
class b_maxHpL:
	extends Buff
	var buffName = "百分比血上限"
	var dispel = 1
	func _init(num = 1.0, duration = 0, dispelable = true):
		attInit()
		id = "b_maxHpL"	
		if num < 0:
			isNegetive = true
		att.maxHpL = 0.1 * num
		if duration > 0:
			life = duration
			lv = duration
		else:
			id += "_p"
		if dispelable: self.dispel = 2
#血上限
class b_maxHp:
	extends Buff
	var buffName = "血上限"
	var dispel = 1
	func _init(num = 1.0, duration = 0, dispelable = true):
		attInit()
		id = "b_maxHp"	
		if num < 0:
			isNegetive = true
		att.maxHp = num
		if duration > 0:
			life = duration
			lv = duration
		else:
			id += "_p"
		if dispelable: self.dispel = 2

#潜艇羁绊
class b_jb_ss:
	extends Buff
	var buffName = "潜艇羁绊"
	var dispel = 2
	func _init(num = 1):
		attInit()
		att.cd = 0.2 * num
		att.mgiPenL = 0.2 * num

#无限复活
class b_al_revive:
	extends Buff
	var buffName = "无限复活"
	var dispel = 2
	func _init(lv):
		attInit()
		id = "b_al_revive"
		life = lv

	func _connect():
		masCha.connect("onDeath",self,"_onDeath")

	func _onDeath(atkInfo):
		masCha.isDeath = false
		masCha.plusHp(masCha.att.maxHp)

#免疫负面效果
class b_mianYi:
	extends Buff
	var buffName = "免疫负面效果"
	var dispel = 2
	func _init(lv = 1):
		attInit()
		id = "b_mianYi"
		life = lv
	func _connect():
		masCha.connect("onAddBuff",self,"onAddBuff")
	func onAddBuff(buff):
		if buff.isNegetive:
			buff.isDel = true

#物理免疫
class b_mianYi_phy:
	extends Buff
	var buffName = "物理免疫"
	var dispel = 2
	func _init(lv = 1):
		attInit()
		id = "b_mianYi_atk"
		life = lv
	func _connect():
		masCha.connect("onHurt", self, "onHurt")
	func onHurt(atkInfo:AtkInfo):
		if atkInfo.hurtType == Chara.HurtType.PHY:
			atkInfo.hurtVal = 0

#魔法免疫
class b_mianYi_mgi:
	extends Buff
	var buffName = "魔法免疫"
	var dispel = 2
	func _init(lv = 1):
		attInit()
		id = "b_mianYi_mgi"
		life = lv
	func _connect():
		masCha.connect("onHurt", self, "onHurt")
	func onHurt(atkInfo:AtkInfo):
		if atkInfo.hurtType == Chara.HurtType.MGI:
			atkInfo.hurtVal = 0

#无光之盾 - 扣血
class b_nagisa2:
	extends Buff
	var dispel = 2
	var num
	func _init(num):
		attInit()
		life = 10
		id = "b_nagisa2"
		isNegetive = true
		self.num = num
	func _upS():
		masCha.hurtChara(masCha, num*0.12, Chara.HurtType.REAL, Chara.AtkType.EFF)
		
#天之骑士，受到致命伤害时，恢复20%血量，改由我方舰载机承担，并消耗一层该效果
class b_independence:
	extends Buff
	var buffName = "天之骑士"
	var dispel = 2
	var utils = globalData.infoDs["g_azurlineUtils"]
	var num = 0
	var cha = null
	func _init(num = 0, cha = null):
		attInit()
		id = "b_independence"
		self.num = num
		self.cha = cha
	func _connect():
		masCha.connect("onHurt", self, "onHurt")
	func onHurt(atkInfo:AtkInfo):
		if atkInfo.hurtVal > 0 and atkInfo.hurtVal*1.2 >= masCha.att.hp and masCha.hasBuff("b_wudi") == null:
			for i in masCha.getAllChas(2):
				if i.get("type") == "plane":
					atkInfo.atkCha.azurHurtChara(i, atkInfo.atkVal, atkInfo.hurtType, atkInfo.atkType, atkInfo.get("skill"))
					atkInfo.hurtVal = 0
					num -= 1
					cha.healCha(masCha, masCha.att.maxHp * 0.2)
					break
			if num <= 0:
				isDel = true		
#斩杀
class b_zhanSha:
	extends Buff
	var dispel = 2
	func _init(lv = 0):
		attInit()
		id = "b_zhanSha"
		if lv > 0:
			life = lv
	func _connect():
		masCha.connect("onAtkChara",self,"run")
	func run(atkInfo):
		if atkInfo.atkType == Chara.AtkType.NORMAL && atkInfo.hitCha.att.hp/atkInfo.hitCha.att.maxHp <= 0.20:
			atkInfo.hurtVal = 0
			masCha.utils.createSkillTextEff("斩杀", masCha.position)
			if atkInfo.hitCha.get("type") == "BOSS":
				masCha.azurHurtChara(atkInfo.hitCha, atkInfo.hitCha.att.hp, Chara.HurtType.REAL, Chara.AtkType.EFF, "斩杀", true)
			else:
				atkInfo.hitCha.forceHurtSelf(atkInfo.hitCha.att.maxHp)
				masCha.increDmgNum(atkInfo.hitCha.att.hp, "斩杀", atkInfo.hitCha)
#燃烧弹
class b_heAmmo:
	extends Buff
	var buffName = "燃烧弹"
	var dispel = 2
	func _init():
		attInit()
		id = "b_heAmmo"
		life = 4
	func _connect():
		._connect()
		if masCha.get("type") == "BOSS":
			att.reHp = -0.3
		else:
			att.reHp = -0.6
#黯灭Debuff 被攻击的单位减少35%护甲，持续3秒 
class b_Dt_DefenseReduce:
	extends Buff
	var buffName = "黯灭Debuff"
	var dispel = 2
	func _init(lv=1,MasDef=0):
		attInit()
		att.def -= MasDef * 0.35
		life = 3
		id = "b_Dt_DefenseReduce"
		isNegetive=true

class b_Dt_SladeAtkSpdDefuse extends Buff:
	func _init(lv=1):
		attInit()
		att.spd -= 0.3
		effId = "p_jieShuang"
		life = 2
		id = "b_Dt_SladeAtkSpdDefuse"
		isNegetive=true
				