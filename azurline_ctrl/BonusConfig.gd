
extends Node
func _init():
	pass

func loadBuff(name, lv = 0):
	if lv > 0:
		return get(name).new(lv)
	return get(name).new()

#type:
#1 阵营属性加成
#2 舰种属性加成
#3 舰种获得BUFF
#4 阵营获得随机BUFF，已删
#5 pt点数倍率
#6 开局额外资源  2-随机稀有装备 3-随机传奇舰娘 4-PT 5-2个随机科研材料
#7 初始PT金币兑换比例降低为1.0
#8 科研任务所需条件
#9 每次进化舰娘有概率额外获得一个该舰娘
#10 我方舰娘每回合获得某个buff
#11 每回合额外获得资源  1-pt 2-金币 3-经验
#12 每回合开始时，随机对一名敌方非塞壬单位造成[目标血上限100%]的真实伤害
#13 获得的技能书必为传说品质 已删
#14 U盘无使用次数限制
#15 负面理财随机事件不会发生，正面理财随机事件发生概率翻倍
#16 三合一升级后的装备属性额外提高30%
#17 五连建造获得高级角色的概率+2%
#18 指挥官初始军衔为上尉
#19 我方舰载机经验获得速度提高100%
#20 我方舰娘获得圣盾时，额外获得1层圣盾
#21 我方舰娘获得的护盾+25%
#22 我方舰娘的亡语技能触发时，20%再次触发
#23 不能使用金币兑换PT点数 已删
#24 不能使用U盘
#25 我方舰娘进化时，有2%概率失败(不会返还素材)
#26 起飞舰载机有20%概率失败
#27 我方舰娘亡语效果有额外20%概率触发失败
#28 无法进行装备熔炼
#30 每回合开始时，我方舰娘损失20%血量
#31 技能书掉落概率降低50%
#32 不会刷出物资船
#33 全舰娘指定属性加成 - 绑定减益
#34 赋予敌方某个效果的同时，会额外赋予同等层数的某个效果  buffType  1.烧蚀，2.漏水, 3.烧灼 4.流血
#35 所有敌方单位开局获得某个效果
#36 装备熔炼转换系数提高10%
#37 不能使用小卖部理财功能
#38 所有PT商店商品价格
#39 五连建造价格
#40 星云舞裙价格
#41 塞壬属性加成
#42 挑战券速度
#43 科研材料获得概率
#44 我方舰娘回合结束回满血

