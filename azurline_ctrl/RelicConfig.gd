
extends Node
func _init():
	pass

func loadBuff(name, lv = 0):
	if lv > 0:
		return get(name).new(lv)
	return get(name).new()

var buffTemplates = [
	{
		"name":"聚能环",
		"desc":"我方舰娘获得的护盾提高50%",
		"ico":"juNengHuan.png",
		"id":1,
		"debuff":false,
		"instant":true,#是否立即生效
		"num":1.5
	},
	{
		"name":"永恒信物",
		"desc":"随机获得一个遗物舰娘",
		"ico":"xinWu.png",
		"id":2,
		"debuff":false,
		"instant":true,#是否立即生效
	},
	{
		"name":"霜之哀伤",
		"desc":"霜冻效果还会降低敌方单位的法强",
		"ico":"freezeSad.png",
		"id":3,
		"debuff":false,
		"instant":true,#是否立即生效
	},
	{
		"name":"火之高兴",
		"desc":"烧蚀效果还会降低敌方单位的攻击",
		"ico":"fireHappy.png",
		"id":4,
		"debuff":false,
		"instant":true,#是否立即生效
	},
	{
		"name":"招财猫",
		"desc":"每回合获得20金币",
		"ico":"zhaoCaiMao.png",
		"id":5,
		"debuff":false,
		"instant":false,#是否立即生效
		"onBattleStart":true,
	},
	{
		"name":"聚宝盆",
		"desc":"每回合获得10PT",
		"ico":"juBaoPen.png",
		"id":6,
		"debuff":false,
		"instant":false,#是否立即生效
		"onBattleStart":true,
	},
	{
		"name":"意大利炮",
		"desc":"我方战列舰娘伤害提高30%",
		"ico":"yidaliPao.png",
		"id":7,
		"debuff":false,
		"instant":false,#是否立即生效
		"onBattleStart":true,
		"shipType":["战列"],
		"loopAlly":true,
	},
	{
		"name":"酸素可乐",
		"desc":"我方驱逐舰娘伤害提高30%",
		"ico":"suanSuCola.png",
		"id":8,
		"debuff":false,
		"instant":false,#是否立即生效
		"onBattleStart":true,
		"shipType":["驱逐"],
		"loopAlly":true,
	},
	{
		"name":"海军咖喱",
		"desc":"我方巡洋舰娘伤害提高30%",
		"ico":"navyGali.png",
		"id":9,
		"debuff":false,
		"instant":false,#是否立即生效
		"onBattleStart":true,
		"shipType":["轻巡", "重巡"],
		"loopAlly":true,
	},
	{
		"name":"弹射器",
		"desc":"我方航母舰娘冷却提高30%",
		"ico":"tanSheQi.png",
		"id":10,
		"debuff":false,
		"instant":false,#是否立即生效
		"onBattleStart":true,
		"shipType":["航母"],
		"loopAlly":true,
	},
	{
		"name":"小扳手",
		"desc":"我方辅助舰娘冷却提高30%",
		"ico":"xiaoBanShou.png",
		"id":11,
		"debuff":false,
		"instant":false,#是否立即生效
		"onBattleStart":true,
		"shipType":["辅助"],
		"loopAlly":true,
	},
	{
		"name":"仰望星空",
		"desc":"我方舰娘造成的伤害提高30%，受到的伤害提高15%",
		"ico":"yangWangXk.png",
		"id":12,
		"debuff":false,
		"instant":false,#是否立即生效
		"onBattleStart":true,
		"loopAlly":true,
	},
	{
		"name":"辣子鸡丁",
		"desc":"我方舰娘暴击降低10%，暴击伤害提高50%",
		"ico":"laziJiDing.png",
		"id":13,
		"debuff":false,
		"instant":false,#是否立即生效
		"onBattleStart":true,
		"loopAlly":true,
	},
	{
		"name":"建造装置",
		"desc":"人口上限+1",
		"ico":"jianZaoZz.png",
		"id":14,
		"debuff":false,
		"instant":true,#是否立即生效
	},
	{
		"name":"塞壬研究档案",
		"desc":"敌方塞壬战斗开始时损失30%血量",
		"ico":"sirenDoc.png",
		"id":15,
		"debuff":false,
		"instant":false,#是否立即生效
		"onBattleStart":true,
		"loopEnemy":true,
	},
	{
		"name":"飞龙探云手",
		"desc":"击杀敌方单位时，有1%概率偷取目标身上的装备",
		"ico":"feilongTys.png",
		"id":16,
		"debuff":false,
		"instant":false,#是否立即生效
		"onBattleStart":true,
		"loopAlly":true,
	},
	{
		"name":"大熔炉",
		"desc":"每件装备的可熔炼次数+2",
		"ico":"daRongLu.png",
		"id":17,
		"debuff":false,
		"instant":true,#是否立即生效
	},
	{
		"name":"高强度装甲钢",
		"desc":"我方重型装甲舰娘变为超重型装甲",
		"ico":"gaoQiangDuZjg.png",
		"id":18,
		"debuff":false,
		"instant":true,#是否立即生效
	},
	{
		"name":"精炼器",
		"desc":"任何渠道获得的pt点数提高30%",
		"ico":"jingLianQi.png",
		"id":19,
		"debuff":false,
		"instant":true,#是否立即生效
	},
	{
		"name":"浓缩魔方",
		"desc":"获得一名随机传奇舰娘",
		"ico":"nongSuoMf.png",
		"id":20,
		"debuff":false,
		"instant":true,#是否立即生效
	},
	{
		"name":"礼盒",
		"desc":"直接获得500点PT",
		"ico":"liHe.png",
		"id":21,
		"debuff":false,
		"instant":true,#是否立即生效
	},
	{
		"name":"兑换券",
		"desc":"当前PT金币兑换比例降低0.5",
		"ico":"duiHuanQuan.png",
		"id":22,
		"debuff":false,
		"instant":true,#是否立即生效
	},
	{
		"name":"进化倍增器",
		"desc":"每次进化舰娘有概率额外获得一个该舰娘",
		"ico":"jinHuaBzq.png",
		"id":23,
		"debuff":false,
		"instant":true,#是否立即生效
	},
	{
		"name":"粒子光矛",
		"desc":"我方舰娘对塞壬伤害提高50%",
		"ico":"liZiGm.png",
		"id":24,
		"debuff":false,
		"instant":false,#是否立即生效
		"onBattleStart":true,
		"loopAlly":true,
	},
	{
		"name":"蜂群导弹",
		"desc":"我方舰娘对召唤物伤害提高100%",
		"ico":"fengQunMissle.png",
		"id":25,
		"debuff":false,
		"instant":false,#是否立即生效
		"onBattleStart":true,
		"loopAlly":true,
	},
	{
		"name":"Fa♂国巨炮",
		"desc":"每回合开始时，随机对一名敌方非塞壬单位造成[目标血上限100%]的神圣伤害",
		"ico":"faJupao.png",
		"id":26,
		"debuff":false,
		"instant":false,#是否立即生效
		"onBattleStart":true,
	},
	{
		"name":"锻造锤",
		"desc":"装备三合一升级后的属性额外提高50%",
		"ico":"duanZaoChui.png",
		"id":28,
		"debuff":false,
		"instant":true,#是否立即生效
	},
	{
		"name":"高级建造器",
		"desc":"五连建造获得高级角色的概率翻倍",
		"ico":"advanceBuilder.png",
		"id":29,
		"debuff":false,
		"instant":true,#是否立即生效
	},
	{
		"name":"亡者之歌",
		"desc":"我方舰娘的亡语技能触发时，35%再次触发",
		"ico":"deathSong.png",
		"id":30,
		"debuff":false,
		"instant":true,#是否立即生效
	},
	{
		"name":"金属探测器",
		"desc":"我方舰娘阵亡时，获得12金币",
		"ico":"jinShuTcq.png",
		"id":31,
		"debuff":false,
		"instant":false,#是否立即生效
		"onBattleStart":true,
		"loopAlly":true,
	},
	{
		"name":"优惠券",
		"desc":"PT商店商品售价降低30%",
		"ico":"youHuiQuan.png",
		"id":32,
		"debuff":false,
		"instant":true,#是否立即生效
	},
	{
		"name":"打印机",
		"desc":"挑战券获得速度翻倍",
		"ico":"daYinJi.png",
		"id":33,
		"debuff":false,
		"instant":true,#是否立即生效
	},
	{
		"name":"合金装甲钢",
		"desc":"我方中型装甲舰娘变为超重型装甲",
		"ico":"daYinJi.png",
		"id":34,
		"debuff":false,
		"instant":true,#是否立即生效
	},
	{
		"name":"结界发生器",
		"desc":"我方舰娘战斗开始时获得2层<无敌>",
		"ico":"daYinJi.png",
		"id":35,
		"debuff":false,
		"instant":false,#是否立即生效
		"onBattleStart":true,
		"loopAlly":true,
	},
	{
		"name":"数据包",
		"desc":"立即获得100点科研数据",
		"ico":"daYinJi.png",
		"id":36,
		"debuff":false,
		"instant":true,#是否立即生效
	},
	{
		"name":"黑暗料理",
		"desc":"我方塞壬/余烬舰娘，成长速度提高50%",
		"ico":"daYinJi.png",
		"id":37,
		"debuff":false,
		"instant":true,#是否立即生效
	},
	{
		"name":"鼓风机",
		"desc":"装备熔炼及科研素材转化比例提高30%",
		"ico":"daYinJi.png",
		"id":38,
		"debuff":false,
		"instant":true,#是否立即生效
	},
	{
		"name":"锦鲤",
		"desc":"彩票获奖收益翻倍",
		"ico":"daYinJi.png",
		"id":39,
		"debuff":false,
		"instant":true,#是否立即生效
	},
	{
		"name":"圣经",
		"desc":"我方小口径主炮舰娘，造成伤害时，有10%概率变为神圣伤害",
		"ico":"daYinJi.png",
		"id":40,
		"debuff":false,
		"instant":false,#是否立即生效
		"onBattleStart":true,
		"loopAlly":true,
	},
	{
		"name":"水鬼",
		"desc":"敌方受到漏水效果伤害时，额外受到[血上限5%]的真实伤害",
		"ico":"daYinJi.png",
		"id":41,
		"debuff":false,
		"instant":true,#是否立即生效
	},
	{
		"name":"助学贷款",
		"desc":"小卖部贷款，只需要偿还一半本金及利息",
		"ico":"daYinJi.png",
		"id":42,
		"debuff":false,
		"instant":true,#是否立即生效
	},
	{
		"name":"限流阀",
		"desc":"我方[非召唤]角色，单次受到的伤害不超过血上限[60%]",
		"ico":"daYinJi.png",
		"id":43,
		"debuff":false,
		"instant":false,#是否立即生效
		"onBattleStart":true,
		"loopAlly":true,
	},
	{
		"name":"王牌机组",
		"desc":"我方舰载机获得30%减伤(乘算)",
		"ico":"daYinJi.png",
		"id":44,
		"debuff":false,
		"instant":false,#是否立即生效
		"onBattleStart":true,
		"loopAlly":true,
	},
]
#限流阀
class b_rel_xianliufa:
	extends Buff
	var buffName = "限流阀"
	var dispel = 2
	func _init():
		attInit()
		id = "b_rel_xianliufa"	
	func _connect():
		masCha.connect("onHurt", self, "onHurt")
	func onHurt(atkInfo):
		if atkInfo.hurtVal > masCha.att.maxHp * 0.6:
			atkInfo.hurtVal = masCha.att.maxHp * 0.6
