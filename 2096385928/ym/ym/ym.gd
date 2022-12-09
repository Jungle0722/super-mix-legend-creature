extends Chara
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
	addSkillTxt("毁灭阴影：每3秒，对最近一个单位造成100%物理攻击的物理伤害。")
	addCdSkill("ym",3)
	addSkillTxt("支配死灵：每击杀1个单位会获得1个灵魂，每个灵魂提升毁灭阴影2点伤害。")
#进入战斗初始化，事件连接在这里初始化
func _connect():
	._connect() #保留继承的处理

var Soul = 0

func _castCdSkill(id):
	._castCdSkill(id)
	if id == "ym"：
		chas = getAllChas(1)
		chas.sort_custom(self,"sort")
		aim = chas[0]
		var eff1 = sys.newEff("animEff",aim.cell)
		eff.setImages(Path + "/eff/hmyy",15,false)
		hurtChara(aim,atk,AtkType.Normal,Chara.HurtType.REAL)

func _onKillChara(atkInfo):
		Soul += 1
		print(skillStrs)

func sort(a,b):
	if cellRan(a.cell,cell) < cellRan(b.cell,cell) :
        return true
    return false