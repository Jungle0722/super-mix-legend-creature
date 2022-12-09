extends Item

func init():
	name = "达贡之神力"
	type = config.EQUITYPE_EQUI
	attInit()
	att.mgiAtk = 150
	att.cri = 0.3
	info = "8次攻击后，释放魔法爆发冲击目标\n造成200%魔法强度的法术伤害，可以暴击"


func _connect():
	masCha.connect("onAtkChara",self,"Ready")
	sys.main.connect("onBattleStart",self,"StartBattle")

var Nums = 0

func StartBattle():
	Nums = 0

func Ready(atkInfo:AtkInfo):
	if atkInfo.atkType == Chara.AtkType.NORMAL:
		if Nums < 8:
			Nums += 1
		if Nums == 8 :
			var eff:Eff = masCha.newEff("sk_feiDang",masCha.sprcPos)
			eff._initFlyCha(atkInfo.hitCha)
			yield(eff,"onReach")
			masCha.hurtChara(atkInfo.hitCha,masCha.att.mgiAtk*2,Chara.HurtType.MGI,Chara.AtkType.SKILL)
			if sys.rndPer(masCha.att.cri*100):
				masCha.hurtChara(atkInfo.hitCha,masCha.att.mgiAtk*2,Chara.HurtType.MGI,Chara.AtkType.SKILL)
			Nums = 0