#王牌机组
class b_rel_wangpaijz:
	extends Buff
	var dispel = 2
	func _init():
		attInit()
		id = "b_rel_wangpaijz"	
	func _connect():
		masCha.connect("summChara", self, "summChara")
	func summChara(cha):
		cha.connect("onHurt", self, "onHurt")
	func onHurt(atkInfo):
		atkInfo.hurtVal *= 0.7

#仰望星空
class b_rel_ywxk:
	extends Buff
	var buffName = "仰望星空"
	var dispel = 2
	func _init():
		attInit()
		id = "b_rel_ywxk"	
		att.atkR = 0.3
		att.defR = -0.15

#辣子鸡丁
class b_rel_lzjd:
	extends Buff
	var buffName = "辣子鸡丁"
	var dispel = 2
	func _init():
		attInit()
		id = "b_rel_lzjd"	
		att.cri = -0.1
		att.criR = 0.5

#飞龙探云手
class b_rel_fltys:
	extends Buff
	var buffName = "飞龙探云手"
	var dispel = 2
	func _init():
		attInit()
		id = "b_rel_fltys"	
	func _connect():
		masCha.connect("onKillChara", self, "onKillChara")
	func onKillChara(atkInfo):
		if not atkInfo.hitCha.items.empty() and sys.rndPer(1):
			for i in atkInfo.hitCha.items:
				sys.main.player.addItem(sys.newItem(i.id))