var globalBuffTemplates = [
	{
		"desc":"{camp}阵营舰娘提高{val}%{attr}",#{camp}阵营舰娘提高{val}%{attr}
		"type":1,
		"lv":3,
		"debuff":false,
		"camp":[],
		"campDesc":null,
		"attr":{},
		"onBattleStart":true,
	},
	{
		"desc":"{shipType}舰娘提高{val}%{attr}",#{shipType}舰娘提高{val}%{attr}
		"type":2,
		"lv":3,
		"debuff":false,
		"shipType":null,
		"attr":{},
		"onBattleStart":true,
		"st":null,
	},
	{
		"desc":"{shipType}舰娘免疫负面效果",#{shipType}舰娘免疫负面效果
		"type":3,
		"lv":5,
		"buff":"b_gb_myfm",
		"shipType":null,
		"st":null,
		"onBattleStart":true,
	},
	{
		"desc":"{shipType}舰娘每回合免疫3次致命伤害",#{shipType}舰娘每回合免疫2次致命伤害
		"type":3,
		"lv":2,
		"buff":"b_gb_mysh",
		"num":3,
		"shipType":null,
		"st":null,
		"onBattleStart":true,
	},
	{
		"desc":"任何渠道获得的pt点数提高30%",
		"type":5,
		"lv":4,
		"num":1.3,
		"onGameStart":true,
	},
	{
		"desc":"开局不再获得装备和金币，而是获得一个随机传奇舰娘",
		"type":6,
		"lv":5,
		"resourceType":3,
		"onGameStart":true,
	},
	{
		"desc":"开局额外获得200PT",
		"type":6,
		"lv":3,
		"num":200,
		"resourceType":4,
		"onGameStart":true,
	},
	{
		"desc":"开局获得三个随机科研材料",
		"type":6,
		"lv":3,
		"num":3,
		"resourceType":5,
		"onGameStart":true,
	},
	{
		"desc":"初始PT金币兑换比例降低为1.5",
		"type":7,
		"lv":5,
		"onGameStart":true,
		"mutex":7,
		"num":1.5
	},
	{
		"desc":"每次进化舰娘有概率额外获得一个该舰娘",
		"type":9,
		"lv":5,
		"onGameStart":true,
	},
	{
		"desc":"对塞壬伤害加成40%",
		"type":10,
		"lv":3,
		"buff":"b_gb_sirenDmg",
		"num":4,
		"onBattleStart":true,
	},
	{
		"desc":"对召唤物伤害加成50%",
		"type":10,
		"lv":1,
		"buff":"b_gb_antiSumm",
		"num":5,
		"onBattleStart":true,
	},
	{
		"desc":"每层额外获得10金币",
		"type":11,
		"lv":3,
		"resourceType":2,
		"num":10,
		"onBattleStart":true,
	},
	{
		"desc":"每层额外获得5PT",
		"type":11,
		"lv":3,
		"resourceType":1,
		"num":5,
		"onBattleStart":true,
	},
	{
		"desc":"我方舰娘对非塞壬单位造成伤害时，有2%概率将其秒杀",
		"type":10,
		"lv":3,
		"buff":"b_gb_instKill",
		"onBattleStart":true,
	},
	{
		"desc":"我方舰娘使用技能时，有5%概率刷新冷却时间",
		"type":10,
		"lv":3,
		"buff":"b_gb_refresh",
		"onBattleStart":true,
	},
	{
		"desc":"每回合开始时，随机对一名敌方非塞壬单位造成[目标血上限100%]的神圣伤害",
		"type":12,
		"lv":5,
		"onBattleStart":true,
	},
	{
		"desc":"负面理财随机事件不会发生，正面理财随机事件发生概率翻倍",
		"type":15,
		"lv":2,
		"onGameStart":true,
		"mutex":37
	},
	{
		"desc":"三合一升级后的装备属性额外提高50%",
		"type":16,
		"lv":2,
		"debuff":false,
		"onGameStart":true,
		"num":1.5,
		"mutex":16
	},
	{
		"desc":"五连建造获得高级角色的概率+4%",
		"type":17,
		"lv":2,
		"onGameStart":true,
	},
	{
		"desc":"指挥官初始军衔为上尉并额外获得8点经验",
		"type":18,
		"lv":2,
		"onGameStart":true,
		"mutex":29
	},
	{
		"desc":"我方舰载机经验获得速度提高100%",
		"type":19,
		"lv":2,
		"onGameStart":true,
	},
	{
		"desc":"我方舰娘获得圣盾时，额外获得1层圣盾",
		"type":20,
		"lv":2,
		"onGameStart":true,
	},
	{
		"desc":"我方舰娘获得的护盾+35%",
		"type":21,
		"lv":2,
		"onGameStart":true,
	},
	{
		"desc":"我方舰娘的亡语技能触发时，25%再次触发",
		"type":22,
		"lv":3,
		"onGameStart":true,
	},
	{
		"desc":"我方舰娘提高30%冷却速度",
		"type":33,
		"lv":3,
		"debuff":false,
		"attr":["cd"],
		"val":0.3,
		"bind":1,
		"onBattleStart":true,
	},
	{
		"desc":"赋予敌方<漏水>效果时，额外使其获得同等层数<流血>",
		"type":34,
		"lv":2,
		"debuff":false,
		"onBattleStart":true,
		"buffType1":"b_louShui",
		"buffType2":"b_liuXue_r",
	},
	{
		"desc":"赋予敌方<烧蚀>效果时，额外使其获得同等层数<流血>",
		"type":34,
		"lv":2,
		"debuff":false,
		"onBattleStart":true,
		"buffType1":"b_shaoShi",
		"buffType2":"b_liuXue_r",
	},
	{
		"desc":"我方舰娘阵亡时，获得12金币",
		"type":10,
		"lv":3,
		"buff":"b_gb_deathGold1",
		"debuff":false,
		"onBattleStart":true,
	},
	{
		"desc":"装备熔炼转化系数提高15%",
		"type":36,
		"lv":2,
		"onGameStart":true,
		"mutex":28,
		"num":0.15
	},
	{
		"desc":"PT商店商品售价降低30%",
		"type":38,
		"lv":4,
		"onGameStart":true,
		"num":-0.3,
		"mutex":38,
	},
	{
		"desc":"五连建造价格降低20%",
		"type":39,
		"lv":4,
		"onGameStart":true,
		"num":-0.2,
		"mutex":39,
	},
	{
		"desc":"星云舞裙价格降低50%",
		"type":40,
		"lv":3,
		"onGameStart":true,
		"num":-0.5,
		"mutex":38,
	},
	{
		"desc":"我方塞壬攻速提高50%，冷却速度提高50%",
		"type":41,
		"lv":3,
		"onBattleStart":true,
	},
	{
		"desc":"挑战券获得速度翻倍",
		"type":42,
		"lv":2,
		"onGameStart":true,
	},
	{
		"desc":"我方角色在回合开始时会回满血",
		"type":44,
		"lv":1,
		"onBattleStart":true,
		"mutex":30
	},
]

