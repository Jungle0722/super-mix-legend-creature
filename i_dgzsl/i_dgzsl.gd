extends "../azurline_base_item/azurline_base_item.gd"

func init():
	.init()
	name = "达贡之神力"
	att.mgiAtk = 150
	att.cri = 0.3
	info = "8次攻击后，释放魔法爆发冲击目标\n造成200%魔法强度的法术伤害，可以暴击"


func _connect():
	masCha.connect("onAtkChara",self,"Ready")
	sys.main.connect("onBattleStart",self,"StartBattle")

var dgNums = 0

func StartBattle():
	dgNums = 0

func Ready(atkInfo:AtkInfo):
	if atkInfo.atkType == Chara.AtkType.NORMAL:
		if dgNums < 8:
			dgNums += 1
		if dgNums == 8 :
			var eff:Eff = masCha.newEff("sk_feiDang",masCha.sprcPos)
			eff._initFlyCha(atkInfo.hitCha)
			yield(eff,"onReach")
			azurHurtChara(atkInfo.hitCha,masCha.att.mgiAtk*2,Chara.HurtType.MGI,Chara.AtkType.SKILL,"达贡之神力")
			if sys.rndPer(masCha.att.cri*100):
				azurHurtChara(atkInfo.hitCha,masCha.att.mgiAtk*2,Chara.HurtType.MGI,Chara.AtkType.SKILL,"达贡之神力")
			dgNums = 0