#粒子光矛
class b_rel_lzgm:
	extends Buff
	var buffName = "粒子光矛"
	var dispel = 2
	func _init():
		attInit()
		id = "b_rel_lzgm"
	func _connect():
		masCha.connect("onAtkChara",self,"_onAtkChara")
	func _onAtkChara(atkInfo:AtkInfo):
		if atkInfo.hitCha.get("camp") == "塞壬":
			atkInfo.factor += 0.5
#蜂群导弹
class b_rel_fqdd:
	extends Buff
	var buffName = "蜂群导弹"
	var dispel = 2
	func _init():
		attInit()
		id = "b_rel_fqdd"
	func _connect():
		masCha.connect("onAtkChara",self,"_onAtkChara")
	func _onAtkChara(atkInfo:AtkInfo):
		if atkInfo.hurtVal > 0 && atkInfo.hitCha.isSumm:
			atkInfo.factor += 1

#金属探测器
class b_rel_jstcq:
	extends Buff
	var dispel = 2
	var buffName = "金属探测器"
	func _init():
		attInit()
		id = "b_rel_jstcq"	
	func _connect():
		masCha.connect("onDeath",self,"_onDeath")
	func _onDeath(atkInfo):
		sys.main.player.plusGold(12)
		isDel = true

#圣经
class b_rel_shengJ:
	extends Buff
	var dispel = 2
	var buffName = "圣经"
	func _init():
		attInit()
		id = "b_rel_shengJ"	
	func _connect():
		masCha.connect("onAtkChara",self,"_onAtkChara")
	func _onAtkChara(atkInfo):
		if atkInfo.hurtVal > 0 and atkInfo.hitCha.team != masCha.team and sys.rndPer(10):	
			atkInfo.hitCha.forceHurtSelf(atkInfo.atkVal)
			masCha.increDmgNum(atkInfo.atkVal, "圣经", atkInfo.hitCha)
			atkInfo.hurtVal = 0