var globalDebuffTemplates = [
	{
		"desc":"{camp}阵营舰娘降低{val}%{attr}",
		"type":1,
		"lv":3,
		"debuff":true,
		"camp":[],
		"campDesc":null,
		"attr":{},
		"onBattleStart":true,
	},
	{
		"desc":"{shipType}舰娘降低{val}%{attr}",
		"type":2,
		"lv":3,
		"debuff":true,
		"shipType":null,
		"attr":{},
		"onBattleStart":true,
		"st":null,
	},
	{
		"desc":"初始PT金币兑换比例提高至3.0",
		"type":7,
		"lv":5,
		"onGameStart":true,
		"num":3
	},
	{
		"desc":"科研任务所需条件提高50%",
		"type":8,
		"lv":3,
		"debuff":true,
		"onGameStart":true,
	},
	{
		"desc":"每回合损失6金币",
		"type":11,
		"lv":3,
		"resourceType":2,
		"num":-6,
		"onBattleStart":true,
	},
	{
		"desc":"任何渠道获得的pt点数降低15%",
		"type":5,
		"lv":4,
		"num":0.85,
		"onGameStart":true,
	},
	{
		"desc":"不能使用U盘，但可以在小卖部以400金的价格出售",
		"type":24,
		"lv":5,
		"onGameStart":true,
	},
	{
		"desc":"三合一升级后的装备属性额外降低20%",
		"type":16,
		"lv":2,
		"debuff":true,
		"onGameStart":true,
		"num":0.8
	},
	{
		"desc":"我方舰娘进化时，有2%概率失败(不会返还素材)",
		"type":25,
		"lv":5,
		"onGameStart":true,
	},
	{
		"desc":"起飞舰载机有15%概率失败",
		"type":26,
		"lv":1,
		"onGameStart":true,
	},
	{
		"desc":"我方舰娘受到伤害时，有1%概率使该次伤害放大十倍",
		"type":10,
		"lv":3,
		"buff":"b_gb_critHurt",
		"onBattleStart":true,
	},
	{
		"desc":"我方舰娘承疗提高50%，额外受到25%伤害",
		"type":10,
		"lv":3,
		"buff":"b_gb_reHpHurt",
		"onBattleStart":true,
	},
	{
		"desc":"我方舰娘普攻10%几率偏离",
		"type":10,
		"lv":3,
		"buff":"b_gb_atkMiss",
		"onBattleStart":true,
	},
	{
		"desc":"我方舰娘获得增益效果时，有15%概率失败",
		"type":10,
		"lv":3,
		"buff":"b_gb_buffFail",
		"onBattleStart":true,
	},
	{
		"desc":"我方舰娘亡语效果有额外20%概率触发失败",
		"type":27,
		"lv":3,
		"onGameStart":true,
	},
	{
		"desc":"无法进行装备熔炼",
		"type":28,
		"lv":2,
		"onGameStart":true,
	},
	{
		"desc":"每回合开始时，我方舰娘损失20%血量",
		"type":30,
		"lv":5,
		"onBattleStart":true,
	},
	{
		"desc":"技能书的掉落概率降低50%",
		"type":31,
		"lv":5,
		"onGameStart":true,
	},
	{
		"desc":"不会刷出物资船",
		"type":32,
		"lv":3,
		"onGameStart":true,
	},
	{
		"desc":"我方舰娘暴击降低20%，暴击伤害提高30%",
		"type":10,
		"lv":3,
		"buff":"b_gb_cri",
		"onBattleStart":true,
	},
	{
		"desc":"我方舰娘阵亡时，50%概率损失1PT",
		"type":10,
		"lv":5,
		"buff":"b_gb_deathPT1",
		"debuff":true,
		"onBattleStart":true,
	},
	{
		"desc":"敌方舰娘战斗开始时获得5层<急速>",
		"type":35,
		"lv":1,
		"buffType":"b_jiSu_r",
		"onBattleStart":true,
		"num":5,
	},
	{
		"desc":"不能使用小卖部理财相关功能",
		"type":37,
		"lv":2,
		"onGameStart":true,
	},
	{
		"desc":"PT商店商品售价提高12%",
		"type":38,
		"lv":4,
		"onGameStart":true,
		"num":0.12
	},
	{
		"desc":"五连建造价格提高12%",
		"type":39,
		"lv":4,
		"onGameStart":true,
		"num":0.12
	},
	{
		"desc":"科研材料获得概率降低20%(和原概率乘算)",
		"type":43,
		"lv":2,
		"onGameStart":true,
		"num":-0.2
	},

]
#被其他词条绑定的负面词条
var bindedDebuffTemplate = {
	1:{
		"desc":"我方舰娘降低30%攻速",
		"type":33,
		"lv":3,
		"debuff":true,
		"attr":["spd"],
		"val":-0.3,
		"onBattleStart":true,
	}
}

