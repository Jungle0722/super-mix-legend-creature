extends Item

func init():
    name = "陨星锤"
    type = config.EQUITYPE_EQUI
    attInit()
    att.maxHp = 200
    att.atk = 50
    att.mgiAtk = 60
    info = "战斗4秒后，下一次攻击将降下陨石，对目标及周围单位造成100%魔法强度的魔法伤害和2秒的眩晕，单场战斗仅生效一次"
    
func _connect():
    masCha.connect("onAtkChara",self,"FallDown")
    sys.main.connect("onBattleStart",self,"StartBattle")

var Time = 0
var Started = false

func _upS():
    if !Started:
        Time += 1

func StartBattle():
    Time = 0
    Started = false

func FallDown(atkInfo:AtkInfo):
    if atkInfo.atkType == masCha.AtkType.NORMAL && Time >= 4:
        var eff:Eff = masCha.newEff("sk_yunShi")
        eff.position = atkInfo.hitCha.position
        var Chas = masCha.getCellChas(atkInfo.hitCha.cell,1)
        yield(sys.main.get_tree().create_timer(0.45),"timeout")
        for i in Chas:
            masCha.hurtChara(i,masCha.att.mgiAtk,masCha.HurtType.MGI)
            i.addBuff(Dt_Stun.new(1))
        Started = true
        Time = 0

class Dt_Stun extends Buff:
    func _init(lv=1):
        attInit()
        effId = "p_shaoZhuo"
        life = 3
        isNegetive=true
        id = "Dt_Stun"
    func _connect():
        connect("onSetCha",self,"_onSetCha")
    func _onSetCha():
        masCha.aiOn = false
    func _del():
        masCha.aiOn = true