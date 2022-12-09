extends Chara
#覆盖的初始化
func _info():
	pass
#继承的初始化，技能描述在这里写，保留之前的技能描述
func _extInit():
	._extInit()#保留继承的处理
	chaName = "影魔 - 1级"
	attCoe.atkRan = 2
	attCoe.maxHp = 3
	attCoe.atk = 7
	attCoe.mgiAtk = 0
	attCoe.def = 1
	attCoe.mgiDef = 4
	lv = 2
	evos = ["ym_2"] #可以升级到的生物id
	atkEff = "atk_dao"
	addSkillTxt("毁灭阴影：每3秒，对最近三个单位造成100%物理攻击的物理伤害。")
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
		var i = 0
		for cha in chas:
			var eff1 = sys.newEff("animEff",cha.cell)
			eff.setImages(Path + "/eff/hmyy",15,false)
			hurtChara(cha,atk+(2*Soul),Chara.HurtType.PHY,AtkType.EFF)
			i += 1
			if i == 3:
				break


func _onKillChara(atkInfo):
		Soul += 1
		print(skillStrs)

func sort(a,b):
	if cellRan(a.cell,cell) < cellRan(b.cell,cell) :
        return true
    return false