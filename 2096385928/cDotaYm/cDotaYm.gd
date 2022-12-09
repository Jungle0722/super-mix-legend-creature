extends Chara
const Buffs = globalData.infoDs["g_BuffList"]
#覆盖的初始化
func _info():
	pass
#继承的初始化，技能描述在这里写，保留之前的技能描述
func _extInit():
	._extInit()#保留继承的处理
	chaName = "影魔 - 1级"
	attCoe.atkRan = 2
	attCoe.maxHp = 2
	attCoe.atk = 6
	attCoe.mgiAtk = 0
	attCoe.def = 1
	attCoe.mgiDef = 3
	lv = 1
	evos = ["ym_1"] #可以升级到的生物id
	atkEff = "atk_dao"
	addSkillTxt("[color=#FF0000][b]敏捷[/b]：这个单位的攻击速度会随着攻击力提升而提升\n")
	addSkillTxt("毁灭阴影：每3秒，对最近一个单位造成100%物理攻击的物理伤害。")
	addCdSkill("ym",3)
	addSkillTxt("支配死灵：每击杀1个单位会获得1个灵魂，每个灵魂提升毁灭阴影2点伤害。")
	addSkillTxt("当前支配的死灵数：")
#进入战斗初始化，事件连接在这里初始化
func _connect():
	._connect() #保留继承的处理

func _onBattleStart():
	addBuff(Buffs.Buff_Talnet.new(Buffs.AGILITY))
	
var Soul = 0
var Txt = "当前支配的死灵数：{souls}"

func _castCdSkill(id):
	._castCdSkill(id)
	if id == "ym":
		var chas = getAllChas(1)
		chas.sort_custom(self,"sort")
		var aim = chas[0]
		var eff1 = sys.newEff("animEff",aim.position)
		eff1.setImgs("E:\\SteamLibrary\\steamapps\\common\\Legend monster\\mods\\eff\\hmyy",15,false)
		eff1.normalSpr.position=Vector2(0, -50)
		hurtChara(aim,att.atk+(Soul*2),Chara.HurtType.PHY,Chara.AtkType.SKILL)

func _onKillChara(atkInfo):
		Soul += 1
		skillStrs[2] = Txt.format({"souls":Soul})
func sort(a,b):
	if cellRan(a.cell,cell) < cellRan(b.cell,cell) :
		return true
	return false