#免疫负面效果
class b_gb_myfm:
	extends Buff
	var buffName = "免疫负面效果"
	var dispel = 2
	func _init():
		attInit()
		id = "b_gb_myfm"
	func _connect():
		masCha.connect("onAddBuff",self,"onAddBuff")
	func onAddBuff(buff):
		if buff.isNegetive:
			buff.isDel = true

#获得某个效果时，额外获得某效果
class b_gb_t34:
	extends Buff
	var dispel = 2
	var conf = {}
	var buffUtil = globalData.infoDs["g_azurlineBuffs"]
	func _init(conf = {}):
		attInit()
		id = "b_gb_t34"
		self.conf = conf
	func _connect():
		masCha.connect("onAddBuff",self,"onAddBuff")
	func onAddBuff(buff):
		if buff.id == conf.buffType1:
			if conf.buffType2 == "b_liuXue_r":
				masCha.addBuff(buffUtil.b_liuXue_r.new(buff.life))

class b_gb_mysh:
	extends Buff
	var dispel = 2
	var num = 0
	func _init(num = 1):
		attInit()
		id = "b_gb_mysh"
		self.num = num
	func _connect():
		masCha.connect("onHurt",self,"onHurt")
	func onHurt(atkInfo:AtkInfo):
		if atkInfo.atkCha.team == atkInfo.hitCha.team:return
		if num <= 0:
			isDel = true
			return
		else:
			num -= 1
			atkInfo.hurtVal = 0

class b_gb_hurtWd:
	extends Buff
	var dispel = 2
	var num = 0
	var flag = true
	var buffUtil = globalData.infoDs["g_azurlineBuffs"]
	func _init():
		attInit()
		id = "b_gb_hurtWd"
	func _connect():
		masCha.connect("onHurt",self,"onHurt")
	func onHurt(atkInfo:AtkInfo):
		if atkInfo.atkCha.team == atkInfo.hitCha.team or not flag:return
		if sys.rndPer(8):
			masCha.addBuff(buffUtil.b_wudi.new(1))
			flag = false
	func _upS():
		flag = true

#塞壬伤害加成
class b_gb_sirenDmg:
	extends Buff
	var buffName = "塞壬伤害加成"
	var dispel = 2
	var num = 1
	func _init(num = 1):
		attInit()
		id = "b_gb_sirenDmg"
		self.num = 0.1 * num
	func _connect():
		masCha.connect("onAtkChara",self,"_onAtkChara")
	func _onAtkChara(atkInfo:AtkInfo):
		if atkInfo.hitCha.get("camp") == "塞壬":
			atkInfo.factor += num
#反召唤物
class b_gb_antiSumm:
	extends Buff
	var buffName = "反召唤物"
	var num = 1
	var dispel = 2
	func _init(num = 1):
		attInit()
		id = "b_gb_antiSumm"
		self.num = 0.1 * num
	func _connect():
		masCha.connect("onAtkChara",self,"_onAtkChara")
	func _onAtkChara(atkInfo:AtkInfo):
		if atkInfo.hurtVal > 0 && atkInfo.hitCha.isSumm:
			atkInfo.factor += num
#秒杀
class b_gb_instKill:
	extends Buff
	var dispel = 2
	func _init():
		attInit()
		id = "b_gb_instKill"
	func _connect():
		masCha.connect("onAtkChara",self,"_onAtkChara")
	func _onAtkChara(atkInfo:AtkInfo):
		if atkInfo.hitCha.get("camp") != "塞壬" and atkInfo.hurtVal > 0 and atkInfo.hitCha.team == 2 and sys.rndPer(2):
			atkInfo.hurtVal = max(atkInfo.hitCha.att.maxHp*4, atkInfo.hurtVal)
			
#刷新技能
class b_gb_refresh:
	extends Buff
	var dispel = 2
	func _init():
		attInit()
		id = "b_gb_refresh"
	func _connect():
		masCha.connect("onCastCdSkill",self,"onCastCdSkill")
	func onCastCdSkill(id):
		if sys.rndPer(5):
			var sk = masCha.getSkill(id)
			sk.nowTime += sk.cd/(1+masCha.att.cd)

#致命受伤
class b_gb_critHurt:
	extends Buff
	var dispel = 2
	func _init():
		attInit()
		id = "b_gb_critHurt"
	func _connect():
		masCha.connect("onHurt",self,"onHurt")
	func onHurt(atkInfo:AtkInfo):
		if atkInfo.hurtVal > 0 and sys.rndPer(1):
			atkInfo.factor += 10
#加承疗承伤
class b_gb_reHpHurt:
	extends Buff
	var dispel = 2
	func _init():
		attInit()
		id = "b_gb_reHpHurt"
		att.reHp = 0.5
	func _connect():
		masCha.connect("onHurt",self,"onHurt")
	func onHurt(atkInfo:AtkInfo):
		if atkInfo.hurtVal > 0:
			atkInfo.factor += 0.25
			
#攻击偏离
class b_gb_atkMiss:
	extends Buff
	var dispel = 2
	func _init():
		attInit()
		id = "b_gb_atkMiss"
	func _connect():
		masCha.connect("onAtkChara",self,"_onAtkChara")
	func _onAtkChara(atkInfo:AtkInfo):
		if atkInfo.atkType == Chara.AtkType.NORMAL and not atkInfo.isMiss and sys.rndPer(10):
			atkInfo.isMiss = true
			atkInfo.hurtVal = 0
#增益失败
class b_gb_buffFail:
	extends Buff
	var dispel = 2
	func _init():
		attInit()
		id = "b_gb_buffFail"
	func _connect():
		masCha.connect("onAddBuff",self,"onAddBuff")
	func onAddBuff(buff:Buff):
		if not buff.isNegetive and sys.rndPer(15) and buff.get("dispel") != 2 and buff.get("dispel") != 3:
			buff.isDel = true

#降暴击加爆伤
class b_gb_cri:
	extends Buff
	var dispel = 2
	func _init():
		attInit()
		id = "b_gb_cri"
		att.cri = -0.2
		att.criR = 0.3

#动态加属性
class b_gb_dyncAttr:
	extends Buff
	var dispel = 2
	func _init(attr = ["atk"], val = 0.1):
		attInit()
		id = "b_gb_dyncAttr%s"%attr[0]
		for i in attr:
			att.set(i, val)
			
#死亡获得金币
class b_gb_deathGold1:
	extends Buff
	var dispel = 2
	func _init():
		attInit()
		id = "b_gb_deathGold1"	
	func _connect():
		masCha.connect("onDeath",self,"_onDeath")
	func _onDeath(atkInfo):
		sys.main.player.plusGold(12)
		isDel = true

#死亡损失金币
class b_gb_deathPT1:
	extends Buff
	var dispel = 2
	var azurCtrl = globalData.infoDs["g_azurline"]
	func _init():
		attInit()
		id = "b_gb_deathPT1"	
	func _connect():
		masCha.connect("onDeath",self,"_onDeath")
	func _onDeath(atkInfo):
		if sys.rndPer(50):
			azurCtrl.plusPt(-1)
		isDel = true
		